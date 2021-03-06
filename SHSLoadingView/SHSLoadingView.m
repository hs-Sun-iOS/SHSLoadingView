//
//  SHSLoadingView.m
//  SHSLoadingView
//
//  Created by sunhaosheng on 15/10/10.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "SHSLoadingView.h"

#define DefaultRadius 20.0
#define DefaultSpeed 0.5
#define MaxSpeed 1.0
#define MinSpeed 0
#define MaxRadius 30.0
#define MinRadius 10.0

@interface SHSLoadingView() {
    BOOL _stop; //动画停止标志位
}

@property (nonatomic,strong) UIView *ball_1;
@property (nonatomic,strong) UIView *ball_2;
@property (nonatomic,strong) UIView *ball_3;
@property (nonatomic,strong) UIVisualEffectView *bgView;

@end

@implementation SHSLoadingView

#pragma mark - initial
+ (instancetype)loadingView {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _radius = DefaultRadius;
        _colors = [NSArray arrayWithObjects:[UIColor blackColor],[UIColor blackColor],[UIColor blackColor], nil];
        _speed = DefaultSpeed;
        _stop = YES;
    }
    return self;
}

#pragma mark - Public Method

- (void)show {
    if (_stop) {
        _stop = NO;
        UIWindow *win = [[UIApplication sharedApplication].windows firstObject];
        [win addSubview:self];
        [self startAnimation];
    }
}

- (void)showToView:(UIView *)view {
    if (_stop) {
        _stop = NO;
        if (view) {
            [view addSubview:self];
            [self startAnimation];
        } else {
            [self show];
        }
    }
}

- (void)hide {
    if (!_stop) {
        _stop = YES;
    }
}

#pragma mark - animation

- (void)startAnimation {
    self.frame = self.superview.bounds;
    [self.bgView setAlpha:1];
    [self.ball_1 setAlpha:1];
    [self.ball_2 setAlpha:1];
    [self.ball_3 setAlpha:1];
    [UIView animateWithDuration:1.0f delay:.0f usingSpringWithDamping:0.3f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.ball_1.center = CGPointMake(self.ball_2.center.x - _radius*2, self.ball_2.center.y);
        self.ball_3.center = CGPointMake(self.ball_2.center.x + _radius*2, self.ball_2.center.y);
    } completion:^(BOOL finished) {
        [self startRotateAnimation];
    }];

}

- (void)endAnimation {
    [UIView animateWithDuration:0.5f delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.ball_1.center = self.ball_2.center;
        self.ball_3.center = self.ball_2.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            if (self.superview) {
                [self removeFromSuperview];
            }
        }];
    }];
}

- (void)startRotateAnimation {
    [self startBall_1Animation];
    [self startBall_3Animation];
}

- (void)startBall_1Animation {
    UIBezierPath *ball_1_Path1 = [UIBezierPath bezierPath]; //圆的下半弧
    UIBezierPath *ball_1_path2 = [UIBezierPath bezierPath]; //圆的上半弧
    [ball_1_Path1 moveToPoint:self.ball_1.center];
    [ball_1_Path1 addArcWithCenter:self.ball_2.center radius:_radius*2 startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [ball_1_path2 addArcWithCenter:self.ball_2.center radius:_radius*2 startAngle:2*M_PI endAngle:M_PI clockwise:NO];
    [ball_1_Path1 appendPath:ball_1_path2];
    
    CAKeyframeAnimation *ball_1Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ball_1Animation.path = ball_1_Path1.CGPath;
    ball_1Animation.removedOnCompletion = NO;
   // ball_1Animation.fillMode = kCAFillModeForwards;
    ball_1Animation.calculationMode = kCAAnimationCubic;
    ball_1Animation.repeatCount = 1;
    ball_1Animation.duration = 3 * _speed;
    ball_1Animation.delegate = self;
    ball_1Animation.autoreverses = NO;
    ball_1Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball_1.layer addAnimation:ball_1Animation forKey:@"animation"];
}

- (void)startBall_3Animation {
    UIBezierPath *ball_3_Path1 = [UIBezierPath bezierPath]; //圆的上半弧
    UIBezierPath *ball_3_Path2 = [UIBezierPath bezierPath]; //圆的下半弧
    [ball_3_Path1 moveToPoint:self.ball_3.center];
    [ball_3_Path1 addArcWithCenter:self.ball_2.center radius:_radius*2 startAngle:2*M_PI endAngle:M_PI clockwise:NO];
    [ball_3_Path2 addArcWithCenter:self.ball_2.center radius:_radius*2 startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    [ball_3_Path1 appendPath:ball_3_Path2];
    
    CAKeyframeAnimation *ball_3Animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ball_3Animation.path = ball_3_Path1.CGPath;
    ball_3Animation.removedOnCompletion = NO;
   // ball_3Animation.fillMode = kCAFillModeForwards;
    ball_3Animation.calculationMode = kCAAnimationCubic;
    ball_3Animation.repeatCount = 1;
    ball_3Animation.duration = 3 * _speed;
    ball_3Animation.autoreverses = NO;
    ball_3Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.ball_3.layer addAnimation:ball_3Animation forKey:@"animation"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    [UIView animateWithDuration:0.6 * _speed animations:^{
        self.ball_1.transform = CGAffineTransformScale(self.ball_1.transform, 0.5, 0.5);
        self.ball_1.transform = CGAffineTransformTranslate(self.ball_1.transform, -_radius, 0);
        self.ball_3.transform = CGAffineTransformScale(self.ball_3.transform, 0.5, 0.5);
        self.ball_3.transform = CGAffineTransformTranslate(self.ball_3.transform, _radius, 0);
        self.ball_2.transform = CGAffineTransformScale(self.ball_2.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 * _speed delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.ball_1.transform = CGAffineTransformIdentity;
            self.ball_2.transform = CGAffineTransformIdentity;
            self.ball_3.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && !_stop) {
        [self startRotateAnimation];
    } else if (_stop){
        [self endAnimation];
    }
}

#pragma mark - HandleOrientation
- (void)didMoveToSuperview {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)willRemoveSubview:(UIView *)subview {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged {
    self.frame = self.superview.bounds;
    self.ball_2.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.ball_1.center = CGPointMake(self.ball_2.center.x - _radius*2, self.frame.size.height/2);
    self.ball_3.center = CGPointMake(self.ball_2.center.x + _radius*2, self.frame.size.height/2);
    self.bgView.center = self.ball_2.center;
}


#pragma mark - Setter Method
- (void)setRadius:(CGFloat)radius {
    if (_stop) {
        if (radius > MaxRadius) {
            radius = MaxRadius;
        } else if (radius < MinRadius) {
            radius = MinRadius;
        }
        _radius = radius;
    }
}

- (void)setSpeed:(CGFloat)speed {
    if (speed > MaxSpeed) {
        speed = MaxSpeed;
    } else if (speed < MinSpeed) {
        speed = MinSpeed;
    }
    _speed = 1 - speed;
}

- (void)setColors:(NSArray *)colors {
    for (int i = 0; i < colors.count; i++) {
        if ([colors[i] isKindOfClass:[UIColor class]]) {
            if (i == 2) {
                _colors = [colors subarrayWithRange:NSMakeRange(0, 3)];
                break;
            }
            continue;
        } else {
            break;
        }
    }
}

#pragma mark - Getter Method
- (UIView *)ball_1 {
    if (!_ball_1) {
        _ball_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _radius*2, _radius*2)];
        _ball_1.layer.cornerRadius = _radius;
        _ball_1.backgroundColor = _colors[0];
//        _ball_1.center = CGPointMake(self.ball_2.center.x - _radius*2, self.ball_2.center.y);
        _ball_1.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

        [self insertSubview:_ball_1 atIndex:1];
    }
   
    return _ball_1;
}

- (UIView *)ball_2 {
    if (!_ball_2) {
        _ball_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _radius*2, _radius*2)];
        _ball_2.layer.cornerRadius = _radius;
        _ball_2.backgroundColor = _colors[1];
        _ball_2.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self insertSubview:_ball_2 atIndex:3];
    }
    
    return _ball_2;
}

- (UIView *)ball_3 {
    if (!_ball_3) {
        _ball_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _radius*2, _radius*2)];
        _ball_3.layer.cornerRadius = _radius;
        _ball_3.backgroundColor = _colors[2];
//        _ball_3.center = CGPointMake(self.ball_2.center.x + _radius*2, self.ball_2.center.y);
        _ball_3.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self insertSubview:_ball_3 atIndex:2];
       
    }
    
    return _ball_3;
}

- (UIVisualEffectView *)bgView {
    if (!_bgView) {
        _bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _bgView.layer.cornerRadius = _radius;
        _bgView.clipsToBounds = YES;
        _bgView.frame = CGRectMake(self.ball_1.frame.origin.x - _radius, self.ball_1.frame.origin.y - _radius*2, _radius*2*4, _radius*2*3);
        _bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self insertSubview:_bgView atIndex:0];
    }
    return _bgView;
}





@end
