//
//  gameScene.m
//  Blob
//
//  Created by Lars Birkemose on 20/06/11.
//  Copyright Protec Electronics 2011. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "pgeChipmunkSpace.h"
#import "pgeBlob.h"
#import "pgeTilt.h"


//----------------------------------------------------------------
// defines

#define	SCENE_BOUNDS_THICKNESS			10.0f
#define SCENE_ELASTICITY				1.0f
#define SCENE_FRICTION					0.2f

#define SCENE_FLOOR						40

#define SCENE_GRAVITY					50
#define SCENE_DAMPING					1.0

#define SCENE_TYPE_BOUNDS				( id )1
	
//----------------------------------------------------------------
// typedefs

//----------------------------------------------------------------
// interface

@interface GameLayer : CCLayer {
	pgeChipmunkSpace*			m_space;	
	NSMutableArray*				m_blobList;
	pgeTilt*					m_tilt;
}

//----------------------------------------------------------------
// properties

//----------------------------------------------------------------
// methods

+( id )scene;
-( void )animate:( ccTime )dt;

//----------------------------------------------------------------

@end
