//
//  QSLable.h
//  PopDemo
//
//  Created by qiansheng on 2017/6/1.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#if !TARGET_INTERFACE_BUILDER
/**
 *The qslable class implements a read-only text view
 @discussion The API and behavior is similar to UILable,but provides mor features
 It support asynchronous layout and rendering (to avoid blocking UI thread)
 It extends the CoreText attributes to support more text effects 
 It allows to add UIImage,UIView and CALayer as text attachments
 It allows to add container path and exclusion paths to control text container's shape
 It support vertical form layout to display CJK text
 
 see NSAttributedString+QSText.h for more convenience methods to set the attributes
 see QSTextAttribute.h and QSTextLayout.h for more information.
 */
@interface QSLable : UIView<NSCoding>
#pragma mark -Accessing the Text Attributes

@property (nullable,nonatomic,copy) NSString *text;


@property (null_resettable,nonatomic,strong) UIFont *font;

@property (null_resettable,nonatomic,strong) UIColor *textColor;

@property (nullable,nonatomic,strong) UIColor *shadowColor;

@property (nonatomic) CGSize shadowOffset;

@property (nonatomic) CGFloat shadowBlurRadius;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic,strong) NSAttributedString *attributedText;


@property (nonatomic) NSLineBreakMode lineBreakMode;


@property (nonatomic,strong) NSAttributedString *truncationToken;


@property (nonatomic) NSUInteger numberOfLines;


@property (nullable,nonatomic,copy) UIBezierPath *textContainerPath;

@property (nullable,nonatomic,copy) NSArray<UIBezierPath *> *exclusionPaths;

@property (nonatomic) UIEdgeInsets textContainerInset;

@property (nonatomic,getter=isVerticalForm) BOOL verticalForm;

#pragma mark -Getting the Layout Constrains


@property (nonatomic) CGFloat preferredMaxLayoutWidth;

#pragma mark Interacting with Text Data

@property (nonatomic) BOOL displayAsynchronously;

@property (nonatomic) BOOL clearContentsBeforeAsynchronouslyDisplay;

@property (nonatomic) BOOL fadeOnAsynchronouslyDispaly;

@property (nonatomic) BOOL fadeOnHightlight;

@property (nonatomic) BOOL ignoreCommonProperties;

@end
#else
IB_DESIGNABLE
@interface QSLable : UIView <NSCoding>

@property (nullable,nonatomic,copy) IBInspectable NSString *text;
@property (null_resettable,nonatomic,strong) IBInspectable UIColor  *textColor;
@property (nullable,nonatomic,strong) IBInspectable NSString *fontName;
@property (nonatomic) IBInspectable CGFloat  fontSize;
@property (nonatomic) IBInspectable BOOL fontIsBold;
@property (nonatomic) IBInspectable NSUInteger  numberOflines;
@property (nonatomic) IBInspectable NSInteger lineBreakMode;
@property (nonatomic) IBInspectable CGFloat preferredMaxLayoutWidth;
@property (nonatomic,getter=isVerticalForm) IBInspectable BOOL verticalForm;
@property (nonatomic) IBInspectable NSInteger textAligment;
@property (nonatomic) IBInspectable NSInteger textVerticalAligment;
@property (nullable,nonatomic,strong) IBInspectable UIColor *shadowColor;
@property (nullable,nonatomic,copy) IBInspectable NSAttributedString *attributedText;
@property (nonatomic) IBInspectable CGFloat insetTop_;
@property (nonatomic) IBInspectable CGFloat insetBottom_;
@property (nonatomic) IBInspectable CGFloat insetLeft_;
@property (nonatomic) IBInspectable CGFloat insetRight_;
@property (nonatomic) IBInspectable BOOL debugEnabled;

@property (null_resettable,nonatomic,strong)  UIFont *font;
@property (nullable,nonatomic,copy) NSAttributedString *truncationToken;
@property (nullable,nonatomic,copy) UIBezierPath *textContainerPath;
@property (nullable,nonatomic,copy) NSArray<UIBezierPath*> exclusionPaths;
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nonatomic) BOOL displaysAsynchronously;
@property (nonatomic) BOOL clearContentsBeforeAsynchronouslyDisplay;
@property (nonatomic) BOOL fadeOnAsynchronouslyDisplay;
@property (nonatomic) BOOL ignoreCommonProperties;
@end
#endif//!TARGET_INTERFACE_BUILDER

NS_ASSUME_NONNULL_END
