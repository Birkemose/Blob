//
//  pgeTilt.h
//  NightFlight
//
//  Created by Lars Birkemose on 15/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//------------------------------------------------------------------------------
// import headers

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

//------------------------------------------------------------------------------
// defines

#define TILT						[ pgeTilt sharedTilt ]

#define TILT_UPDATE_INTERVAL		0.075f
#define TILT_GRAVITY_MAX			50 // 100

//------------------------------------------------------------------------------
// pgeTilt
//------------------------------------------------------------------------------

@interface pgeTilt : NSObject < UIAccelerometerDelegate > {
	UIAccelerometer*		m_accelerometer;
	CGPoint					m_gravity;
}

//------------------------------------------------------------------------------
// properties

@property CGPoint gravity;

//------------------------------------------------------------------------------
// methods

+( id )tilt;
-( id )init;

//------------------------------------------------------------------------------

@end
