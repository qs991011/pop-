//
//  QSImageCoder.m
//  PopDemo
//
//  Created by qiansheng on 2017/9/6.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "QSImageCoder.h"
#import <ImageIO/ImageIO.h>

#define QS_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define YY_TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))
QSImageType QSImageDetecType(CFDataRef data) {
    if (!data) return QSImageTypeUnknown;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return QSImageTypeUnknown;
    const char *bytes = (char*)CFDataGetBytePtr(data);
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case QS_FOUR_CC(0x4d, 0x4D, 0x00, 0x2A):{
            return QSImageTypeTIFF;
            
        }break;
        case QS_FOUR_CC(0X49, 0x49, 0x2A, 0x00):{
            return QSImageTypeTIFF;
        }break;
        case QS_FOUR_CC(0X00, 0X00, 0x01, 0x00):{
            return QSImageTypeICO;
        }break;
        case QS_FOUR_CC(0x00, 0x00, 0x20, 0x00):{
            return QSImageTypeICNS;
        }break;
        case QS_FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return QSImageTypeGIF;
        } break;
            
        case QS_FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == QS_FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return QSImageTypePNG;
            }
        } break;
            
        case QS_FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == QS_FOUR_CC('W', 'E', 'B', 'P')) {
                return QSImageTypeWebP;
            }
        } break;
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case YY_TWO_CC('B', 'A'):
        case YY_TWO_CC('B', 'M'):
        case YY_TWO_CC('I', 'C'):
        case YY_TWO_CC('P', 'I'):
        case YY_TWO_CC('C', 'I'):
        case YY_TWO_CC('C', 'P'): { // BMP
            return  QSImageTypeBMP;
        }
        case YY_TWO_CC(0xFF, 0x4F): { // JPEG2000
            return QSImageTypeJPEG2000;
        }
    }
    //memcmp 比较内存区域buf1和buf2的前几个字节
    //buf1<buf2 返回<0
    //buf1=buf2 返回=0
    //buf1><buf2 返回>0
    if (memcmp(bytes, "\377\330\377", 3)) {
        return QSImageTypeJPEG;
    }
    if (memcmp(bytes, "\152\120\040\040\015", 5)) {
        return QSImageTypeJPEG2000;
    }
    return QSImageTypeUnknown;
    
    
}

@implementation QSImageCoder


@end
