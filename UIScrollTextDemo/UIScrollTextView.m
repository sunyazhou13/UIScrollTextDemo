//
//  ScrollLabelView.m
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/2/28.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import "UIScrollTextView.h"
#import "NSString+StringExtension.h"
#import "NSAttributedString+SizeExtension.h"

NSString * const kTextLayerAnimationKey = @"textLayerAnimationKey";
NSString * const kSeparateText          = @"   ";   //3个空格

@interface UIScrollTextView ()

@property (nonatomic, strong) CATextLayer  *textLayer; //文本layer
@property (nonatomic, strong) CAGradientLayer *gradientLayer; //蒙版渐变layer
@property (nonatomic, assign) CGFloat      textSeparateWidth; //文本分割宽度
@property (nonatomic, assign) CGFloat      textWidth;   //文本宽度
@property (nonatomic, assign) CGFloat      textHeight;  //文本高度
@property (nonatomic, assign) CGRect       textLayerFrame; //文本layer的frame
@property (nonatomic, assign) CGFloat      translationX; //文字位置游标

@end

@implementation UIScrollTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configProperty];//初始化成员变量
        [self initLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configProperty];//初始化成员变量
    [self initLayer];
    [self updateConstraintsIfNeeded]; //主动更新约束
}

- (void)configProperty {
    _text = @"";
    _textColor = [UIColor whiteColor];
    _font = [UIFont systemFontOfSize:14.0];
    self.textSeparateWidth = [kSeparateText calculateSingleLineSizeFromFont:self.font].width;
    _fade = 0.026;
    
}

- (void)initLayer {
    //文本layer
    if (self.textLayer == nil) {
        self.textLayer = [[CATextLayer alloc] init];
    }
    self.textLayer.alignmentMode = kCAAlignmentNatural; //设置文字对齐模式 自然对齐
    self.textLayer.truncationMode = kCATruncationNone;  //设置截断模式
    self.textLayer.wrapped = NO; //是否折行
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;
    if (self.textLayer.superlayer == nil) {
        [self.layer addSublayer:self.textLayer];
    }
    
    //渐变
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.shouldRasterize = YES;
    self.gradientLayer.rasterizationScale = [UIScreen mainScreen].scale;
    self.gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
    self.gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
    id transparent = (id)[UIColor clearColor].CGColor;
    id opaque = (id)[UIColor blackColor].CGColor;
    self.gradientLayer.colors = @[transparent, opaque, opaque, transparent];
    self.gradientLayer.locations = @[@0,@(self.fade),@(1-self.fade),@1];
    self.layer.mask = self.gradientLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //设置动画参数http://jefferyfan.github.io/2016/06/27/programing/iOS/CATransaction/
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGFloat textLayerFrameY = CGRectGetHeight(self.bounds)/2 - CGRectGetHeight(self.textLayer.bounds) / 2;
    self.textLayer.frame = CGRectMake(0, textLayerFrameY, CGRectGetWidth(self.textLayerFrame), CGRectGetHeight(self.textLayerFrame));
    self.gradientLayer.frame = self.bounds;
    [CATransaction commit];
}

//拼装文本
- (void)drawTextLayer {
    self.textLayer.foregroundColor = self.textColor.CGColor;
    CFStringRef fontName = (__bridge CFStringRef)self.font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = self.font.pointSize;
    CGFontRelease(fontRef);
    self.textLayer.string = [NSString stringWithFormat:@"%@%@%@%@%@",_text,kSeparateText,_text,kSeparateText,_text];
}

- (void)drawAttributedTextLayer {
    self.textLayer.foregroundColor = self.textColor.CGColor;
    CFStringRef fontName = (__bridge CFStringRef)self.font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = self.font.pointSize;
    CGFontRelease(fontRef);
    //这里以后可以扩展支持图片 很简单
    NSMutableAttributedString *tempAttrStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *separateString = [[NSAttributedString alloc] initWithString:kSeparateText];
    [tempAttrStr appendAttributedString:self.attrString];
    [tempAttrStr appendAttributedString:separateString];
    [tempAttrStr appendAttributedString:self.attrString];
    [tempAttrStr appendAttributedString:separateString];
    [tempAttrStr appendAttributedString:self.attrString];
    self.textLayer.string = [[NSAttributedString alloc] initWithAttributedString:tempAttrStr];
}

//动画
- (void)startAnimation {
    if ([self.textLayer animationForKey:kTextLayerAnimationKey]) {
        [self.textLayer removeAnimationForKey:kTextLayerAnimationKey];
    }
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.x"; //沿着X轴运动
    animation.fromValue = @(self.bounds.origin.x);
    animation.toValue = @(self.bounds.origin.x - self.translationX);
    animation.duration = self.textWidth * 0.035f;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.textLayer addAnimation:animation forKey:kTextLayerAnimationKey];
}

#pragma mark -
#pragma mark - getters and setters 设置器和访问器
- (void)setText:(NSString *)text {
    _text = text;
    //计算单行文本大小
    CGSize size = [text calculateSingleLineSizeWithAttributeText:_font];
    _textWidth = size.width;
    _textHeight = size.height;
    _textLayerFrame = CGRectMake(0, 0, _textWidth * 3 + _textSeparateWidth * 2, _textHeight);
    _translationX = _textWidth + _textSeparateWidth;
    [self drawTextLayer];
    [self startAnimation];
}

- (void)setAttrString:(NSAttributedString *)attrString {
    _attrString = attrString;
    //计算单行文本大小
    CGSize size = [attrString multiLineSize:MAXFLOAT];
    _textWidth = size.width;
    _textHeight = size.height;
    _textLayerFrame = CGRectMake(0, 0, _textWidth * 3 + _textSeparateWidth * 2, _textHeight);
    _translationX = _textWidth + _textSeparateWidth;
    [self drawAttributedTextLayer];
    [self startAnimation];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    CGSize size = [self.text calculateSingleLineSizeFromFont:font];
    _textWidth = size.width;
    _textHeight = size.height;
    //为什么要这样计算？ 是因为我们拼接字符串得时候是3个文本宽度+2个分段空格宽度
    _textLayerFrame = CGRectMake(0, 0, _textWidth * 3 + _textSeparateWidth * 2, _textHeight);
    _translationX = _textWidth + _textSeparateWidth;
    [self drawTextLayer];
    [self startAnimation];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textLayer.foregroundColor = _textColor.CGColor;
}

- (void)setFade:(CGFloat)fade {
    if (_fade != fade) {
        _fade = fade;
    }
    self.gradientLayer.locations = @[@0,@(fade),@(1-fade),@1];
    [self.layer layoutIfNeeded];
}

@end
