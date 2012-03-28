//
//  pgeDatalogger.h
//  Blob
//
//  Created by Lars Birkemose on 25/06/11.
//  Copyright 2011 Protec Electronics. All rights reserved.
//
//----------------------------------------------------------------
//
//  Logs data based on a time interval
//  basic logger logs
//    time
//    position
//    rotation
//    scale
//
//----------------------------------------------------------------
// import headers

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//----------------------------------------------------------------
// defines

//----------------------------------------------------------------
// typedefs

typedef struct _t_pgeLoggerData {
	CGPoint				pos;
	float				rotation;
	float				scale;
} t_pgeLoggerData;

//----------------------------------------------------------------
// interface

@interface pgeDatalogger : NSObject {
	NSTimeInterval		m_startTime;
	NSTimeInterval		m_runTime;
	t_pgeLoggerData		m_startData;
	CCArray*			m_data;
}

//----------------------------------------------------------------
// properties

@property ( readonly ) int count;

//----------------------------------------------------------------
// methods

+( id )datalogger;
-( id )init;

-( void )clear;
-( void )add:( CGPoint )pos rotation:( float )rotation scale:( float )scale;
-( void )rewind;
-( t_pgeLoggerData* )data;

//----------------------------------------------------------------

@end
