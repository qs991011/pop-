//
//  QSImageCoder.h
//  PopDemo
//
//  Created by qiansheng on 2017/9/6.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,QSImageType) {
    QSImageTypeUnknown = 0,
    QSImageTypeJPEG,
    QSImageTypeJPEG2000,
    QSImageTypeTIFF,
    QSImageTypeBMP,
    QSImageTypeICO,
    QSImageTypeICNS,
    QSImageTypeGIF,
    QSImageTypePNG,
    QSImageTypeWebP,
    QSImageTypeOther,
    
};

@interface QSImageCoder : NSObject



@end
