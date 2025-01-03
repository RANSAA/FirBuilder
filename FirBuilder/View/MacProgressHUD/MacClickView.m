//
//  MacClickView.m
//  MacProgressHUD
//
//  Created by mooer on 2018/8/27.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "MacClickView.h"

@implementation MacClickView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

/**
 重写
 mouseDown：
 rightMouseDown：
 方法并且不执行super操作，即可阻止事件传递

 */
-(void)mouseDown:(NSEvent *)theEvent
{
//    [self.delegate stopDisappear];
}

- (void)rightMouseDown:(NSEvent *)event {

}

- (void)stopHUD
{
    [self.delegate stopDisappear];
}

@end
