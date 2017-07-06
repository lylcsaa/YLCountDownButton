//
//  ViewController.m
//  YLCountDownButton
//
//  Created by wlx on 2017/7/5.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "ViewController.h"
#import "YLButton.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet YLButton *ylbutton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ylbutton.startColor = [UIColor greenColor];
    self.ylbutton.endColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)begain:(YLButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.delayTime = 10;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
