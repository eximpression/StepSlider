//
//  StepInternalSlider.m
//  StepSlider
//
//  Created by ZC on 2018/5/31.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import "StepInternalSlider.h"
@interface StepInternalSlider()
@property(nonatomic, assign) CGFloat tracKHeight;
@property(nonatomic,strong)UILabel* infoLabel;
@property(nonatomic, assign)BOOL addInfoLabel;
@property(nonatomic, weak)UIImageView* thumbImageView;
@end

@implementation StepInternalSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        _trackWidth = 2;
        _minTrackSpace = 0;
        _maxTrackSpace = 0;
        self.minimumTrackTintColor = [UIColor clearColor];
        self.maximumTrackTintColor = [UIColor clearColor];
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 25)];
        _infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _infoLabel.text = @"fd";
        _infoLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
        trans = CGAffineTransformScale(trans, 1, -1);
        _infoLabel.transform = trans;
        //debug
        //self.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
    }
    return self;
}

-(void)addInfoLabelConstraint:(UIView*)superView{
    [[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30]setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:25]setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]setActive:YES];
}
-(CGRect)trackRectForBounds:(CGRect)bounds {
    if (self.addInfoLabel == NO) {
        for (UIView* subView in self.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                UIImageView* imageView = (UIImageView* ) subView;
                if (imageView.image == [self thumbImageForState:UIControlStateNormal]) {
                    self.infoLabel.center = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds));
                    [imageView addSubview:_infoLabel];
                    [self addInfoLabelConstraint:imageView];
                    self.thumbImageView = imageView;
                    self.addInfoLabel = YES;
                }
            }
        }
    }
    CGRect b = [super trackRectForBounds:bounds];
    CGRect resultRect = CGRectMake(b.origin.x + self.markContainerView.markViewInset + 2 , b.origin.y, b.size.width - self.markContainerView.markViewInset - self.markContainerView.markViewInset - 4, self.trackWidth);
    return resultRect;
}

-(CGFloat)tracKHeight {
    return self.heightContraint.constant - self.markContainerView.markViewInset - self.markContainerView.markViewInset ;
}
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - self.minTrackSpace ;
    rect.size.width = rect.size.width + self.minTrackSpace + self.maxTrackSpace;
    CGRect thumbRect = CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], self.minTrackSpace , self.maxTrackSpace);
    return thumbRect;
}

-(void)setMinTrackSpace:(CGFloat)minTrackSpace {
    if (minTrackSpace != _minTrackSpace) {
        _minTrackSpace = minTrackSpace;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL result = [super continueTrackingWithTouch:touch withEvent:event];
    if ([self.delegate respondsToSelector:@selector(sliderContinueTracking:)] && result) {
        [self.delegate sliderContinueTracking:self];
    }
    return result;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if ([self.delegate respondsToSelector:@selector(sliderEndTracking:)]) {
        [self.delegate sliderEndTracking:self];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL result = [super beginTrackingWithTouch:touch withEvent:event];
    if ([self.delegate respondsToSelector:@selector(sliderBeginTracking:)] && result) {
        [self.delegate sliderBeginTracking:self];
    }
    return result;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -self.minTrackSpace, 0);
    return CGRectContainsPoint(bounds, point);
}

-(void)didMoveToSuperview {
    if (self.superview) {
        self.heightContraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:50];
        [self.heightContraint setActive:YES];
        
        //slider
        [[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0] setActive:YES];
        
        [[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10 - 16] setActive:YES];
        
    }else {
        NSArray* constraints = self.constraints;
        [self removeConstraints:constraints];
    }
}

-(CGPoint)thumbImageCenter {
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds
                                             trackRect:trackRect
                                                 value:self.value];
    
    return  CGPointMake(thumbRect.origin.x + self.bounds.origin.x - self.markContainerView.markViewInset - 0.5 ,  self.frame.size.height * 0.5);
//    return CGPointMake((self.heightContraint.constant - self.markContainerView.markViewInset - self.markContainerView.markViewInset) * self.value, self.frame.size.height * 0.5);
}

//-(void)setThumbImageCenter:(CGPoint)thumbImageCenter {
//    [self setThumbImageCenter:thumbImageCenter animated:NO completion:nil];
//}

-(void)setValue:(CGFloat) value
       animated:(BOOL)animated
     completion:(void (^)(BOOL finished))completion {
    //NSLog(@"setValue:%f",value);
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            [self setValue:value animated:animated];
        } completion:^(BOOL finished){
            if (completion) {
                completion(YES);
            }
            
        }];
    }else {
        self.value = value;
        if (completion) {
            completion(YES);
        }
    }
    
}

@end
