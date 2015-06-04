//
//  EDAppDelegate.m
//  Edgy Demo
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "EDAppDelegate.h"
#import <CoreLocation/CoreLocation.h>


@implementation EDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.locationManager= [[CLLocationManager alloc] init];
    // Set a delegate that receives callbacks that specify if your app is allowed to track the user's location
    self.locationManager.delegate = self;
    if(![CLLocationManager locationServicesEnabled])
    {
        NSLog(@"//You need to enable Location Services");
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        NSLog(@"//Region monitoring is not available for this Class;");
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  )
    {
        NSLog(@"//You need to authorize Location Services for the APP");
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //NOTE foreground authorization doesnt work:
        //    Error Domain=kCLErrorDomain Code=4 "The operation couldn’t be completed. (kCLErrorDomain error 4.)"
        //    [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // Check status to see if the app is authorized
    BOOL canUseLocationNotifications = (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse);
    
    if (canUseLocationNotifications) {
        [self startRegionMonitoring]; // Custom method defined below
    }
}

- (void)startRegionMonitoring {
    
    
    CLCircularRegion* region = [[CLCircularRegion alloc]
                                initWithCenter:CLLocationCoordinate2DMake(43.451268,-80.498642)
                                radius:1000.0
                                identifier:@"kitchener rangers"];
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    [self.locationManager startMonitoringForRegion: region];
    
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"entered kitchener aud");
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"left kitchener aud");
    
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"monitoring region");
    [self.locationManager requestStateForRegion:region];
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion*)region withError:(NSError*) error
{
    NSLog(@"ERROR");
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

@end
