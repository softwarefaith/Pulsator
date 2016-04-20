//
//  JPulsator.h
//  Pulsator
//
//  Created by 蔡杰 on 16/4/20.
//  Copyright © 2016年 蔡杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPulsator : CAReplicatorLayer

@property (nonatomic,assign) CGFloat radius;

@property (nonatomic,assign) NSUInteger numPulse;

@property (nonatomic,assign) NSTimeInterval animationDuration;

@property (nonatomic,assign) NSTimeInterval pulseInterval;

@property (nonatomic,assign) BOOL           autoRemove;

@property (nonatomic,assign) CGFloat keyTimeForHalfOpacity;

@property (nonatomic,assign) CGFloat fromValueForRadius;

@property (nonatomic,strong) CAMediaTimingFunction *timingFunction;

-(void)start;

-(void)stop;

@end
