//
//  NKFirstLaunch.m
//  Calorie
//
//  Created by Nikhil Kulkarni on 2/23/16.
//  Copyright © 2016 Nikhil Kulkarni. All rights reserved.
//

#import "NKFirstLaunch.h"

@implementation NKFirstLaunch : NSObject

+ (instancetype) init {
    static NKFirstLaunch *sharedInstance;
    if (sharedInstance != nil) {
        return sharedInstance;
    } else {
        sharedInstance = [NKFirstLaunch new];
        return sharedInstance;
    }
}

+ (BOOL) isFirstLaunch {
    BOOL isFirstLauch = false;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isFirstLauch = true;
    }
    
    return isFirstLauch;
}

@end
