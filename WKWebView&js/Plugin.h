//
//  Plugin.h
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface Plugin : NSObject


@property (nonatomic ,strong) WKWebView *wk;
@property (nonatomic ,assign) int taskId;
@property (nonatomic ,copy) NSString *data;

-(BOOL)callback:(NSDictionary *)value;

-(void)errorCallback:(NSString *)errorMessage;

@end
