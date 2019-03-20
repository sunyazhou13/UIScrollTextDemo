//
//  NSAttributedString+SizeExtension.h
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/3/20.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (SizeExtension)

/**
 固定宽度计算多行文本高度，支持开头空格、自定义插入的文本图片不纳入计算范围，包含emoji表情符仍然会有较大偏差，但在UITextView和UILabel等控件中不影响显示。

 @param width 宽度
 @return size
 */
- (CGSize)multiLineSize:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
