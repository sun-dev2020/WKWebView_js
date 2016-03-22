//
//  Console.m
//  WKWebView&js
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import "Console.h"

@implementation Console

- (void)log:(NSString*)string
{
    NSLog(@" console %@ ", string);
}

- (void)log2
{
    if (self.data) {
        NSLog(@" SUN >>> %@ ", self.data);
    }
}

@end
