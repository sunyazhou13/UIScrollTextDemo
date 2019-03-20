//
//  ViewController.m
//  UIScrollTextDemo
//
//  Created by sunyazhou on 2019/3/20.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "UIScrollTextView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollTextView   *scrollTextView1;
@property (nonatomic, strong) UIScrollTextView   *scrollTextView2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollTextView1 = [[UIScrollTextView alloc] initWithFrame:CGRectZero];
    self.scrollTextView1.textColor = [UIColor blackColor];
    self.scrollTextView1.font = [UIFont boldSystemFontOfSize:14.0];
//    self.scrollTextView1.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.scrollTextView1];
    
    [self.scrollTextView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    [self.scrollTextView1 setText:@"sunyazhou.com - 東引甌越"];
    
    
    self.scrollTextView2 = [[UIScrollTextView alloc] initWithFrame:CGRectZero];
//    self.scrollTextView2.backgroundColor = [UIColor cyanColoqher];
    [self.view addSubview:self.scrollTextView2];
    
    [self.scrollTextView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollTextView1);
        make.top.equalTo(self.scrollTextView1.mas_bottom).offset(30);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is a long, attributed string, that's set up to loop in a continuous fashion!"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.123 green:0.331 blue:0.657 alpha:1.000] range:NSMakeRange(0,34)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.657 green:0.096 blue:0.088 alpha:1.000] range:NSMakeRange(34, attributedString.length - 34)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f] range:NSMakeRange(0, 16)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f] range:NSMakeRange(33, attributedString.length - 33)];
    self.scrollTextView2.textColor = [UIColor whiteColor];
    [self.scrollTextView2 setAttrString:attributedString];
    
}

- (IBAction)valueChange:(UISlider *)sender {
    self.scrollTextView1.fade = sender.value;
    self.scrollTextView2.fade = sender.value;
}

@end

