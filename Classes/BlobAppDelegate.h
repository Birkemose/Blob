//
//  BlobAppDelegate.h
//  Blob
//
//  Created by Lars Birkemose on 20/06/11.
//  Copyright Protec Electronics 2011. All rights reserved.
//
//----------------------------------------------------------------
// import headers

#import <UIKit/UIKit.h>

//----------------------------------------------------------------
// defines

//----------------------------------------------------------------
// typedefs

//----------------------------------------------------------------
// interface

@class RootViewController;

@interface BlobAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

//----------------------------------------------------------------
// properties

@property (nonatomic, retain) UIWindow *window;

//----------------------------------------------------------------
// methods

//----------------------------------------------------------------

@end
