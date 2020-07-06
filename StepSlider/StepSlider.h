//
//  StepSlider.h
//  StepSlider
//
//  Created by ZC on 2018/5/31.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StepSliderDelegate;
IB_DESIGNABLE
@interface StepSlider : UIView
@property(nonatomic, strong) IBInspectable NSString* thumbImageName;
@property(nonatomic, strong) IBInspectable NSString* selectedThumbImageName;

//@property(nonatomic, assign) IBInspectable BOOL vertical;
//@property(nonatomic, assign) IBInspectable BOOL ascending;

@property(nonatomic, assign) IBInspectable CGFloat value;
@property(nonatomic, assign) IBInspectable CGFloat minimumValue;
@property(nonatomic, assign) IBInspectable CGFloat maximumVAlue;
@property(nonatomic, assign) IBInspectable CGFloat stepSpace;

@property(nonatomic, assign) IBInspectable CGFloat trackWidth;
@property(nonatomic, strong) IBInspectable UIColor* trackColor;
//@property(nonatomic, strong) IBInspectable UIColor* maximumTrackTintColor;

@property(nonatomic, assign) IBInspectable CGFloat markWidth;
@property(nonatomic, strong) IBInspectable UIColor* markColor;

@property(nonatomic, strong) NSArray<NSString*>* labelStringArray;
@property(nonatomic,weak)IBOutlet id<StepSliderDelegate> delegate;

-(void)setSelectedIndex:(NSInteger) index animated:(BOOL)animated;
@property(nonatomic, assign,readonly) NSInteger stepValue;
@end

@protocol StepSliderDelegate <NSObject>
-(void)sliderBeginTracking:(StepSlider*)slider;
-(void)sliderEndTracking:(StepSlider*)slider;
-(void)sliderValueChanged:(CGFloat) value slider:(StepSlider*)slider;
-(void)sliderStepValueChanged:(NSInteger) stepValue lastValue:(NSInteger)lastStepValue slider:(StepSlider*)slider;
@end
