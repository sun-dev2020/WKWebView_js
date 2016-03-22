//
//  Accelerometer.h
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import "Plugin.h"
#import <CoreMotion/CoreMotion.h>

@interface Accelerometer : Plugin
{
    float kGravitationConstant;
}
@property(nonatomic ,strong) CMMotionManager *motionManager;
@property(nonatomic ,assign) BOOL isRunning;
@property(nonatomic ,assign) NSTimeInterval kAccelerometerInterval;

- (void)getCurrentAcceleration;

@end
