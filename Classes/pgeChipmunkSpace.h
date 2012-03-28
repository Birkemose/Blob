//
//  pgeChipmunkScene.h
//  Blob
//
//  Created by Lars Birkemose on 26/06/11.
//  Copyright 2011 Protec Electronics. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import "GameConfig.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "pgeUtil.h"

//----------------------------------------------------------------
// defines

//----------------------------------------------------------------
// typedefs

//----------------------------------------------------------------
// interface

@interface pgeChipmunkSpace : ChipmunkSpace {

}

//----------------------------------------------------------------
// properties

//----------------------------------------------------------------
// methods

-( void )stepForward;
-( void )stepBackward:( int )speed;

//----------------------------------------------------------------

@end
