//
//  QTextAsyncLayer.m
//  PopDemo
//
//  Created by qiansheng on 2017/6/6.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "QTextAsyncLayer.h"


#import <libkern/OSAtomic.h>

static dispatch_queue_t QTextAsyncLayerGetDisplayQueue() {
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t couter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1:queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
                queues[i] = dispatch_queue_create("com.qiansheng.text.render", attr);
            }
        } else{
            for (NSUInteger i =0;  i< queueCount; i++) {
                queues[i] = dispatch_queue_create("com.qiansheng.text.render", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&couter);
    if (cur < 0) {
        cur = -cur;
    }
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}

static dispatch_queue_t QTextAsyncLayerGetReleaseQueue() {
     return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

@interface _QTextSentinel : NSObject

@property (atomic,readonly) int32_t value;

- (int32_t)increase;

@end

@implementation _QTextSentinel{
    int32_t _value;
}

- (int32_t)value {
    return _value;
}

- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}
@end

@implementation QTextAsyncLayerDisplayTask



@end

@implementation QTextAsyncLayer



@end
