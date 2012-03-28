//
//  pgeBlob.m
//  Blob
//
//  Created by Lars Birkemose on 21/06/11.
//  Copyright 2011 Protec Electronics. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import "pgeBlob.h"
#import "pgeUtil.h"

//----------------------------------------------------------------
// implementation

@implementation pgeBlob

//----------------------------------------------------------------
// properties

@synthesize chipmunkObjects = m_chipmunkObjects;
@synthesize color = m_color;

//----------------------------------------------------------------
// methods
//----------------------------------------------------------------

+( id )blobWithRadius:( float )radius {
	return( [ [ [ self alloc] initWithRadius:radius ] autorelease ] );
}

//----------------------------------------------------------------

-( id )initWithRadius:( float )radius {
	ChipmunkShape* shape;
	float mass, angle, boxWidth;
	CGPoint pos;
	ChipmunkPivotJoint*			joint;
	ChipmunkDampedSpring*		spring;
	
	//
	self						= [ super init ];
	
	// create arrays
	m_chipmunkObjects			= [ NSMutableSet new ];
		
	// calculate mass
	mass						= BLOB_MASS;
	
	// set color
	m_color						= ccWHITE;
	
	// adjust radius
	radius -= ( BLOB_SEGMENT_SIZE / 2 );
	// create center body and shape
	m_centerBody				= [ pgeChipmunkBody bodyWithMass:mass andMoment:cpMomentForCircle( mass, 0, radius * BLOB_INNER_RADIUS_PCT / 100, CGPointZero ) ];
	m_centerBody.pos			= CGPointZero;
	[ m_chipmunkObjects addObject:m_centerBody ];
	shape						= [ ChipmunkCircleShape circleWithBody:m_centerBody radius:radius * BLOB_INNER_RADIUS_PCT / 100 offset:CGPointZero ];
	// shape.collisionType		= m_collisionID;
	[ m_chipmunkObjects addObject:shape ];
		
	// calculate width of a box
	boxWidth = 2 * M_PI * radius / BLOB_SEGMENTS * BLOB_WIDTH_MODIFIER; // << BLOB_WIDTH_MODIFIER to remove them from each others
	
	// create blob
	// loop through segments
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		// calculate new angle
		angle					= 2 * M_PI / BLOB_SEGMENTS * count;
		// calculate segment position
		pos.x					= sinf( angle ) * radius;
		pos.y					= cosf( angle ) * radius; 
		// create a body
		m_perimeterBodies[ count ]		= [ pgeChipmunkBody bodyWithMass:mass andMoment:cpMomentForBox( mass, boxWidth, BLOB_SEGMENT_SIZE ) ];
		m_perimeterBodies[ count ].angle	= -angle;
		m_perimeterBodies[ count ].pos	= pos;
		// create segment shape
		shape					= [ ChipmunkPolyShape boxWithBody:m_perimeterBodies[ count ] width:boxWidth height:BLOB_SEGMENT_SIZE ];
		shape.friction			= BLOB_FRICTION;
		shape.collisionType		= self;
		
		// add body and shape
		[ m_chipmunkObjects addObject:m_perimeterBodies[ count ] ];
		[ m_chipmunkObjects addObject:shape ];
		
	} 
	
	// create springs and joints
	// loop through segments
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		// pin holds distence between bodies

		// calculate pivot position
		angle					= 2 * M_PI / BLOB_SEGMENTS * ( ( float )count + 0.5f );
		// calculate segment position
		pos.x					= sinf( angle ) * radius;
		pos.y					= cosf( angle ) * radius; 
		
		joint					= [ ChipmunkPivotJoint pivotJointWithBodyA:m_perimeterBodies[ count ] bodyB:m_perimeterBodies[ ( count + 1 ) % BLOB_SEGMENTS ] pivot:pos ]; 
		[ m_chipmunkObjects addObject:joint ];
		
		// spring keeps perimeter in position
		spring					= [ ChipmunkDampedSpring dampedSpringWithBodyA:m_perimeterBodies[ count ] bodyB:m_centerBody anchr1:CGPointZero anchr2:CGPointZero restLength:radius stiffness:BLOB_STIFFNESS damping:BLOB_DAMPING ];	
		[ m_chipmunkObjects addObject:spring ];
	}
	
	// load skin
	m_skin = [ [ [ CCTextureCache sharedTextureCache ] addImage:BLOB_FILENAME ] retain ];

	// done
	return( self );
}

//----------------------------------------------------------------

-( void )draw {
	CGPoint segmentPos[ BLOB_SEGMENTS + 2 ];
	CGPoint texturePos[ BLOB_SEGMENTS + 2 ];
	CGPoint textureCenter;
	float angle, blobRotation;
	
	// calculate triangle fan segments
	
	segmentPos[ 0 ] = CGPointZero;
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		// get relative position and multiply for scale
		segmentPos[ count + 1 ] = ccpMult( ccpSub( m_perimeterBodies[ count ].pos, m_centerBody.pos ), BLOB_SKIN_SCALE );
	}
	segmentPos[ BLOB_SEGMENTS + 1 ] = segmentPos[ 1 ];
	
	// draw sprite
		
	// move to absolute position
	for ( int count = 0; count < ( BLOB_SEGMENTS + 2 ); count ++ ) 
		segmentPos[ count ] = ccpAdd( m_centerBody.pos, segmentPos[ count ] );

	// remap skin
	// done to be able to control skin rotation independently from blob rotation
	
#if BLOB_FACE_UP != 0
	blobRotation = [ UTIL angle:m_centerBody.pos b:m_perimeterBodies[ 0 ].pos ];
#else
    blobRotation = M_PI;
#endif
    
#if BLOB_ROTATE_GRAVITY != 0
	// blobRotation += [ UTIL angle:CGPointZero b:UTIL.gravity ];
#endif
	
	texturePos[ 0 ] = CGPointZero;
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		// calculate new angle
		angle						= blobRotation + ( 2 * M_PI / BLOB_SEGMENTS * count );
		// calculate texture position
		texturePos[ count + 1 ].x	= sinf( angle );
		texturePos[ count + 1 ].y	= cosf( angle ); 
	}
	texturePos[ BLOB_SEGMENTS + 1 ] = texturePos[ 1 ];

	// recalculate to texture coordinates
	textureCenter = CGPointMake( 0.5f, 0.5f );
	for ( int count = 0; count < ( BLOB_SEGMENTS + 2 ); count ++ ) 
		texturePos[ count ] = ccpAdd( ccpMult( texturePos[ count ], 0.5f ), textureCenter );
	 
	glColor4ub( m_color.r, m_color.g, m_color.b, 255 );
	
	glEnable( GL_TEXTURE_2D );
	glBindTexture( GL_TEXTURE_2D, [ m_skin name ] ); 
	
	// glDisableClientState( GL_TEXTURE_COORD_ARRAY );
	glDisableClientState( GL_COLOR_ARRAY );

	glTexCoordPointer( 2, GL_FLOAT, 0, texturePos );
	
	glVertexPointer( 2, GL_FLOAT, 0, segmentPos );
	
	glDrawArrays( GL_TRIANGLE_FAN, 0, BLOB_SEGMENTS + 2 );
	
	
	// return openGL states to default
	glEnableClientState( GL_COLOR_ARRAY );
	
		
}

//----------------------------------------------------------------

-( CGPoint )position {
	return( m_centerBody.pos );
}

//----------------------------------------------------------------

-( void )setPosition:( CGPoint )pos {
	CGPoint adjustment;
	
	adjustment = ccpSub( pos, m_centerBody.pos );
	m_centerBody.pos = pos;
	for ( int count = 0; count < BLOB_SEGMENTS; count ++ ) {
		m_perimeterBodies[ count ].pos = ccpAdd( m_perimeterBodies[ count ].pos, adjustment );
	}
}

//----------------------------------------------------------------

@end
