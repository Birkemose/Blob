//
//  pgeDatalogger.m
//  Blob
//
//  Created by Lars Birkemose on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

#import "pgeDatalogger.h"
#import "pgeUtil.h"

//----------------------------------------------------------------
// implementation

@implementation pgeDatalogger

//----------------------------------------------------------------
// properties

//----------------------------------------------------------------
// methods
//----------------------------------------------------------------

+( id )datalogger {
	return( [ [ [ self alloc] init ] autorelease ] );
}

//----------------------------------------------------------------

-( id )init {
	// create own stuff
	m_data = [ CCArray new ];
	[ self clear ];
	// done
	return( self );
}

//----------------------------------------------------------------

-( void )dealloc {
	// delete own stuff
	[ self clear ];
	[ m_data release ];
	// delete super
	[ super dealloc ];
}

//----------------------------------------------------------------

-( void )clear {
	// loop and free allocated memory
	for ( int count = 0; count < m_data.count; count ++ ) {
		free( ( t_pgeLoggerData* )[ [ m_data objectAtIndex:count ] pointerValue ] );
	}
	// clear array
	[ m_data removeAllObjects ];
	// reset time
	m_startTime = [ UTIL gameTime ];
	m_runTime = 0;
}

//----------------------------------------------------------------
// add an entry if any data has changed since last

-( void )add:( CGPoint )pos rotation:( float )rotation scale:( float )scale {
	t_pgeLoggerData* data;
	
	// calculate runtime
	m_runTime			= [ UTIL gameTime ] - m_startTime;
	// check for any data changes
	if ( m_data.count > 0 ) {
		
		// data = ( t_pgeLoggerData* )[ [ m_data lastObject ] pointerValue ];
		// if ( ( data->pos.x == pos.x ) && ( data->pos.y == pos.y ) && ( data->rotation == rotation ) && ( data->scale == scale ) ) return;
	
	} else {
		// save start data
		m_startData.pos			= pos;
		m_startData.rotation	= rotation;
		m_startData.scale		= scale;
	}
	// create new data entry
	data = malloc( sizeof( t_pgeLoggerData ) );
	// fill in
	data->pos			= pos;
	data->rotation		= rotation;
	data->scale			= scale;
	// save to buffer
	[ m_data addObject:[ NSValue valueWithPointer:data ] ];
	// done
}

//----------------------------------------------------------------

-( int )count {
	return( m_data.count );
}

//----------------------------------------------------------------
// rewind to previous step

-( void )rewind {
	if ( m_data.count > 0 ) {
		free( ( t_pgeLoggerData* )[ [ m_data lastObject ] pointerValue ] );
		[ m_data removeLastObject ];
	}
}

//----------------------------------------------------------------

-( t_pgeLoggerData* )data {
	if ( m_data.count > 0 ) return( ( t_pgeLoggerData* )[ [ m_data lastObject ] pointerValue ] );
	return( &m_startData );
}

//----------------------------------------------------------------

@end
