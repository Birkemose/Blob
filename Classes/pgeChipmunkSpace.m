//
//  pgeChipmunkScene.m
//  Blob
//
//  Created by Lars Birkemose on 26/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import "pgeChipmunkSpace.h"
#import "pgeChipmunkBody.h"

//----------------------------------------------------------------
// implementation

@implementation pgeChipmunkSpace

//----------------------------------------------------------------
// properties

//----------------------------------------------------------------
// methods
//----------------------------------------------------------------

-( id )init {
	id result;
	
	// init super
	result = [ super init ];
	// init own stuff
	
	
	// done
	return( result );
}

//----------------------------------------------------------------

-( void )stepForward {
	// step chipmunk
	[ super step:GAME_FIXED_TIMESTEP ];
	// log bodies
    for ( pgeChipmunkBody* body in self.bodies ) {
        if ( body.loggerEnable == YES ) [ body log ];
    }
}

//----------------------------------------------------------------

-( void )stepBackward:( int )speed {
	//
	if ( speed < 1 ) return;
	// rewind bodies
    for ( pgeChipmunkBody* body in self.bodies ) {
		for ( int step = 0; step < speed; step ++ ) [ body rewind ];
    }
}

//----------------------------------------------------------------

@end
