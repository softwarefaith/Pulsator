//
//  ViewController.m
//  Pulsator
//
//  Created by 蔡杰 on 16/4/20.
//  Copyright © 2016年 蔡杰. All rights reserved.
//

#import "ViewController.h"

#import "JPulsator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    bgView.backgroundColor = [UIColor redColor];
    bgView.center = self.view.center;
    
    [self.view addSubview:bgView];
    
    JPulsator *pulsator = [[JPulsator alloc] init];
    
    pulsator.position = bgView.center;
    
    [bgView.layer addSublayer:pulsator];
    [bgView.superview.layer insertSublayer:pulsator below:bgView.layer];
    
    // Customizations
    pulsator.numPulse = 5;
    pulsator.radius = CGRectGetHeight(self.view.bounds)/2;
    pulsator.animationDuration = 2;
    pulsator.backgroundColor =[UIColor greenColor].CGColor;
    
    [pulsator start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
