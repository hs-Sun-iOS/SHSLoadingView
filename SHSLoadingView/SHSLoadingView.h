//
//  SHSLoadingView.h
//  SHSLoadingView
//
//  Created by sunhaosheng on 15/10/10.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHSLoadingView : UIView

/**
 *  小球的颜色数组，默认为全部黑色
 */
@property (nonatomic,copy) NSArray *colors;
/**
 *  动画速度 0~1
 */
@property (nonatomic,assign) CGFloat speed;
/**
 *  小球的半径，默认为20  10~40
 */
@property (nonatomic,assign) CGFloat radius;

/**
 *  快速初始化
 *
 *  @return 对象
 */
+ (instancetype)loadingView;
/**
 *  添加到keywindow上
 */
- (void)show;
/**
 *  添加到指定view
 */
- (void)showToView:(UIView *)view;
/**
 *  移除loadingView
 */
- (void)hide;

@end
