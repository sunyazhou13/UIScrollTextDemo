//
//  ScrollLabelView.h
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/2/28.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollTextView : UIView

@property (nonatomic, copy  ) NSString           *text;
@property (nonatomic, strong) UIColor            *textColor;
@property (nonatomic, strong) UIFont             *font;

@property (nonatomic, strong) NSAttributedString *attrString;

/**
 渐变开始的距离(0~0.5) 推荐 0.0x eg:0.026,
 如果设置成1的时候视图不够长会出现溢出得情况 不推荐超出范围
 */
@property (nonatomic, assign) CGFloat            fade;

@end

NS_ASSUME_NONNULL_END
