// Support Code written by Michael D. Shah
// Last Updated: 6/15/21
// Please do not redistribute without asking permission.

// Functionality that we created
#include "SDLGraphicsProgram.hpp"
#include "Perlin.hpp"

int main(int argc, char** argv){
	
	float width = 1.0;
	float height = 1.0f;
	float lau = 2.0f;
	float t = 1. / lau;
	if(argc > 1){
	  width = atof(argv[1]);
	}
	if(argc > 2)
	  height = atof(argv[2]);
	if(argc > 3)
	  lau = atof(argv[3]);
	// Create an instance of an object for a SDLGraphicsProgram
	Perlin* per = new Perlin(width, height, lau, t);
	per->output();
	delete per;

	SDLGraphicsProgram mySDLGraphicsProgram(1280,720);
	// Run our program forever
	mySDLGraphicsProgram.Loop();
	// When our program ends, it will exit scope, the
	// destructor will then be called and clean up the program.
	return 0;
}
