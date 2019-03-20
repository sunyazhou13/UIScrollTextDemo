//
//  NSString+StringExtension.h
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/3/6.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (StringExtension)

/**
 计算单行文本行高、支持包含emoji表情符的计算、开头空格.(图片不纳入计算范围)

 @param font 字体
 @return size大小
 */
- (CGSize)calculateSingleLineSizeWithAttributeText:(UIFont *)font;


/**
 计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算.
 包含emoji表情符的文本行高返回值有较大偏差

 @param font 字体对象
 @return size
 */
- (CGSize)calculateSingleLineSizeFromFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
