//
//  firstViewController.h
//  PopDemo
//
//  Created by qiansheng on 2017/5/23.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XWPresentedOneControllerDelegate <NSObject>

- (void)presentedOneControllerPressedDissmiss;
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end
@interface firstViewController : UIViewController

@property (nonatomic, assign) id<XWPresentedOneControllerDelegate> delegate;

@end
