//
//  DismissingAnimationConntroller.m
//  PopDemo
//
//  Created by qiansheng on 2017/5/23.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "DismissingAnimationConntroller.h"
#import "POP.h"
@implementation DismissingAnimationConntroller
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toview = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    UIView *fromview = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    toview.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    toview.userInteractionEnabled = YES;
    
    
    POPBasicAnimation *closeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    closeAnimation.toValue = @(-fromview.layer.position.y);
    [closeAnimation setCompletionBlock:^(POPAnimation *anima , BOOL finish){
        [transitionContext completeTransition:YES];
    }];
    POPSpringAnimation *scalDownAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scalDownAnimation.springBounciness = 20;
    scalDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    [fromview.layer pop_addAnimation:closeAnimation forKey:@"closeAnimation"];
    [fromview.layer pop_addAnimation:scalDownAnimation forKey:@"scaleAnimation"];
}
@end
