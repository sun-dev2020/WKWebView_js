//
//  Accelerometer.m
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kAccelerometerInterval = 10;
        kGravitationConstant = -9.81;
    }
    return self;
}

- (void)getCurrentAcceleration
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    if (_motionManager.accelerometerAvailable) {
        _motionManager.accelerometerUpdateInterval = _kAccelerometerInterval / 1000;
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData* _Nullable accelerometerData, NSError* _Nullable error) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            dic[@"x"] = @(accelerometerData.acceleration.x * kGravitationConstant);
            dic[@"y"] = @(accelerometerData.acceleration.y * kGravitationConstant);
            dic[@"z"] = @(accelerometerData.acceleration.z * kGravitationConstant);
            dic[@"timestamp"] = [[NSDate alloc] initWithTimeIntervalSince1970:0];
            if ([self callback:dic]) {
                [self.motionManager stopAccelerometerUpdates];
            }
        }];
        if (!_isRunning) {
            _isRunning = true;
        }
    }
    else {
        [self errorCallback:@"acceleromrter not available"];
    }if (!_isRunning) {
        _isRunning = true;
    }
}

@end
