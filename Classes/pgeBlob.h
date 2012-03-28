//
//  pgeBlob.h
//  Blob
//
//  Created by Lars Birkemose on 21/06/11.
//  Copyright 2011 Protec Electronics. All rights reserved.
//
//----------------------------------------------------------------
//
//  Creates a round soft body object
//
//----------------------------------------------------------------
// import headers

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "pgeChipmunkBody.h"

//----------------------------------------------------------------
// defines

#define BLOB_SEGMENTS					7 						// segments for blob 
#define BLOB_SEGMENT_SIZE				10						// thickness of segments 
#define BLOB_MASS						1.0f					// mass for object radius 100		
#define BLOB_FRICTION					0.2f
#define BLOB_INNER_RADIUS_PCT			55						// inner body radius in pct ( keeps body from collapsing )
#define BLOB_STIFFNESS					250						// spring stiffness
#define BLOB_DAMPING					0.2f					// spring damping

#define BLOB_MIN_SIZE					18
#define BLOB_MAX_SIZE					22

#define BLOB_INTER_COLLISION			0
#define BLOB_WIDTH_MODIFIER				0.99f 					// adjust for blob size ( smaller for small blobs )

#define BLOB_SKIN_SCALE					1.8f


#define BLOB_FILENAME					@"cocos2d.png"

#define BLOB_ROTATE_GRAVITY				1
#define BLOB_FACE_UP                    0

//----------------------------------------------------------------
// typedefs

//----------------------------------------------------------------
// interface

@interface pgeBlob : NSObject <ChipmunkObject> {
	NSMutableSet*				m_chipmunkObjects;
	//
	pgeChipmunkBody*			m_centerBody;
	pgeChipmunkBody*			m_perimeterBodies[ BLOB_SEGMENTS ];
	//
	CGPoint						m_position;
	ccColor3B					m_color;
	CCTexture2D*				m_skin;
}

//----------------------------------------------------------------
// properties

@property ( readonly ) NSSet* chipmunkObjects;
@property CGPoint position;
@property ccColor3B color;

//----------------------------------------------------------------
// methods

+( id )blobWithRadius:( float )radius;
-( id )initWithRadius:( float )radius;

-( void )draw;
-( CGPoint )position;
-( void )setPosition:( CGPoint )pos;

//----------------------------------------------------------------

@end
