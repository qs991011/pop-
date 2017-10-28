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
#import "KxMovieViewController.h"
#import "PresentingAnimationController.h"
#import "FFmpegManager.h"
#import "FFmpegStreamer.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>
#import <objc/message.h>



void dynamicMethodTMP(id self, SEL _cmd){
    printf("%p", _cmd);
}

@interface NoneClass : NSObject

@end

@implementation NoneClass

+ (void)load {
    NSLog(@"NoneClass _cmd: %@",NSStringFromSelector(_cmd));
}

- (void) noneClassMethod {
    NSLog(@"NoneClass _cmd: %@",NSStringFromSelector(_cmd));
}
- (void)isSeleep{
    NSLog(@"我正在睡觉");
}

- (void)takehandle {
    NSLog(@"我就是最后的接盘侠");
}
@end
@interface rootController  ()

{
    UIView *tapview;

}

@end

@implementation rootController
__weak id reference = nil;
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
    [btn addTarget:self action:@selector(Pullflow) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    NSString *str = [NSString stringWithFormat:@"haha"];
    reference = str;
    NSLog(@"--%@",reference);
    NSString *_inner = @"123";
    NSString *sm = @"134556";
    NSString *pinjie = [sm stringByAppendingString:_inner];
}

- (void)Pullflow {
    NSString *path = @"rtmp://172.31.42.183/rtmplive/room";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([path.pathExtension isEqualToString:@"wmv"]) {
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    }
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:path parameters:parameters];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)push{
    /**
     * Protocol:  FFmpeg类库支持的协议
     * AVFormat:  FFmpeg类库支持的封装格式
     * AVCodec:   FFmpeg类库支持的编解码器
     * AVFilter:  FFmpeg类库支持的滤镜
     * Configure: FFmpeg类库的配置信息
     */
  
//    firstViewController *vc = [[firstViewController alloc] init];
//   // vc.delegate = self;
//    vc.transitioningDelegate = self;
//    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    [self presentViewController:vc animated:YES completion:nil];

     /**
    char info[40000]={0};
    av_register_all();
    
    struct URLProtocol *pup = NULL;
    //Input
    struct URLProtocol **p_temp = &pup;
    avio_enum_protocols((void **)p_temp, 0);
    while ((*p_temp) != NULL){
        sprintf(info, "%s[In ][%10s]\n", info, avio_enum_protocols((void **)p_temp, 0));
    }
    pup = NULL;
    //Output
    avio_enum_protocols((void **)p_temp, 1);
    while ((*p_temp) != NULL){
        sprintf(info, "%s[Out][%10s]\n", info, avio_enum_protocols((void **)p_temp, 1));
    }
    //printf("%s", info);
    NSString * info_ns = [NSString stringWithFormat:@"%s", info];
    NSLog(@"%@",info_ns);
      
      */
    /**
     char info[40000] = { 0 };
     av_register_all();
     
     AVInputFormat *if_temp = av_iformat_next(NULL);
     AVOutputFormat *of_temp = av_oformat_next(NULL);
     
     while (if_temp != NULL) {
     sprintf(info, "%s[In ]%10s\n",info,if_temp->name);
     if_temp = if_temp->next;
     }
     
     while (of_temp != NULL) {
     sprintf(info, "%s[Out]%10s\n",info,of_temp->name);
     of_temp = of_temp->next;
     }
     
     NSString *info_ns = [NSString stringWithFormat:@"%s",info];
     NSLog(@"%@",info_ns);
     */
    
    
    FFmpegManager *manage =  [[FFmpegManager alloc] init];
    manage.inputurl = @"test.mp4";
    manage.outputurl = @"trest.yuv";
    [manage  TransferDecode];
   // FFmpegStreamer *streamer = [[FFmpegStreamer alloc] init];
   // streamer.inputurl = @"test.mp4";
   // streamer.outputurl = @"rtmp://192.168.2.9:1935/rtmplive/room";
    //[streamer pushStream];
     //NSLog(@"++--%@",reference);
      //[self isSeleep];
    
}

/**
  一号接盘侠
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(isSeleep)) {
        class_addMethod(self, sel, (IMP)dynamicMethodTMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
 二号接盘侠
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%@",NSStringFromSelector(aSelector));
    NoneClass *none = [[NoneClass alloc] init];
    if ([none respondsToSelector:aSelector]) {
        return none;
    }
    return [super forwardingTargetForSelector:aSelector];
}
 三号接盘侠
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel isEqualToString:@"isSeleep"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation{
    SEL selector = [anInvocation selector];
    NoneClass *none = [[NoneClass alloc] init];
    if ([none respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:none];
    }
}
 
*/

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//     NSLog(@"--++%@",reference);
//}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//     NSLog(@"--////%@",reference);
//}
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
