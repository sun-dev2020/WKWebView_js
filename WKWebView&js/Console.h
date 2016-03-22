//
//  Console.h
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plugin.h"

@interface Console : Plugin


-(void)log:(NSString *)string;

-(void)log2;

@end
