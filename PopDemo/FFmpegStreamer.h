//
//  FFmpegStreamer.h
//  PopDemo
//
//  Created by qiansheng on 2017/7/10.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFmpegStreamer : NSObject
@property (nonatomic, copy) NSString *inputurl;
@property (nonatomic, copy) NSString *outputurl;
- (void) pushStream;
@end
