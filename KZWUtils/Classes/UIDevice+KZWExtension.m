//
//  UIDevice+KZWExtension.m
//  KZWUtils
//
//  Created by yang ou on 2019/4/18.
//

#import "UIDevice+KZWExtension.h"
#import "KZWReachability.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <arpa/inet.h>
#import <dns.h>
#import <ifaddrs.h>
#import <net/if.h>
#import <netinet/in.h>
#import <resolv.h>
#import <sys/mount.h>
#import <sys/param.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

#define IOS_CELLULAR @"pdp_ip0"
#define IOS_WIFI @"en0"
#define IP_ADDR_IPv4 @"ipv4"
#define IP_ADDR_IPv6 @"ipv6"

@implementation UIDevice (KZWExtension)

+ (NSString *)version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)deviceBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)bundleId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)batteryLevel {
    CGFloat level = [[UIDevice currentDevice] batteryLevel];
    return [NSString stringWithFormat:@"%.f%%", -level * 100];
}

+ (NSString *)batteryStatus {
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    switch (state) {
        case UIDeviceBatteryStateUnknown:
            return @"Unknown";
            break;
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            break;
        case UIDeviceBatteryStateCharging:
            return @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            return @"Full";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)memory {
    return [NSString stringWithFormat:@"%llu", [NSProcessInfo processInfo].physicalMemory];
}

+ (NSString *)brightness {
    return [NSString stringWithFormat:@"%.f%%", [UIScreen mainScreen].brightness * 100];
}

+ (NSString *)jailbreak {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return @"1";
    }
    return @"0";
}

+ (NSString *)kernelversion {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
}

+ (NSString *)radioType {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    return info.currentRadioAccessTechnology;
}

+ (NSString *)mcc {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mcc = [carrier mobileCountryCode];
    return mcc;
}

+ (NSString *)mnc {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *mnc = [carrier mobileNetworkCode];
    return mnc;
}

+ (NSString *)uuid {
    return [[NSUUID UUID] UUIDString];
}

+ (NSString *)deviceName {
    return [[UIDevice currentDevice] name];
}

+ (NSString *)platform {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)osVersion {
    return [UIDevice currentDevice].systemVersion;
}

#pragma mark - cellularIP
+ (NSString *)cellularIP {
    BOOL preferIPv4 = YES;
    NSArray *searchArray = preferIPv4 ? @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] : @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        if (address)
            *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface->ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN)];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = @"ipv4";
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = @"ipv6";
                    }
                }
                if (type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - wifiIp
+ (NSString *)wifiIp {
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)wifiNetmask {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                //                NSLog(@"子网掩码:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                //                NSLog(@"本地IP:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                //                NSLog(@"广播地址:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)countryIso {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)idfv {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)idfa {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

#pragma mark - networkType
+ (NSString *)networkType {
    KZWReachability *reach = [KZWReachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable: {
            return @"UNKNOW";
        } break;
        case ReachableViaWWAN: {
            return [self getNetType];
        } break;
        case ReachableViaWiFi: {
            return @"WIFI";
        } break;
    }
    return @"UNKNOW";
}

+ (NSString *)getNetType {
    NSString *netconnType = @"";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = info.currentRadioAccessTechnology;
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
        netconnType = @"GPRS";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
        netconnType = @"2.75G EDGE";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]) {
        netconnType = @"3.5G HSDPA";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]) {
        netconnType = @"3.5G HSUPA";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]) {
        netconnType = @"2G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]) {
        netconnType = @"3G";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]) {
        netconnType = @"HRPD";
    } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]) {
        netconnType = @"4G";
    }
    return netconnType;
}

#pragma mark - gpsAuthStatus
+ (NSString *)gpsAuthStatus {
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusNotDetermined:
            return @"NotDetermined";
            break;
        case kCLAuthorizationStatusRestricted:
            return @"Restricted";
            break;
        case kCLAuthorizationStatusDenied:
            return @"Denied";
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            return @"AuthorizedAlways";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"AuthorizedWhenInUse";
            break;
        default:
            break;
    }
    return @"UNKNOW";
}

+ (NSString *)os {
    return @"iOS";
}

+ (NSString *)networkNames {
    NSString *wifiName = @"";
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return @"未知";
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        } else {
            wifiName = [wifiName stringByAppendingString:interfaceName];
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)languages {
    NSArray *languageList = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]; // 本机设置的语言列表
    NSLog(@"languageList : %@", languageList);
    NSString *languageCode = [languageList firstObject]; // 当前设置的首选语言
    NSString *countryCode = [NSString stringWithFormat:@"-%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    if (languageCode) {
        languageCode = [languageCode stringByReplacingOccurrencesOfString:countryCode withString:@""];
    }
    return languageCode;
}

+ (NSString *)dns {
    res_state res = malloc(sizeof(struct __res_state));
    int result = res_ninit(res);
    NSMutableArray *dnsArray = @[].mutableCopy;
    if (result == 0) {
        for (int i = 0; i < res->nscount; i++) {
            NSString *s = [NSString stringWithUTF8String:inet_ntoa(res->nsaddr_list[i].sin_addr)];
            [dnsArray addObject:s];
        }
    } else {
        NSLog(@"%@", @" res_init result != 0");
    }
    res_nclose(res);
    return dnsArray.firstObject;
}

+ (NSString *)totalSpace {
    float totalsize = 0.0;
    float freesize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    if (dictionary) {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue] * 1.0 / (1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue] * 1.0 / (1024);
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return [NSString stringWithFormat:@"%.f", totalsize];
}

+ (NSString *)freeSpace {
    float totalsize = 0.0;
    float freesize = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    if (dictionary) {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue] * 1.0 / (1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue] * 1.0 / (1024);
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return [NSString stringWithFormat:@"%.f", freesize];
}

+ (NSString *)carrier {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mobile;
    if (!carrier.isoCountryCode) {
        NSLog(@"没有SIM卡");
        mobile = @"无运营商";
    } else {
        mobile = [carrier carrierName];
    }
    return mobile;
}

+ (NSString *)timeZone {
    NSTimeZone *loacalZone = [NSTimeZone localTimeZone];
    NSTimeZone *systemZone = [NSTimeZone systemTimeZone];
    return loacalZone ? [loacalZone name] : [systemZone name];
}

@end
