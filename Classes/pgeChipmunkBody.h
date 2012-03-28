//
//  pgeChipmunkBody.h
//  Blob
//
//  Created by Lars Birkemose on 25/06/11.
//  Copyright 2011 Protec Electronics. All rights reserved.
//
//----------------------------------------------------------------
//
//  Expands the ChipmunkBody class to enable it to run backwards
//
//----------------------------------------------------------------
// import headers

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "pgeDatalogger.h"

//----------------------------------------------------------------
// defines

//----------------------------------------------------------------
// typedefs

//----------------------------------------------------------------
// interface

@interface pgeChipmunkBody : ChipmunkBody {
	pgeDatalogger*				m_datalogger;
	BOOL						m_loggerEnable;
}

//----------------------------------------------------------------
// properties

@property ( nonatomic ) BOOL loggerEnable;

//----------------------------------------------------------------
// methods

-( void )log;
-( void )clear;
-( void )rewind;

//----------------------------------------------------------------

@end
