//
//  ViewController.m
//  StepSlider
//
//  Created by ZC on 2018/5/31.
//  Copyright © 2018年 ZC. All rights reserved.
//

#import "ViewController.h"
#import "StepSlider.h"
@interface ViewController ()<StepSliderDelegate>
@property (weak, nonatomic) IBOutlet StepSlider *stepSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.stepSlider.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.stepSlider.labelStringArray = @[@"11F",@"10F",@"9F",@"8F",@"7F",@"6F",@"5F",@"4F",@"3F",@"2F",@"1F"];
    //[self.stepSlider setNeedsLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sliderStepValueChanged:(NSInteger)stepValue slider:(StepSlider *)slider {
    NSLog(@"sliderStepValueChanged:%f",stepValue);
}

-(void)sliderValueChanged:(CGFloat)value slider:(StepSlider *)slider{
    NSLog(@"sliderValueChanged:%f",value);
}

- (IBAction)changeIndex:(id)sender {
    [self.stepSlider setSelectedIndex:9 animated:YES];
}
@end
