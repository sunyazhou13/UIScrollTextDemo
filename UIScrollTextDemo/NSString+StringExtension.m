//
//  NSString+StringExtension.m
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/3/6.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import "NSString+StringExtension.h"
#import <CoreText/CoreText.h>

@implementation NSString (StringExtension)

- (CGSize)calculateSingleLineSizeWithAttributeText:(UIFont *)font {
    if (font == nil) { return CGSizeZero; }
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    //详细https://mp.weixin.qq.com/s/DOfnIJwfz0m7A6-vooICHg
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    //构造新的字符串对象
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    //绘制区域 
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

- (CGSize)calculateSingleLineSizeFromFont:(UIFont *)font {
    if (font == nil) { return CGSizeZero; }
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

@end
