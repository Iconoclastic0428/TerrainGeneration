#include "Camera.hpp"

#include "glm/gtx/transform.hpp"

#include <iostream>
#include <cmath>

void Camera::MouseLook(int mouseX, int mouseY){
	if(firstMouse){
		m_oldMousePosition.x = mouseX;
		m_oldMousePosition.y = mouseY;
		firstMouse = false;
	}
	m_viewDirection.x += (mouseX - m_oldMousePosition.x) / 100.0f;
	m_viewDirection.y += (m_oldMousePosition.y - mouseY) / 100.0f;
	m_oldMousePosition.x = mouseX;
	m_oldMousePosition.y = mouseY;
	norm = std::sqrt(std::pow(m_viewDirection.x, 2) + std::pow(m_viewDirection.z, 2));
}

// OPTIONAL TODO: 
//               The camera could really be improved by
//               updating the eye position along the m_viewDirection.
//               Think about how you can do this for a better camera!

void Camera::MoveForward(float speed){
    m_eyePosition.z += m_viewDirection.z * speed / norm;
    m_eyePosition.x += m_viewDirection.x * speed / norm;
}

void Camera::MoveBackward(float speed){
    m_eyePosition.z -= m_viewDirection.z * speed / norm;
    m_eyePosition.x -= m_viewDirection.x * speed / norm;
}

void Camera::MoveLeft(float speed){
    m_eyePosition.z -= m_viewDirection.x * speed / norm;
    m_eyePosition.x += m_viewDirection.z * speed / norm;
}

void Camera::MoveRight(float speed){
    m_eyePosition.z += m_viewDirection.x * speed / norm;
    m_eyePosition.x -= m_viewDirection.z * speed / norm;
}

void Camera::MoveUp(float speed){
    m_eyePosition.y += speed;
}

void Camera::MoveDown(float speed){
    m_eyePosition.y -= speed;
}

// Set the position for the camera
void Camera::SetCameraEyePosition(float x, float y, float z){
    m_eyePosition.x = x;
    m_eyePosition.y = y;
    m_eyePosition.z = z;
}

float Camera::GetEyeXPosition(){
    return m_eyePosition.x;
}

float Camera::GetEyeYPosition(){
    return m_eyePosition.y;
}

float Camera::GetEyeZPosition(){
    return m_eyePosition.z;
}

float Camera::GetViewXDirection(){
    return m_viewDirection.x;
}

float Camera::GetViewYDirection(){
    return m_viewDirection.y;
}

float Camera::GetViewZDirection(){
    return m_viewDirection.z;
}


Camera::Camera(){
    std::cout << "(Constructor) Created a Camera!\n";
	// Position us at the origin.
    m_eyePosition = glm::vec3(0.0f,0.0f, 0.0f);
	// Looking down along the z-axis initially.
	// Remember, this is negative because we are looking 'into' the scene.
    m_viewDirection = glm::vec3(0.0f,0.0f, -1.0f);
	// For now--our upVector always points up along the y-axis
    m_upVector = glm::vec3(0.0f, 1.0f, 0.0f);
}

glm::mat4 Camera::GetWorldToViewmatrix() const{
    // Think about the second argument and why that is
    // setup as it is.
    return glm::lookAt( m_eyePosition,
                        m_eyePosition + m_viewDirection,
                        m_upVector);
}
