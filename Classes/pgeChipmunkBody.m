//
//  pgeChipmunkBody.m
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

#import "pgeChipmunkBody.h"
#import "pgeUtil.h"

//----------------------------------------------------------------
// implementation

@implementation pgeChipmunkBody 

//----------------------------------------------------------------
// properties

@synthesize loggerEnable = m_loggerEnable;

//----------------------------------------------------------------
// methods
//----------------------------------------------------------------

-( id )initWithMass:( float )mass andMoment:( float )moment {
	id result;
	
	// create super
	result = [ super initWithMass:mass andMoment:moment ];
	
	// create own stuff
	m_datalogger = [ [ pgeDatalogger datalogger ] retain ];
	self.data = self;
	m_loggerEnable = YES;
	
	// done 
	return( result );
}

//----------------------------------------------------------------

-( void )dealloc {
	// delete own
	[ m_datalogger release ];
	// 
	[ super dealloc ];
}

//----------------------------------------------------------------

-( void )log {
	[ m_datalogger add:self.pos rotation:self.angle scale:0 ];
}

//----------------------------------------------------------------

-( void )clear {
	[ m_datalogger clear ];
}

//----------------------------------------------------------------

-( void )rewind {
	t_pgeLoggerData* data;
	
	// 
	if ( m_datalogger.count == 0 ) return;
	
	[ m_datalogger rewind ];
	data = [ m_datalogger data ];
	//
	self.pos = data->pos;
	self.angle = data->rotation;
	
	// [ self sleep ];
	
	[ self resetForces ];
	self.vel = CGPointZero;
	self.angVel = 0;
	 
}

//----------------------------------------------------------------

@end
