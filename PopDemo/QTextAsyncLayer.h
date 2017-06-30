//
//  QTextAsyncLayer.h
//  PopDemo
//
//  Created by qiansheng on 2017/6/6.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class QTextAsyncLayerDisplayTask;
@interface QTextAsyncLayer : CALayer

@property BOOL  displaysAsynchronously;

@end

@protocol QTextAsyncLayerDelegate <NSObject>

- (QTextAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end

/**
 A display task used by QTextAsyncLayer to render the contents in background queue
 */
@interface QTextAsyncLayerDisplayTask : NSObject
/**
 This block will be called before the asynchonous drawing begins
 
 It will be callled on the main thread
 
 @param layer The layer
 */
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);


@property (nullable,nonatomic,copy) void (^display) (CGContextRef context, CGSize size, BOOL(^ isCancelled)(void));

@property (nullable,nonatomic,copy) void (^didDisplay) (CALayer *layer, BOOL finished);
@end
