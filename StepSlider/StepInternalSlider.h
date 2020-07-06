//
//  StepInternalSlider.h
//  StepSlider
//
//  Created by ZC on 2018/5/31.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkContainerView.h"
@protocol InternalStepSliderDelegate;
@interface StepInternalSlider : UISlider
@property(nonatomic, assign)CGFloat minTrackSpace;
@property(nonatomic, assign)CGFloat maxTrackSpace;
@property(nonatomic, assign)CGFloat trackWidth;
@property(nonatomic,weak)id<InternalStepSliderDelegate> delegate;
@property(nonatomic, strong)NSLayoutConstraint* heightContraint;
@property(nonatomic,readonly)CGPoint thumbImageCenter;
@property(nonatomic, readonly) CGFloat tracKHeight;
@property(nonatomic,readonly)UILabel* infoLabel;
@property(nonatomic,weak)MarkContainerView* markContainerView;

-(void)setValue:(CGFloat) value
                  animated:(BOOL)animated
                completion:(void (^)(BOOL finished))completion;

@end
@protocol InternalStepSliderDelegate <NSObject>
-(void)sliderContinueTracking:(StepInternalSlider*)slider;
-(void)sliderBeginTracking:(StepInternalSlider*)slider;
-(void)sliderEndTracking:(StepInternalSlider*)slider;
@end
