//
//  pgeTilt.m
//  NightFlight
//
//  Created by Lars Birkemose on 15/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//------------------------------------------------------------------------------
// import headers

#import "pgeTilt.h"

//------------------------------------------------------------------------------

@implementation pgeTilt

//------------------------------------------------------------------------------
// properties

@synthesize gravity = m_gravity;

//------------------------------------------------------------------------------
// methods
//------------------------------------------------------------------------------

+( id )tilt {
	return( [ [ [ self alloc] init ] autorelease ] );
}

//------------------------------------------------------------------------------

-( id )init {	
	// init super
	self = [ super init ];
	// init own stuff
	m_accelerometer = [ UIAccelerometer sharedAccelerometer ];
	m_accelerometer.updateInterval = TILT_UPDATE_INTERVAL;
	m_accelerometer.delegate = self;
	// default gravity
	m_gravity = CGPointMake( 0, -TILT_GRAVITY_MAX );
	// done
	return( self );
}

//------------------------------------------------------------------------------

-( void )accelerometer:( UIAccelerometer* )accelerometer didAccelerate:( UIAcceleration* )acceleration {
	m_gravity.x = acceleration.x * TILT_GRAVITY_MAX;
	m_gravity.y = acceleration.y * TILT_GRAVITY_MAX;
}

//------------------------------------------------------------------------------

@end
