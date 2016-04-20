//
//  JPulsator.m
//  Pulsator
//
//  Created by 蔡杰 on 16/4/20.
//  Copyright © 2016年 蔡杰. All rights reserved.
//

#import "JPulsator.h"

static NSString *const kPulsatorAnimationKey = @"pulsator";

@interface JPulsator ()

@property (nonatomic,strong) CALayer *pulse;
@property (nonatomic,strong,nonnull) CAAnimationGroup  *animationGroup;
@property (nonatomic,assign) CGFloat  alpha;

@end

@implementation JPulsator

-(instancetype)init{
    
    if (self = [super init]) {
        _alpha = 0.45;
        _numPulse = 1;
        _animationDuration = 3.0f;
        _radius = 60.0f;
        _keyTimeForHalfOpacity = 0.2;
        _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        super.backgroundColor = [UIColor colorWithHue:0 saturation:0.455 brightness:0.756 alpha: 0.45].CGColor;
        super.repeatCount = MAXFLOAT;
        [self setupPulse];
    }
    return self;
}

#pragma mark --OverRide  Set
-(void)setBackgroundColor:(CGColorRef)aBackgroundColor{
    
    super.backgroundColor= aBackgroundColor;
    _pulse.backgroundColor = aBackgroundColor;
    _alpha = CGColorGetAlpha(aBackgroundColor);
    CGFloat oldAlpha = _alpha;
    if (_animationGroup && _alpha != oldAlpha) {
        [self receate];
    }
}
-(void)setRepeatCount:(float)repeatCount{
    super.repeatCount = repeatCount;
    if (_animationGroup) {
        _animationGroup.repeatCount = repeatCount;
    }
}

-(void)setNumPulse:(NSUInteger)numPulse{
    
    _numPulse = numPulse;
    self.instanceCount = numPulse;
    
}
-(void)setAnimationDuration:(NSTimeInterval)animationDuration{
    _animationDuration = animationDuration;
    [self updateInstanceDelay];
}
-(void)setPulseInterval:(NSTimeInterval)pulseInterval{
    _pulseInterval = pulseInterval;
    [self updateInstanceDelay];
}

-(void)setFromValueForRadius:(CGFloat)fromValueForRadius{
    if (fromValueForRadius >= 1.0) {
        fromValueForRadius = 0.0;
    }
    _fromValueForRadius = fromValueForRadius;
    [self receate];
}

-(void)setKeyTimeForHalfOpacity:(CGFloat)keyTimeForHalfOpacity{
    
    _keyTimeForHalfOpacity = keyTimeForHalfOpacity;
    
    if (_animationGroup) {
        [self receate];
    }
}

#pragma mark --Public
-(void)start{
    [self setupPulse];

    [self setupAnimateionGroup];
    
    [_pulse addAnimation:_animationGroup forKey:kPulsatorAnimationKey];

}
-(void)stop{
    [_pulse removeAllAnimations];
    _animationGroup = nil;
}
#pragma mark --Private

-(void)setupPulse{
    _pulse = [[CALayer alloc] init];
    _pulse.contentsScale = [UIScreen mainScreen].scale;
    _pulse.opacity = 0;
    [self addSublayer:_pulse];
    [self updatePulse];
}

-(void)setupAnimateionGroup{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:_fromValueForRadius];
    scaleAnimation.toValue = @(1.0);
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = _animationDuration;
    opacityAnimation.values = @[@(_alpha), @(_alpha * 0.5), @(0.0)];
    opacityAnimation.keyTimes = @[@(0.0), @(_keyTimeForHalfOpacity), @(1.0)];
    
    _animationGroup = [CAAnimationGroup animation];
    _animationGroup.animations = @[scaleAnimation, opacityAnimation];
    _animationGroup.duration = _animationDuration + _pulseInterval;
    _animationGroup.repeatCount = self.repeatCount;
    if (_timingFunction){
        _animationGroup.timingFunction = _timingFunction;
    }
    _animationGroup.delegate = self;
}

-(void)updatePulse{
    
    CGFloat diameter = _radius * 2;
    _pulse.bounds = CGRectMake(0, 0, diameter, diameter);
    _pulse.cornerRadius = _radius;
    _pulse.backgroundColor = self.backgroundColor;
}
-(void)updateInstanceDelay{
    if (_numPulse >= 1) {
        self.instanceDelay = (_animationDuration + _pulseInterval) / _numPulse;
    }
}
-(void)receate{
    [self stop];
    
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self start];
    });
}
#pragma mark --Delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([_pulse.animationKeys count] > 0) {
        [_pulse removeAllAnimations];
    }
    [_pulse removeFromSuperlayer];
    if(_autoRemove){
        [self removeFromSuperlayer];
    }
}

@end
