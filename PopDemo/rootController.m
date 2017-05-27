//
//  rootController.m
//  PopDemo
//
//  Created by 胜的钱 on 16/12/13.
//  Copyright © 2016年 胜的钱. All rights reserved.
//

#import "rootController.h"
#import "firstViewController.h"
#import "POP.h"
#import "DismissingAnimationConntroller.h"
#import "PresentingAnimationController.h"
@interface rootController  ()

{
    UIView *tapview;
}

@end

@implementation rootController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    tapview = view;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 80, 80)];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
}

- (void)push{
    firstViewController *vc = [[firstViewController alloc] init];
   // vc.delegate = self;
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)presentedOneControllerPressedDissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [DismissingAnimationConntroller new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PresentingAnimationController new];
}

- (void)tapAction:(UITapGestureRecognizer*)ges{
    POPSpringAnimation *sp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sp.toValue = [NSValue valueWithCGSize:CGSizeMake(150, 150)];
    [tapview.layer pop_addAnimation:sp forKey:@"changesize"];
}
@end
