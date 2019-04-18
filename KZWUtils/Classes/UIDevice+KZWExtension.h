//
//  UIDevice+KZWExtension.h
//  KZWUtils
//
//  Created by yang ou on 2019/4/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (KZWExtension)

+ (NSString *)version;

+ (NSString *)deviceBuild;

+ (NSString *)bundleId;

+ (NSString *)appName;

+ (NSString *)memory;

+ (NSString *)batteryLevel;

+ (NSString *)batteryStatus;

+ (NSString *)brightness;

+ (NSString *)jailbreak;

+ (NSString *)radioType;

+ (NSString *)mcc;

+ (NSString *)mnc;

+ (NSString *)kernelversion;

+ (NSString *)uuid;

+ (NSString *)deviceName;

+ (NSString *)platform;

+ (NSString *)osVersion;

+ (NSString *)wifiIp;

+ (NSString *)cellularIP;

+ (NSString *)wifiNetmask;

+ (NSString *)countryIso;

+ (NSString *)idfv;

+ (NSString *)idfa;

+ (NSString *)networkType;

+ (NSString *)gpsAuthStatus;

+ (NSString *)os;

+ (NSString *)networkNames;

+ (NSString *)languages;

+ (NSString *)dns;

+ (NSString *)totalSpace;

+ (NSString *)freeSpace;

+ (NSString *)carrier;

+ (NSString *)timeZone;

@end

NS_ASSUME_NONNULL_END
