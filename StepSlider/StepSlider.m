//
//  StepSlider.m
//  StepSlider
//
//  Created by ZC on 2018/5/31.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import "StepSlider.h"
#import "StepInternalSlider.h"
#import "StepScrollView.h"
#import "MarkContainerView.h"
@interface StepSlider()<InternalStepSliderDelegate>
@property(nonatomic, strong) StepInternalSlider* internalSlider;
@property(nonatomic,strong) StepScrollView* stepSrollView;
@property(nonatomic, strong)MarkContainerView* markContainerView;

@property(nonatomic,strong)UIImageView* upImageView;
@property(nonatomic,strong)NSLayoutConstraint* upImageViewCenterXConstraint;
@property(nonatomic,strong)UIImageView* downImageView;
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic, assign) NSInteger stepValue;
@end
@implementation StepSlider

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
        [self config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

-(void)config {
    
    //self.translatesAutoresizingMaskIntoConstraints = NO;
    //
    self.backgroundColor = [UIColor clearColor];
    
    _stepValue = 0;
    
    _internalSlider = [[StepInternalSlider alloc]init];
    _internalSlider.delegate = self;
    _internalSlider.translatesAutoresizingMaskIntoConstraints = NO;
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);
    trans = CGAffineTransformScale(trans, 1, -1);
    self.internalSlider.transform = trans;
    
    _stepSrollView = [[StepScrollView alloc]init];
    _stepSrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _upImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indoor_slider_up"]];
    _upImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _upImageView.hidden = YES;
    
    _downImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indoor_slider_down"]];
    _downImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _downImageView.hidden = YES;

    _markContainerView = [[MarkContainerView alloc]init];
    _markContainerView.clipsToBounds = YES;
    _markContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.thumbImageName = @"indoor_thumb_image";
    self.selectedThumbImageName = @"indoor_thumb_image_press";
    
    [self addSubview:_internalSlider];
    [self insertSubview:_stepSrollView belowSubview:_internalSlider];
    [self insertSubview:_upImageView belowSubview:_internalSlider];
    [self insertSubview:_downImageView belowSubview:_internalSlider];
    [_stepSrollView addSubview:_markContainerView];
    [_internalSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _markContainerView.internalSlider = _internalSlider;
    _internalSlider.markContainerView = _markContainerView;
    
    _timer = [[NSTimer alloc]initWithFireDate:[NSDate distantFuture] interval:0.01 target:self selector:@selector(updateScrollViewOffset) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    [self configConstraints];
}

-(void)layoutSubviews {
    [super layoutSubviews];
}
-(void)configConstraints{
    
    //up image
    _upImageViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:_upImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_internalSlider attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [_upImageViewCenterXConstraint setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:_upImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_stepSrollView attribute:NSLayoutAttributeTop multiplier:1 constant:-4] setActive:YES];
    
    //down image
    [[NSLayoutConstraint constraintWithItem:_downImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_upImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:_downImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_stepSrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:4] setActive:YES];
}

-(void)updateArrowImageStatus {
    if (self.stepSrollView.contentOffset.y > 0) {
        self.upImageView.hidden = NO;
    }else {
        self.upImageView.hidden = YES;
    }
    
    if (self.stepSrollView.contentOffset.y + self.stepSrollView.frame.size.height < self.stepSrollView.contentSize.height) {
        self.downImageView.hidden = NO;
    }else {
        self.downImageView.hidden = YES;
    }
}

-(void)setThumbImageName:(NSString *)thumbImageName{
    if (thumbImageName != _thumbImageName) {
        _thumbImageName = thumbImageName;
        UIImage* thumbImage = [UIImage imageNamed:thumbImageName];
        if (thumbImage) {
            CGSize imageSize = thumbImage.size;
            [self.internalSlider setThumbImage:thumbImage forState:UIControlStateNormal];
            self.internalSlider.minTrackSpace = imageSize.width * 0.5 - 10;
            self.internalSlider.maxTrackSpace = imageSize.width * 0.5 - 10;
        }
    }
}

-(void)setSelectedThumbImageName:(NSString *)selectedThumbImageName {
    if (selectedThumbImageName != _selectedThumbImageName) {
        _selectedThumbImageName = selectedThumbImageName;
        UIImage* thumbImage = [UIImage imageNamed:selectedThumbImageName];
        if (thumbImage) {
            CGSize imageSize = thumbImage.size;
            [self.internalSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
            self.internalSlider.minTrackSpace = imageSize.height * 0.5;
            self.internalSlider.maxTrackSpace = imageSize.height * 0.5;
        }
    }
}

-(void)computeHeight {
    NSInteger labelCount = self.labelStringArray.count;
    CGFloat height = self.stepSpace;
    if (labelCount > 2 ) {
        height = self.stepSpace * (labelCount - 1);
    }
    height = height + 2 * self.markContainerView.markViewInset;
    CGFloat scrollViewHeight = MIN(height, self.frame.size.height -  (self.upImageView.frame.size.height + self.downImageView.frame.size.height + 2 * 4));
    self.stepSrollView.contentSize = CGSizeMake(self.frame.size.width, height);
    self.stepSrollView.heightConstraint.constant = scrollViewHeight;
    self.markContainerView.selfHeightContraint.constant = height;
    self.internalSlider.heightContraint.constant = scrollViewHeight;
    
}

-(void)setLabelStringArray:(NSArray<NSString *> *)labelStringArray {
    self.markContainerView.labelStringArray = labelStringArray;
    if (labelStringArray.count == 1) {
        self.internalSlider.value = 0.5;
        self.internalSlider.infoLabel.text = labelStringArray.firstObject;
    }else if (labelStringArray.count >1){
        self.internalSlider.value = 0;
        self.internalSlider.infoLabel.text = labelStringArray.firstObject;
    }
    [self computeHeight];
    //[self updateInfoLabel:NO];
    [self layoutIfNeeded];
    [self.markContainerView layoutLabels];
}

- (NSArray<NSString *> *)labelStringArray {
    return self.markContainerView.labelStringArray;
}

//-(void)setTrackWidth:(CGFloat)trackWidth {
//    if (_trackWidth != trackWidth) {
//        _trackWidth = trackWidth;
//        self.internalSlider.trackWidth = _trackWidth;
//    }
//}

-(void)setTrackColor:(UIColor *)trackColor {
    self.markContainerView.trackColor = trackColor;
}

- (UIColor *)trackColor {
    return self.markContainerView.trackColor;
}

- (void)setTrackWidth:(CGFloat)trackWidth {
    self.markContainerView.trackWidth = trackWidth;
}

-(CGFloat)trackWidth {
    return  self.markContainerView.trackWidth;
}

-(void)setStepSpace:(CGFloat)stepSpace {
    self.markContainerView.stepSpace = stepSpace;
}

-(CGFloat)stepSpace{
    return self.markContainerView.stepSpace;
}

-(void)sliderBeginTracking:(StepInternalSlider *)slider {
    [self resumeTimer];
    [self.markContainerView sliderBeginTracking];
    
    if([self.delegate respondsToSelector:@selector(sliderBeginTracking:)]){
        [self.delegate sliderBeginTracking:self];
    }
}

-(void)sliderValueChanged:(UISlider*) slider {
    //[self updateInfoLabel:NO];
}

-(void)calculateSliderValue{
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:slider:)]) {
        [self.delegate sliderValueChanged:[self.markContainerView getContinuousValue] slider:self];
    }
}

-(void)sliderContinueTracking:(StepInternalSlider *)slider{
    [self updateInfoLabel:NO];
    [self calculateSliderValue];
    [self.markContainerView sliderContinueTracking];
}


-(void)updateInfoLabel:(BOOL) animtated {
    NSInteger index = [self.markContainerView getStepValue];
    if ( self.markContainerView.labelStringArray.count == 1) {
        index = 0;
    }
    if (index < 0 || index > self.labelStringArray.count - 1) {
        return;
    }
    self.stepValue = index;
    NSString* labelStr = [self.markContainerView.labelStringArray objectAtIndex:index];
    if (![self.internalSlider.infoLabel.text isEqualToString:labelStr]) {
        self.internalSlider.infoLabel.text = labelStr;
        //[self.infoLabel sizeToFit];
    }
}
-(void)updateScrollViewOffset {
    //NSLog(@"getStepValueAndUpdateUI updateScrollViewOffset");
    CGFloat step = 4;
    CGPoint offset = self.stepSrollView.contentOffset;
    CGFloat offSetY = offset.y;
    if (self.internalSlider.value == 0 && self.stepSrollView.contentOffset.y > 0) {
        offSetY = self.stepSrollView.contentOffset.y - step;
        //offset = CGPointMake(self.stepSrollView.contentOffset.x,self.stepSrollView.contentOffset.y - step);
    }
    
    if (self.internalSlider.value == 1 && self.stepSrollView.contentOffset.y + self.stepSrollView.frame.size.height < self.stepSrollView.contentSize.height) {
        offSetY = self.stepSrollView.contentOffset.y + step;
        //offset = CGPointMake(self.stepSrollView.contentOffset.x,self.stepSrollView.contentOffset.y + step);
    }
    offSetY = MIN(MAX(0, offSetY),self.markContainerView.frame.size.height - self.stepSrollView.frame.size.height);
    offset = CGPointMake(offset.x, offSetY);
    if (!CGPointEqualToPoint(offset, self.stepSrollView.contentOffset)) {
        self.stepSrollView.contentOffset = offset;
        [self calculateSliderValue];
        [self updateArrowImageStatus];
        [self updateInfoLabel:YES];
    }
    
    
    
}

-(void)pauseTimer{
    
    if (![self.timer isValid]) {
        return ;
    }
    
    [self.timer setFireDate:[NSDate distantFuture]];
    
}


-(void)resumeTimer{
    
    if (![self.timer isValid]) {
        return ;
    }
    [self.timer setFireDate:[NSDate date]];
    
}
-(void)sliderEndTracking:(StepInternalSlider *)slider{
    [self pauseTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(getStepValueAndUpdateUI) withObject:nil afterDelay:0.1];
    [self.markContainerView sliderEndTracking];
    
    if([self.delegate respondsToSelector:@selector(sliderEndTracking:)]){
        [self.delegate sliderEndTracking:self];
    }
}

-(void)getStepValueAndUpdateUI {
    NSInteger reValue = 0;
    if (self.labelStringArray.count == 1) {
        [self.internalSlider setValue:0.5 animated:YES completion:nil];
    }else {
        CGFloat value = [self.markContainerView getContinuousValue];
        reValue = (NSInteger)(value + 0.5);
        CGFloat offset = (reValue - value)*self.stepSpace;
        CGFloat resultSliderValue =  self.internalSlider.value + offset / self.internalSlider.tracKHeight;
        
        if (resultSliderValue < 0) {
            [self.internalSlider setValue:0 animated:YES completion:nil];
            CGFloat otherOffset = - resultSliderValue * self.internalSlider.tracKHeight;
            //NSLog(@"getStepValueAndUpdateUI otherOffset:%f",otherOffset);
            CGPoint contentOffset = self.stepSrollView.contentOffset;
            [self.stepSrollView setContentOffset:CGPointMake(contentOffset.x, self.stepSpace * reValue) animated:YES];
        }else if (resultSliderValue > 1){
            [self.internalSlider setValue:1 animated:YES completion:nil];
            CGFloat otherOffset = (resultSliderValue - 1) * self.internalSlider.tracKHeight;
            CGPoint contentOffset = self.stepSrollView.contentOffset;
            [self.stepSrollView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y + otherOffset) animated:YES];
        }else {
            [self.internalSlider setValue:resultSliderValue animated:YES completion:nil];
        }
    }
    
    self.stepValue = reValue;
    [self updateInfoLabel:YES];
}

-(void)setSelectedIndex:(NSInteger) index animated:(BOOL)animated {
//    if (self.disableLayoutInfoLabel == NO) {
//        self.disableLayoutInfoLabel = YES;
//    }
    if (index == [self.markContainerView getStepValue]) {
        
        return;
    }
    if (index < 0 || index > self.labelStringArray.count - 1) {
        return;
    }
    
    NSString* labelStr = [self.markContainerView.labelStringArray objectAtIndex: index];
    if (![self.internalSlider.infoLabel.text isEqualToString:labelStr]) {
        self.internalSlider.infoLabel.text = labelStr;
    }
    
    if (self.markContainerView.frame.size.height > self.stepSrollView.frame.size.height) {
        CGPoint contentOffset = self.stepSrollView.contentOffset;
        
        CGFloat topSpace = index * self.stepSpace + self.markContainerView.markViewInset;
        CGFloat bottomSpace = self.markContainerView.frame.size.height - topSpace;
        
        CGFloat maxHalf = self.stepSrollView.frame.size.height * 0.5;
        
        if (topSpace <= maxHalf) {
            contentOffset = CGPointMake(contentOffset.x, 0);

            CGFloat sliderValue = (topSpace - self.markContainerView.markViewInset) / self.internalSlider.tracKHeight;
            [self.internalSlider setValue:sliderValue animated:animated completion:nil];
        }
        
        if (bottomSpace <= maxHalf) {
            contentOffset = CGPointMake(contentOffset.x, self.markContainerView.frame.size.height - self.stepSrollView.frame.size.height);
            CGFloat sliderValue = (bottomSpace - self.markContainerView.markViewInset ) / self.internalSlider.tracKHeight;
            [self.internalSlider setValue:1- sliderValue animated:animated completion:nil];
        }
        
        if (bottomSpace > maxHalf && topSpace > maxHalf) {
            contentOffset = CGPointMake(contentOffset.x, topSpace - maxHalf);
            [self.internalSlider setValue:0.5 animated:animated completion:nil];
        }
        
        
        
        [self.stepSrollView setContentOffset:contentOffset animated:animated];
        
        
    }else {
        if (self.labelStringArray.count <= 1) {
            [self.internalSlider setValue:0.5 animated:animated completion:nil];
        }else {
            CGFloat progress = (CGFloat)index / (CGFloat)(self.labelStringArray.count-1);
            [self.internalSlider setValue:progress animated:animated completion:nil];
        }
        
    }

    [self updateArrowImageStatus];
}

-(void)setStepValue:(NSInteger)stepValue {
    if (_stepValue != stepValue) {
        if ([self.delegate respondsToSelector:@selector(sliderStepValueChanged:lastValue:slider:)]) {
            [self.delegate sliderStepValueChanged:stepValue lastValue:_stepValue slider:self];
        }
        _stepValue = stepValue;
        [self.markContainerView stepValueChanged:stepValue];
    }
}
@end
