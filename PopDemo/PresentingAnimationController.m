//
//  PresentingAnimationController.m
//  PopDemo
//
//  Created by qiansheng on 2017/5/23.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "PresentingAnimationController.h"
#import "POP.h"
@implementation PresentingAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    // fromview 是转场过程开始时的控制器
    // toview 是转场结束时的控制器
    UIView *fromview = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromview.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromview.userInteractionEnabled = NO;
    
    UIView *toview = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toview.frame = CGRectMake(0,
                              0,
                              CGRectGetWidth(transitionContext.containerView.bounds) - 100.f,
                              CGRectGetHeight(transitionContext.containerView.bounds) - 280.f);
    CGPoint p = CGPointMake(transitionContext.containerView.center.x, transitionContext.containerView.center.y);
    toview.center = p;
    [transitionContext.containerView addSubview:toview];
    POPSpringAnimation *popAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    popAnimation.toValue = @(transitionContext.containerView.center.y);
    popAnimation.springBounciness = 10;
    [popAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        [transitionContext completeTransition:YES];
    }];
    POPSpringAnimation *scalAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleX];
    scalAnimation.springBounciness = 20;
    scalAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    [toview.layer pop_addAnimation:popAnimation forKey:@"positionAniamtion"];
    [toview.layer pop_addAnimation:scalAnimation forKey:@"scaleAnimation"];
}

@end
