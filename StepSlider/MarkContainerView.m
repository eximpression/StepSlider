//
//  MarkContainerView.m
//  StepSlider
//
//  Created by ZC on 2018/6/2.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import "MarkContainerView.h"
#import "MarkLabel.h"
#import "StepInternalSlider.h"
@interface MarkContainerView ()

@property(nonatomic, strong)UIView* markLineView;
@property(nonatomic, strong)NSMutableArray<MarkLabel*>* labelArray;
@property(nonatomic, strong)NSMutableArray<UIView*>* markArray;
@property(nonatomic, strong)NSLayoutConstraint* markLineCenterXConstraint;
@property(nonatomic, strong)NSLayoutConstraint* markLineWidthConstraint;
@end
@implementation MarkContainerView

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
        [self initConfig];
    }
    return self;
}

-(void)initConfig {
    _labelArray = [[NSMutableArray alloc]init];
    _markArray = [[NSMutableArray alloc]init];
    _markViewInset = 10;
    _stepSpace = 50;
    _trackWidth = 1;
    _trackColor = [UIColor colorWithRed:138.0/255.0 green:138.0/255.0 blue:138.0/255.0 alpha:1.0];
    _markLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _trackWidth, self.frame.size.height)];
    [self addSubview:_markLineView];
    _markLineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstaintWithMarkLineView];
    _markLineView.backgroundColor = _trackColor;
    
    //debug
    self.backgroundColor = [UIColor clearColor];
    //self.backgroundColor = [UIColor blackColor];
    
}

-(void)addConstaintWithMarkLineView {
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self.markLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.markViewInset];
    [self addConstraint:top];
    
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self.markLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.markViewInset];
    [self addConstraint:bottom];
    
   _markLineWidthConstraint = [NSLayoutConstraint constraintWithItem:self.markLineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.trackWidth];
    [self addConstraint:_markLineWidthConstraint];
    
}

-(void)addSelfConstraint{
    if (self.superview) {
        NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [top setActive:YES];
        
        NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [bottom setActive:YES];
        
        NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [leading setActive:YES];
        
        NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [trailing setActive:YES];
        
        NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        [width setActive:YES];
        
        self.selfHeightContraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:self.stepSpace];
        [self.selfHeightContraint setActive:YES];
    }
}

-(void)didMoveToSuperview {
    if (self.superview) {
        [self addSelfConstraint];
    }else {
        NSArray* constraints = self.constraints;
        [self removeConstraints:constraints];
    }
}
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    //[self layoutLabels];
}

-(void)setLabelStringArray:(NSArray<NSString *> *)labelStringArray {
    if (labelStringArray != _labelStringArray) {
        _labelStringArray = labelStringArray;
        if (_labelStringArray.count == 1) {
            self.markLineView.backgroundColor = [UIColor clearColor];
        }else if(_labelStringArray.count > 1)
        {
            self.markLineView.backgroundColor = self.trackColor;
        }
        [self removeLabels];
        [self addLabels];
    }
}

-(void)removeLabels {
    for (MarkLabel* label  in self.labelArray) {
        [label removeFromSuperview];
    }
    for (UIView* mark in self.markArray) {
        [mark removeFromSuperview];
    }
    [self.markArray removeAllObjects];
    [self.labelArray removeAllObjects];
}

-(void)addLabels {
    for (NSString* labelString in self.labelStringArray) {
        MarkLabel* label = [[MarkLabel alloc ]init];
        UIFont* font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        label.font = font;
        label.textColor = self.trackColor;
        label.text = labelString;
        [label sizeToFit];
        [self.labelArray addObject:label];
        
        CGRect markFrame = CGRectZero;

        markFrame = CGRectMake(0, 0, self.trackWidth, self.trackWidth);

        UIView *mark = [[UIView alloc]initWithFrame:markFrame];
        mark.backgroundColor = self.trackColor;
        [self.markArray addObject:mark];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        mark.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self insertSubview:mark belowSubview:self.markLineView];
        [self insertSubview:label belowSubview:self.markLineView];
        
        label.trailingConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [label.trailingConstraint setActive:YES];
        
        label.topConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [label.topConstraint setActive:YES];
        
        label.widthConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:40];
        [label.widthConstraint setActive:YES];
        
        label.heightConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:30];
        [label.heightConstraint setActive:YES];
    }
    
}

-(void)layoutLabels {
    [self layoutLabelsWithIndex:[self getStepValue] expand:NO animated:NO];
}

-(void)layoutLabelsWithIndex:(NSInteger)currentIndex expand:(BOOL)expand animated:(BOOL)animated {
    NSInteger labelCount = self.labelArray.count;
    if (labelCount <= 0) {
        return;
    }
    
    if (labelCount > 1) {
        for (NSInteger i= 0; i < labelCount; i++) {
            MarkLabel* label = [self.labelArray objectAtIndex:i];
            UIView* mark = [self.markArray objectAtIndex:i];
            CGFloat offset = 30;
            CGPoint targetCenter;
            CGFloat alpha = 1.0;
            UIFont* font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            if (labs(currentIndex - i) > 2 || expand == NO) {
                targetCenter = CGPointMake(self.markLineView.center.x - self.internalSlider.frame.size.width * 0.5 + offset - self.frame.size.width, i * self.stepSpace + self.markViewInset - label.heightConstraint.constant * 0.5);
                alpha = currentIndex == i ? 0 : 1;
            }else {
                CGFloat xOffsetUnit = 15;
                NSInteger indexGap = labs(labs(currentIndex - i) - 3);
                targetCenter = CGPointMake(self.markLineView.center.x - self.internalSlider.frame.size.width * 0.5 + offset - (indexGap * xOffsetUnit) - self.frame.size.width, i * self.stepSpace + self.markViewInset - label.heightConstraint.constant * 0.5);
                
                switch (indexGap) {
                    case 3:
                        font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
                        break;
                    case 2:
                        font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
                        break;
                    case 1:
                        font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
                        break;
                        
                    default:
                        break;
                }
            }
            label.font = font;
            label.trailingConstraint.constant = targetCenter.x;
            label.topConstraint.constant = targetCenter.y;
            if (animated) {
                [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    label.alpha = alpha;
                    [self layoutIfNeeded];
                    
                } completion:^(BOOL finish){
                    
                }];
            }else {
                label.alpha = alpha;
                label.center = targetCenter;
            }
            
            mark.center = CGPointMake(self.markLineView.center.x, label.center.y);
        }
        
    }else {
        //只有1个，居中
        MarkLabel* label = self.labelArray.firstObject;
        UIView* mark = self.markArray.firstObject;
        
        label.center = CGPointMake(self.markLineView.center.x - label.frame.size.width * 0.5 - self.internalSlider.frame.size.width * 0.5 + 10.5, CGRectGetMidY(self.bounds));
        
        mark.center = CGPointMake(self.markLineView.center.x, CGRectGetMidY(self.bounds));
    }
    
}

-(void)setTrackColor:(UIColor *)trackColor {
    if (![_trackColor isEqual:trackColor]) {
        _trackColor = trackColor;
        for (UIView* mark in self.markArray) {
            mark.backgroundColor = trackColor;
        }
        self.markLineView.backgroundColor = trackColor;
    }
}

-(void)setTrackWidth:(CGFloat)trackWidth {
    if (_trackWidth != trackWidth) {
        _trackWidth = trackWidth;
        _markLineWidthConstraint.constant = trackWidth;
    }
}
-(void)setInternalSlider:(StepInternalSlider *)internalSlider {
    if (_internalSlider != internalSlider) {
        _internalSlider = internalSlider;
    }
    if (_internalSlider) {
        [self removeConstraint:self.markLineCenterXConstraint];
        self.markLineCenterXConstraint = nil;
        self.markLineCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.markLineView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.internalSlider attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.markLineCenterXConstraint setActive:YES];
    }
}

-(CGFloat)getContinuousValue {
    if (self.internalSlider) {
        CGPoint sliderCenterPoint = self.internalSlider.thumbImageCenter;
        CGPoint convertPoint = [self.markLineView convertPoint:sliderCenterPoint fromView:self.internalSlider];
        return (convertPoint.y + self.markViewInset) / self.stepSpace;
    }else{
        return 0;
    }
}

-(NSInteger)getStepValue {
    CGFloat value = [self getContinuousValue];
    return (NSInteger)(value + 0.5);
}

-(void)stepValueChanged:(NSInteger)stepValue{
    if (self.internalSlider.isTracking) {
        [self layoutLabelsWithIndex:[self getStepValue] expand:YES animated:YES];
    }
}

-(void)sliderBeginTracking{
    [self layoutLabelsWithIndex:[self getStepValue] expand:YES animated:YES];
}

-(void)sliderEndTracking{
    [self layoutLabelsWithIndex:[self getStepValue] expand:NO animated:YES];
}

-(void)sliderContinueTracking{
    
}
@end
