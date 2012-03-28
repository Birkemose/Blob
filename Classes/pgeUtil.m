//
//  pgeUtil.m
//  Bugs
//
//  Created by Lars Birkemose on 31/05/11.
//  Copyright Protec Electronics 2011. All rights reserved.
//
//------------------------------------------------------------------------------

#import "pgeUtil.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <sys/utsname.h>

//------------------------------------------------------------------------------

@implementation pgeUtil

//------------------------------------------------------------------------------
// globals

pgeUtil*			UTIL;

//------------------------------------------------------------------------------
// properties

@synthesize winSize = m_winSize;
@synthesize screenCenter = m_screenCenter;
@synthesize fps = m_fps;

//------------------------------------------------------------------------------
// methods
//------------------------------------------------------------------------------

+( pgeUtil* )sharedUtil {
    // the instance of this class is stored here
    static pgeUtil* g_sharedUtil = nil;
    // check to see if an instance already exists
    if ( g_sharedUtil == nil ) {
        g_sharedUtil = [ [ [ self class ] alloc ] init ];
		// initialize
		[ g_sharedUtil initialize ];
	}
    // return the instance of this class
    return( g_sharedUtil );
}

//------------------------------------------------------------------------------

-( void )initialize {
	// load window size
	m_winSize = [ [ CCDirector sharedDirector ] winSize ];
	// calculate screen c enter
	m_screenCenter = CGPointMake( m_winSize.width / 2, m_winSize.height / 2 );
	// 
	m_id = UTIL_FIRST_ID;
	m_startTime = [ [ NSDate date ] retain ];
	//
	m_fpsCounter = 0;
	m_fpsTime = 0;
}

//------------------------------------------------------------------------------

-( void )dealloc {
	[ m_startTime release ];
	[ super dealloc ];
}

//------------------------------------------------------------------------------

-( void )service:( ccTime )dt {
#ifdef DEBUG  
	// calculate FPS
	m_fpsTime += dt;
	m_fpsCounter ++;
	if ( m_fpsTime > UTIL_FPS_INTERVAL ) {
		m_fps = ( 1 / m_fpsTime ) * m_fpsCounter;
		m_fpsTime = 0;
		m_fpsCounter = 0;
	}
#endif
}

//------------------------------------------------------------------------------

-( float )angle:( CGPoint )a b:( CGPoint )b {
	float distance, result;
	
	// get distance between points
	distance = ccpDistance( a, b );
	// calculate angle	
	result = ( b.x - a.x ) / distance;
	if ( ( b.y - a.y ) <= 0 ) {
		result = -asinf( result );
	} else {
		result = M_PI + asinf( result );
	}
	//
	return( result );
}

//------------------------------------------------------------------------------

-( IPHONE_MODEL )model {
	NSString* modelName;
	size_t size;
	
	sysctlbyname( "hw.machine", NULL, &size, NULL, 0 ); 
	char *name = malloc( size );
	sysctlbyname( "hw.machine", name, &size, NULL, 0 );
	modelName = [ NSString stringWithCString:name encoding:NSUTF8StringEncoding ];
	free( name );
	CCLOG( @"NIGHTFLIGHT: UTIL: Model :%@", modelName );
	
    if ( [ modelName isEqualToString:@"iPhone1,1" ] == YES )			return( IPHONE_MODEL_IPHONE );
    if ( [ modelName isEqualToString:@"iPhone1,2" ] == YES )			return( IPHONE_MODEL_IPHONE_3G );
    if ( [ modelName isEqualToString:@"iPhone2,1" ] == YES )			return( IPHONE_MODEL_IPHONE_3GS );
	if ( [ modelName isEqualToString:@"iPhone3,1" ] == YES )			return( IPHONE_MODEL_IPHONE_4 );
    if ( [ modelName isEqualToString:@"iPod1,1" ] == YES )				return( IPHONE_MODEL_IPOD_TOUCH_GEN1 );
    if ( [ modelName isEqualToString:@"iPod2,1" ] == YES )				return( IPHONE_MODEL_IPOD_TOUCH_GEN2 );
    if ( [ modelName isEqualToString:@"iPod3,1" ] == YES )				return( IPHONE_MODEL_IPOD_TOUCH_GEN3 );
    if ( [ modelName isEqualToString:@"iPad1,1" ] == YES )				return( IPHONE_MODEL_IPAD_1 );
    if ( [ modelName isEqualToString:@"iPad2,1" ] == YES )				return( IPHONE_MODEL_IPAD_2 );
    if ( [ modelName isEqualToString:@"iPhone Simulator" ] == YES )		return( IPHONE_MODEL_SIMULATOR );
	return( IPHONE_MODEL_UNKNOWN );
}

//------------------------------------------------------------------------------

-( float )randomNumber:( float )range {
	return( arc4random( ) *range / 0x100000000 );
}

//------------------------------------------------------------------------------

-( float )randomNumberMin:( float )min max:( float )max {
	return( min + [ self randomNumber:( max - min ) ] ); 
}

//------------------------------------------------------------------------------

-( id )nextID {
	m_id ++;
	return( ( id )m_id );
}

//------------------------------------------------------------------------------

-( NSTimeInterval )gameTime {
	return( -[ m_startTime timeIntervalSinceNow ] );
}

//------------------------------------------------------------------------------

-( void )resetGameTime {
	[ m_startTime release ];
	m_startTime = [ [ NSDate date ] retain ];
}

//------------------------------------------------------------------------------

-( int )memFree {
	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;
	// natural_t mem_free;
	vm_statistics_data_t vm_stat;
	/*
	size_t size;
	void* bigBuffer;
	*/
	 
	// black magic
	host_port		= mach_host_self( );
	host_size		= sizeof( vm_statistics_data_t ) / sizeof( integer_t );
	host_page_size( host_port, &pagesize );
	// ask politely
	if ( host_statistics( host_port, HOST_VM_INFO, ( host_info_t )&vm_stat, &host_size ) != KERN_SUCCESS ) {
		// ups
		
	}
	//
	return( vm_stat.free_count * pagesize );
	/*
	
	// free bytes
	mem_free		= vm_stat.free_count * pagesize;
	// allocate everything, and then deallocate it, to forcememory manager to defrag
	size			= mem_free - 1024;
	bigBuffer		= malloc( size );
	bzero( bigBuffer, size );
	free( bigBuffer );
	*/
}

//------------------------------------------------------------------------------

@end

