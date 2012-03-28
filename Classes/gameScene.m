//
//  HelloWorldScene.m
//  Blob
//
//  Created by Lars Birkemose on 20/06/11.
//  Copyright Protec Electronics 2011. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import "gameScene.h"
#import "pgeTilt.h"
#import "pgeBlob.h"

//----------------------------------------------------------------
// implementation

@implementation GameLayer

//----------------------------------------------------------------
// properties

//----------------------------------------------------------------
// methods
//----------------------------------------------------------------

+( id )scene {
	// 'scene' is an autorelease object.
	CCScene* scene = [ CCScene node ];
	
	// 'layer' is an autorelease object.
	GameLayer* layer = [ GameLayer node ];
	
	// add layer as a child to scene
	[ scene addChild: layer ];
	
	// return the scene
	return( scene );
}

//----------------------------------------------------------------

-( id )init {
	ChipmunkShape* shape;
	
	self = [ super init ];
	UTIL = [ pgeUtil sharedUtil ];
    
	// load tilt
	m_tilt = [ [ pgeTilt tilt ] retain ];
	
	//
	m_blobList = [ NSMutableArray new ];
	
	// create simulation space
	m_space = [ [ [ pgeChipmunkSpace alloc ] init ] retain ];
	m_space.damping = SCENE_DAMPING;
		
    // Urk ... upcoming hardcode
    
	// create boundaries
    shape = [ ChipmunkSegmentShape segmentWithBody:[ ChipmunkBody staticBody ] from:ccp( 0, SCENE_FLOOR ) to:ccp( 0, 480 ) radius:SCENE_BOUNDS_THICKNESS ];
	shape.friction = SCENE_FRICTION;
	shape.elasticity = SCENE_ELASTICITY;
	[ m_space add:shape ];

    shape = [ ChipmunkSegmentShape segmentWithBody:[ ChipmunkBody staticBody ] from:ccp( 320, SCENE_FLOOR ) to:ccp( 320, 480 ) radius:SCENE_BOUNDS_THICKNESS ];
	shape.friction = SCENE_FRICTION;
	shape.elasticity = SCENE_ELASTICITY;
	[ m_space add:shape ];

    shape = [ ChipmunkSegmentShape segmentWithBody:[ ChipmunkBody staticBody ] from:ccp( 0, SCENE_FLOOR ) to:ccp( 320, SCENE_FLOOR ) radius:SCENE_BOUNDS_THICKNESS ];
	shape.friction = SCENE_FRICTION;
	shape.elasticity = SCENE_ELASTICITY;
	[ m_space add:shape ];

	// create obstacles
	shape = [ ChipmunkPolyShape boxWithBody:[ ChipmunkBody staticBody ] width:160 height:80 ];
	shape.body.pos = CGPointMake( 80, 200 );
	shape.friction = SCENE_FRICTION;
	shape.elasticity = SCENE_ELASTICITY;
	[ m_space add:shape ];
	
	shape = [ ChipmunkPolyShape boxWithBody:[ ChipmunkBody staticBody ] width:40 height:80 ];
	shape.body.pos = CGPointMake( 290, 200 );
	shape.friction = SCENE_FRICTION;
	shape.elasticity = SCENE_ELASTICITY;
	[ m_space add:shape ];
		
	// initialize touch 
	[ [ CCTouchDispatcher sharedDispatcher ] addTargetedDelegate:self priority:0 swallowsTouches:YES ];

	// schedule animation
	[ self schedule:@selector( animate: ) ];
	// done
	return( self );
}

//----------------------------------------------------------------

-( void )animate:( ccTime )dt {
	
	if ( [ UTIL gameTime ] < 10 ) {

		// step simulation forward
		[ m_space stepForward ];
		
	} else {

		// step simulation backward
		[ m_space stepBackward:3 ];
		
		if ( [ UTIL gameTime ] > 14 ) [ UTIL resetGameTime ];
	
	}
	
	// set gravity
	
	m_space.gravity = m_tilt.gravity;
	// m_space.gravity = CGPointZero;
	
}

//----------------------------------------------------------------

-( BOOL )ccTouchBegan:( UITouch* )touch withEvent:( UIEvent* )event {
    return( YES );
}

//----------------------------------------------------------------

-( void )ccTouchEnded:( UITouch* )touch withEvent:( UIEvent* )event {
	CGPoint pos;
	pgeBlob* blob;
	
	// get touch position and convert to screen coordinates
	pos = [ touch locationInView: [ touch view ] ];
	pos = [ [ CCDirector sharedDirector ] convertToGL:pos ];
	
	// blob = [ pgeBlob blobWithRadius:32 ]; 
	blob = [ pgeBlob blobWithRadius:22 ];
	// blob = [ pgeBlob blobWithRadius:[ UTIL randomNumberMin:30 max:40 ] ];
	blob.position = pos;
	
	// blob.color = ( ccColor3B ){ 200,   0, 128 };
	// blob.color = ( ccColor3B ){ [ UTIL randomNumber:255 ], [ UTIL randomNumber:255 ], [ UTIL randomNumber:255 ] };
	
	[ m_space add:blob ];
	[ m_blobList addObject:blob ];
	
	// remove blob self collision
#if BLOB_INTER_COLLISION == 0	
	[ m_space addCollisionHandler:self
						  typeA:blob 
						  typeB:blob
						  begin:NULL
					   preSolve:@selector( presolveBlobCollision:space: )
					  postSolve:NULL
					   separate:NULL ];		
#endif 
	
	// [ self addChild:blob.node ];
}

//----------------------------------------------------------------

-( BOOL )presolveBlobCollision:( cpArbiter* )arbiter space:( ChipmunkSpace* )space {
	return( NO );
}

//----------------------------------------------------------------

-( void )draw {
	pgeBlob* blob;
	
	
	for ( int count = 0; count < m_blobList.count; count ++ ) {
		blob = [ m_blobList objectAtIndex:count ];
		[ blob draw ];
	}

	[ super draw ];
	
	glColor4ub( 255, 255, 255, 255 );
	
	ccDrawLine( CGPointMake( 0, 240 ), CGPointMake( 160, 240 ) );
	ccDrawLine( CGPointMake( 160, 240 ), CGPointMake( 160, 160 ) );
	ccDrawLine( CGPointMake( 160, 160 ), CGPointMake( 0, 160 ) );
	
	ccDrawLine( CGPointMake( 270, 240 ), CGPointMake( 320, 240 ) );
	ccDrawLine( CGPointMake( 270, 240 ), CGPointMake( 270, 160 ) );
	ccDrawLine( CGPointMake( 270, 160 ), CGPointMake( 320, 160 ) );
	
}

//----------------------------------------------------------------


@end
