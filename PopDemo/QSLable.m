//
//  QSLable.m
//  PopDemo
//
//  Created by qiansheng on 2017/6/1.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "QSLable.h"

static dispatch_queue_t QLableGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

#define KLongPressMinimumDuration 0.5
#define KLongPressAllowableMovement 9.0
#define KHiglightFadeDuration 0.15
#define KAsyncFadeDuration 0.008

@implementation QSLable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
