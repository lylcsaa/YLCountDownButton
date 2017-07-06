//
//  YLButton.m
//  YLCountDownButton
//
//  Created by wlx on 2017/7/5.
//  Copyright © 2017年 Tim. All rights reserved.
//
#define KLineWidth 2
#define KLineSpace 2
#define KMargin 4
#import "YLButton.h"
@interface YLButton ()<CAAnimationDelegate>
@property(nonatomic,strong)CAShapeLayer *roundLayer;
@property(nonatomic,strong)CAShapeLayer *baseLayer;
@property(nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger flyTime;
@end
@implementation YLButton
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self resetButtonFrame];
    [self drawBaseLine];
}
-(void)resetButtonFrame
{
    CGSize imageViewSize = self.imageView.image.size;
    if (imageViewSize.width > self.frame.size.width) {
        if (self.frame.size.width > self.frame.size.height) {
            imageViewSize = CGSizeMake(self.frame.size.height - 2*KMargin, self.frame.size.height - 2*KMargin);
        }else{
            imageViewSize = CGSizeMake(self.frame.size.width - 2*KMargin, self.frame.size.width - 2*KMargin);
        }
    }
    self.imageView.frame = CGRectMake((self.frame.size.width - imageViewSize.width) * 0.5, (self.frame.size.width - imageViewSize.width) * 0.5, imageViewSize.width, imageViewSize.height);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + KMargin, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.imageView.frame) + KMargin);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)drawBaseLine
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.imageView.center radius:CGRectGetWidth(self.imageView.frame)*0.5 + KLineSpace startAngle:M_PI_2*3 endAngle:M_PI_2*3 + M_PI*2 clockwise:YES];
    self.baseLayer.path = path.CGPath;
}
-(CAShapeLayer *)baseLayer
{
    if (!_baseLayer) {
        _baseLayer = [CAShapeLayer layer];
        _baseLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        _baseLayer.fillColor = [UIColor clearColor].CGColor;
        _baseLayer.lineWidth = KLineWidth;
        _baseLayer.lineCap = kCALineCapRound;
        _baseLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_baseLayer];
    }
    return _baseLayer;
}
-(CAShapeLayer *)roundLayer
{
    if (!_roundLayer) {
        _roundLayer = [CAShapeLayer layer];
        _roundLayer.strokeColor = [UIColor greenColor].CGColor;
        _roundLayer.fillColor = [UIColor clearColor].CGColor;
        _roundLayer.lineWidth = KLineWidth;
        _roundLayer.lineCap = kCALineCapRound;
        _roundLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_roundLayer];
    }
    return _roundLayer;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];

    if (!selected) {
        [self.roundLayer removeAllAnimations];
        [self.roundLayer removeFromSuperlayer];
        self.roundLayer = nil;
        [self setTitle:@"" forState:UIControlStateNormal];
        _flyTime = 0;
    }else{
        [self.layer addSublayer:self.roundLayer];
        NSInteger dt = _delayTime - 0.25*_flyTime;
        NSString *s = [NSString stringWithFormat:@"%@:%@",
                       dt >= 60 ? (dt/60 >= 10 ? [NSString stringWithFormat:@"%zd",dt/60]:[NSString stringWithFormat:@"0%zd",dt/60]): @"00",
                       dt%60 <10 ? [NSString stringWithFormat:@"0%zd",dt%60]:[NSString stringWithFormat:@"%zd",dt%60]];
        self.titleLabel.text = s;
        [self setTitle:s forState:UIControlStateSelected];

    }
}
-(void)setDelayTime:(NSInteger)delayTime
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.imageView.center radius:CGRectGetWidth(self.imageView.frame)*0.5 + KLineSpace startAngle:M_PI_2*3 endAngle:M_PI_2*3 + M_PI*2 clockwise:YES];
    self.roundLayer.path = path.CGPath;
    CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnima.duration = delayTime;
    pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnima.fillMode = kCAFillModeForwards;
    pathAnima.removedOnCompletion = NO;
    pathAnima.delegate = self;
    [self.roundLayer addAnimation:pathAnima forKey:@"strokeEndAnimation"];
    _delayTime = delayTime;
}
-(void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"动画开始");
    if (!_timer) {
        _flyTime = 0;
        _timer = [NSTimer timerWithTimeInterval:0.25 target:self selector:@selector(drawRoundLine:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"动画结束");
    [_timer invalidate];
    _timer = nil;
    [self.roundLayer removeAllAnimations];
    [self.roundLayer removeFromSuperlayer];
    self.roundLayer = nil;
    self.selected = NO;
}
-(void)setStartColor:(UIColor *)startColor
{
    _startColor = startColor;
    _roundLayer.strokeColor = startColor.CGColor;
}
-(void)drawRoundLine:(NSTimer *)timer
{
    _flyTime ++ ;
    float scale = 0.25*_flyTime/(float)(_delayTime);
    
    NSInteger dt = _delayTime - 0.25*_flyTime;
    NSString *s = [NSString stringWithFormat:@"%@:%@",
                   dt >= 60 ? (dt/60 >= 10 ? [NSString stringWithFormat:@"%zd",dt/60]:[NSString stringWithFormat:@"0%zd",dt/60]): @"00",
                   dt%60 <10 ? [NSString stringWithFormat:@"0%zd",dt%60]:[NSString stringWithFormat:@"%zd",dt%60]];
    [self setTitle:s forState:UIControlStateSelected];
    self.roundLayer.strokeColor = [self colorWithAColor:self.startColor BColor:self.endColor sCale:scale].CGColor;
}
-(UIColor*)colorWithAColor:(UIColor*)aColor BColor:(UIColor*)bColor sCale:(float)s
{
    CGColorRef acolorRef = [aColor CGColor];
    int anumComponents = (int)CGColorGetNumberOfComponents(acolorRef);
    
    int R, G, B;
    if (anumComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(acolorRef);
        R = components[0]*255;
        G = components[1]*255;
        B = components[2]*255;
    }
    CGColorRef bcolorRef = [bColor CGColor];
    int bnumComponents = (int)CGColorGetNumberOfComponents(bcolorRef);
    int r, g, b;
    if (bnumComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(bcolorRef);
        r = components[0]*255;
        g = components[1]*255;
        b = components[2]*255;
    }
    
    return [UIColor colorWithRed: (R + (r - R)*s)/255.0 green:(G + (g - G)*s)/255.0 blue:(B + (b - B)*s)/255.0 alpha:1];
}
-(void)dealloc
{
    [self.roundLayer removeAllAnimations];
    [_timer invalidate];
    _timer = nil;
}
@end
