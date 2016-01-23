//
//  AppDelegate.m
//  ACL
//
//  Created by Vijay on 29/12/15.
//  Copyright © 2015 ACL. All rights reserved.
//

#import "AppDelegate.h"
#import <IMFCore/IMFCore.h>
#import <IMFGoogleAuthentication/IMFGoogleAuthenticationHandler.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[IMFClient sharedInstance]
     initializeWithBackendRoute:@"https://PAF.au-syd.mybluemix.net"
     backendGUID:@"f354585b-1160-43d0-ab5e-5a8ddae68068"];
    
    [[IMFGoogleAuthenticationHandler sharedInstance] registerWithDefaultDelegate];

    
    NSString *requestPath = [NSString stringWithFormat:@"%@/protected",
                             [[IMFClient sharedInstance] backendRoute]];
    
    IMFResourceRequest *request =  [IMFResourceRequest requestWithPath:requestPath
                                                                method:@"GET"];
    [[IMFAuthorizationManager sharedInstance] obtainAuthorizationHeaderWithCompletionHandler:^(IMFResponse *response, NSError *error) {
       
        NSLog(@"%@",response);
    }];
    
    [request sendWithCompletionHandler:^(IMFResponse *response, NSError *error) {
        if (error){
            NSLog(@"Error :: %@", [error description]);
        } else {
            NSLog(@"Response :: %@", [response responseText]);
        }
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[IMFGoogleAuthenticationHandler sharedInstance] handleDidBecomeActive];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication annotation: (id)annotation {
    
    BOOL shouldHandleGoogleURL = [GPPURLHandler handleURL:url
                                        sourceApplication:sourceApplication annotation:annotation];
    
    [[IMFGoogleAuthenticationHandler sharedInstance] handleOpenURL:shouldHandleGoogleURL];
    return  shouldHandleGoogleURL;
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
