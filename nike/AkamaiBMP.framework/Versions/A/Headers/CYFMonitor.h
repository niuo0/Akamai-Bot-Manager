//
//  CYFMonitor.h
//  CyberFendSDK
//
//  Copyright (c) 2015 CyberFend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_feature(modules) 
@import CoreTelephony; 
@import SystemConfiguration; 
@import CoreMotion; 
#endif
typedef NS_ENUM(NSInteger, CYFLogLevel) {
    CYFLogLevelInfo = 4,
    CYFLogLevelWarn,
    CYFLogLevelError,
    CYFLogLevelNone = 0xF
};

@interface CYFMonitor : NSObject

/*!
 Call this method to get the final sensor data string whenever you want to send this data along with
 your network requests.
 */
+ (NSString *)getSensorData;

/*! CyberFend SDK automatically starts collecting the touch events on application's key window as
 soon as application starts.

 Optionaly You can call this method if you want SDK to listen touch events for any
 additional window your application may create.Pass the window object as parameter

 Note: CyberFend SDK doesn't store the reference of this window object.
 */
+ (void)startCollectingTouchEventsOnWindow:(UIWindow *)window;

/*!
 Get the CyberFend SDK version
 */
+ (NSString *)getVersion;

/*!
 Set the log level used by the SDK.
 */
+ (void)setLogLevel:(CYFLogLevel)logLevel;

/*!
 Call this method to set the session id, api key (provided by CyberFend) and api base url of your
 application. Once you call this api CyberFend SDK start posting the sensor data to it's backend
 automatically. Set session id to nil if you want to stop auto post of sensor data to CyberFend
 backend. You can still call the getSensorData API anytime to get the sensor data and send it to
 your application's backend.

 */
+ (void)configureWithSessionId:(NSString *)sessionId
                        apiKey:(NSString *)apiKey
                 andApiBaseUrl:(NSString *)apiUrl DEPRECATED_ATTRIBUTE;

/*!
 Call this method if you want to access sensor data from thread other than main app thread
 */
+ (void)setAccessSensorDataFromBackground:(BOOL)accessSensorDataFromBackground DEPRECATED_ATTRIBUTE;

/*!
 Call this method to set sessionId
 */
+ (void)setSessionId:(NSString *)sessionId DEPRECATED_ATTRIBUTE;

/*!
 Call this method to set apiKey for SDK (This should be your public apiKey provided by CyberFend)
 */
+ (void)setApiKey:(NSString *)apiKey DEPRECATED_ATTRIBUTE;

/*!
 Call this method to set apiUrl of SDK
 */
+ (void)setApiUrl:(NSString *)apiUrl DEPRECATED_ATTRIBUTE;

@end
