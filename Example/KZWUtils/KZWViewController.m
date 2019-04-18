//
//  KZWViewController.m
//  KZWUtils
//
//  Created by ouyrp on 12/13/2018.
//  Copyright (c) 2018 ouyrp. All rights reserved.
//

#import "KZWViewController.h"
#import <KZWUtils/KZWUtils.h>

@interface KZWViewController ()

@end

@implementation KZWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self deviceInfo];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)deviceInfo {
    NSLog(@"version:%@" ,[UIDevice version]);
    NSLog(@"deviceBuild:%@" ,[UIDevice deviceBuild]);
    NSLog(@"bundleId:%@" ,[UIDevice bundleId]);
    NSLog(@"appName:%@" ,[UIDevice appName]);
    NSLog(@"uuid:%@" ,[UIDevice uuid]);
    NSLog(@"deviceName:%@" ,[UIDevice deviceName]);
    NSLog(@"platform:%@" ,[UIDevice platform]);
    NSLog(@"osVersion:%@" ,[UIDevice osVersion]);
    NSLog(@"wifiIp:%@" ,[UIDevice wifiIp]);
    NSLog(@"wifiNetmask:%@" ,[UIDevice wifiNetmask]);
    NSLog(@"countryIso:%@" ,[UIDevice countryIso]);
    NSLog(@"idfv:%@" ,[UIDevice idfv]);
    NSLog(@"idfa:%@" ,[UIDevice idfa]);
    NSLog(@"networkType:%@" ,[UIDevice networkType]);
    NSLog(@"gpsAuthStatus:%@" ,[UIDevice gpsAuthStatus]);
    NSLog(@"os:%@" ,[UIDevice os]);
    NSLog(@"networkNames:%@" ,[UIDevice networkNames]);
    NSLog(@"languages:%@" ,[UIDevice languages]);
    NSLog(@"dns:%@" ,[UIDevice dns]);
    NSLog(@"totalSpace:%@" ,[UIDevice totalSpace]);
    NSLog(@"freeSpace:%@" ,[UIDevice freeSpace]);
    NSLog(@"carrier:%@" ,[UIDevice carrier]);
    NSLog(@"timeZone:%@" ,[UIDevice timeZone]);
    
    NSLog(@"memory:%@" ,[UIDevice memory]);
    NSLog(@"cellularIP:%@" ,[UIDevice cellularIP]);
    NSLog(@"batteryLevel:%@" ,[UIDevice batteryLevel]);
    NSLog(@"batteryStatus:%@" ,[UIDevice batteryStatus]);
    NSLog(@"brightness:%@" ,[UIDevice brightness]);
    NSLog(@"jailbreak:%@" ,[UIDevice jailbreak]);
    NSLog(@"radioType:%@" ,[UIDevice radioType]);
    NSLog(@"kernelversion:%@" ,[UIDevice kernelversion]);
    NSLog(@"mcc:%@" ,[UIDevice mcc]);
    NSLog(@"mnc:%@" ,[UIDevice mnc]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
