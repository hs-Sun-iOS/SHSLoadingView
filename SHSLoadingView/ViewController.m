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
    loadingView = [SHSLoadingView loadingView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [loadingView showToView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [loadingView hide];
}









@end
