//
//  rootController.m
//  PopDemo
//
//  Created by 胜的钱 on 16/12/13.
//  Copyright © 2016年 胜的钱. All rights reserved.
//

#import "rootController.h"
#import "POP.h"

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
    
}
- (void)tapAction:(UITapGestureRecognizer*)ges{
    POPSpringAnimation *sp = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    sp.toValue = [NSValue valueWithCGSize:CGSizeMake(150, 150)];
    [tapview.layer pop_addAnimation:sp forKey:@"changesize"];
}
@end
