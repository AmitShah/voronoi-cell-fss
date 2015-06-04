//
//  EDAppDelegate.h
//  Edgy Demo
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EDAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
@property(nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) UIWindow *window;


@end
