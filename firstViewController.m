//
//  firstViewController.m
//  PopDemo
//
//  Created by qiansheng on 2017/5/23.
//  Copyright © 2017年 胜的钱. All rights reserved.
//

#import "firstViewController.h"
#import "POP.h"
#import "DismissingAnimationConntroller.h"
#import "PresentingAnimationController.h"
@interface firstViewController ()

@end

@implementation firstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 80, 80)];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        self.transitioningDelegate = self;
//        self.modalPresentationStyle = UIModalPresentationCustom;
//        
//    }
//    return self;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss{
//    if (_delegate && [_delegate respondsToSelector:@selector(presentedOneControllerPressedDissmiss)]) {
//        [_delegate presentedOneControllerPressedDissmiss];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
