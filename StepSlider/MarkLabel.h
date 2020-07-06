//
//  testLabel.h
//  StepSlider
//
//  Created by ZC on 2018/6/1.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkLabel : UILabel
@property(nonatomic, strong)NSLayoutConstraint* trailingConstraint;
@property(nonatomic, strong)NSLayoutConstraint* topConstraint;
@property(nonatomic, strong)NSLayoutConstraint* heightConstraint;
@property(nonatomic, strong)NSLayoutConstraint* widthConstraint;
@end
