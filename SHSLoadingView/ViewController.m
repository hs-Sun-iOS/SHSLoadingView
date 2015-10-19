//
//  ViewController.m
//  SHSLoadingView
//
//  Created by sunhaosheng on 15/10/9.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "ViewController.h"
#import "SHSLoadingView.h"


@interface ViewController () {
    SHSLoadingView *loadingView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    loadingView = [SHSLoadingView loadingView];
//    loadingView.colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
//    loadingView.radius = 30;
    [loadingView show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadingView hide];
    });
}


@end
