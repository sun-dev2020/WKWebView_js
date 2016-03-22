//
//  Plugin.m
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import "Plugin.h"

@implementation Plugin

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)callback:(NSDictionary*)value
{
    id jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
    NSString* string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (string) {
        NSString* jsString = [NSString stringWithFormat:@"fireTask(%d,'%@')", self.taskId, string];
         NSLog(@" js %@ ",jsString);
        [self.wk evaluateJavaScript:jsString completionHandler:^(id _Nullable obj, NSError* _Nullable error) {
           
        }];
        return YES;
    }

    return NO;
}

- (void)errorCallback:(NSString*)errorMessage
{
    NSString* js = [NSString stringWithFormat:@"onError(%d,'%@')", self.taskId, errorMessage];
    [self.wk evaluateJavaScript:js completionHandler:nil];
}

@end
