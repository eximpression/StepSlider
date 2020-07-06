//
//  MarkContainerView.h
//  StepSlider
//
//  Created by ZC on 2018/6/2.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StepInternalSlider;
@interface MarkContainerView : UIView
@property(nonatomic, strong) NSArray<NSString*>* labelStringArray;
@property(nonatomic, assign)CGFloat markViewInset;
@property(nonatomic, assign) CGFloat stepSpace;
@property(nonatomic, assign) CGFloat trackWidth;
@property(nonatomic, strong) UIColor* trackColor;
@property(nonatomic, weak) StepInternalSlider * internalSlider;
@property(nonatomic, strong)NSLayoutConstraint* selfHeightContraint;

-(CGFloat)getContinuousValue;
-(NSInteger)getStepValue ;
-(void)layoutLabels;

-(void)stepValueChanged:(NSInteger)stepValue;
-(void)sliderBeginTracking;
-(void)sliderEndTracking;
-(void)sliderContinueTracking;

@end
