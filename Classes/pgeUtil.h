//
//  pgeUtil.h
//  Bugs
//
//  Created by Lars Birkemose on 31/05/11.
//  Copyright Protec Electronics 2011. All rights reserved.
//
//------------------------------------------------------------------------------
// import headers

#import "cocos2d.h"
#import "TargetConditionals.h"

//------------------------------------------------------------------------------
// defines

#define UTIL_FIRST_ID				2000
#define UTIL_FPS_INTERVAL			0.5f

//------------------------------------------------------------------------------
// typedefs

typedef enum {
    IPHONE_MODEL_UNKNOWN,			// unknown model
    IPHONE_MODEL_SIMULATOR,			// simulator 
    IPHONE_MODEL_IPOD_TOUCH_GEN1,	// ipod touch 1st Gen 
    IPHONE_MODEL_IPOD_TOUCH_GEN2,	// ipod touch 2nd Gen 
    IPHONE_MODEL_IPOD_TOUCH_GEN3,	// ipod touch 3th Gen 
    IPHONE_MODEL_IPHONE,			// iphone  
	IPHONE_MODEL_IPHONE_3G,			// iphone 3G
    IPHONE_MODEL_IPHONE_3GS,		// iphone 3GS
    IPHONE_MODEL_IPHONE_4,			// iphone 4
	IPHONE_MODEL_IPAD_1,			// ipad 1 
	IPHONE_MODEL_IPAD_2,			// ipad 2 
} IPHONE_MODEL;

//------------------------------------------------------------------------------

@interface pgeUtil : NSObject {
	CGSize			m_winSize;
	CGPoint			m_screenCenter;
	int				m_id;
	NSDate*			m_startTime;
	// fps calculation
	float			m_fps;
	float			m_fpsTime;
	int				m_fpsCounter;
	
}

//------------------------------------------------------------------------------
// globals

extern pgeUtil*		UTIL;

//------------------------------------------------------------------------------
// properties

@property ( readonly ) CGSize winSize;
@property ( readonly ) CGPoint screenCenter;
@property ( readonly ) float fps;

//------------------------------------------------------------------------------
// methods

+( pgeUtil* )sharedUtil;
-( void )initialize;

-( void )service:( ccTime )dt;
-( IPHONE_MODEL )model;

-( float )randomNumber:( float )range;
-( float )randomNumberMin:( float )min max:( float )max;
-( float )angle:( CGPoint )a b:( CGPoint )b;
-( id )nextID; 
-( NSTimeInterval )gameTime;
-( void )resetGameTime;

-( int )memFree;

//------------------------------------------------------------------------------

@end