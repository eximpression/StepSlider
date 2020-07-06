//
//  StepScrollView.m
//  StepSlider
//
//  Created by ZC on 2018/6/1.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import "StepScrollView.h"

@implementation StepScrollView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoresizesSubviews = NO;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.userInteractionEnabled = NO;
        self.bounces = NO;
        //self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

-(void)addSelfConstraint {
    [[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0] setActive:YES];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:1];
    self.heightConstraint.active = YES;
}

-(void)didMoveToSuperview{
    if (self.superview) {
        [self addSelfConstraint];
    }else {
        NSArray* constraints = self.constraints;
        [self removeConstraints:constraints];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}
@end
