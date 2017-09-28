//
//  ViewController.m
//  TextApp
//
//  Created by lx on 2017/9/26.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "ViewController.h"
#import "JLCycleBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *array =@[
                      @"http://mapi.159cai.com/uploads/170907/2-1FZG53359C5.png",
                      @"http://mapi.159cai.com/uploads/170721/2-1FH11G44XL.png",
                      @"http://mapi.159cai.com/uploads/170926/2-1F926101F1447.png",
                      @"http://mapi.159cai.com/uploads/170927/2-1F92FQ202493.png"
                      ];
    NSArray *arrayLocal =@[
                      @"2",
                      @"2",
                      @"2",
                      @"2"
                      ];
    JLCycleBannerView *bannerView = [JLCycleBannerView initCreatBannerView:CGRectMake(0,20,[UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height/3)];
    bannerView.bannerImageUrls = array;
//    bannerView.isCycleScroll = YES;
//    bannerView.timeInterval = 1.0;
    
    [self.view addSubview:bannerView];
    
    JLCycleBannerView *bannerView_other = [[JLCycleBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerView.frame)+10, bannerView.frame.size.width, bannerView.frame.size.height)];
    bannerView_other.bannerImageUrls = array;
    [self.view addSubview:bannerView_other];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
