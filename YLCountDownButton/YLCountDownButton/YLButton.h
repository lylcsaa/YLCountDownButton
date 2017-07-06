//
//  YLButton.h
//  YLCountDownButton
//
//  Created by wlx on 2017/7/5.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLButton : UIButton
/**
 **:倒计时时常
 **/
@property (nonatomic,assign)NSInteger delayTime;
/**
 **:开始颜色
 **/
@property (nonatomic,strong)UIColor *startColor;
/**
 **:结束时的颜色
 **/
@property (nonatomic,strong)UIColor *endColor;
@end
