//
//  NSAttributedString+SizeExtension.m
//  ScrollLabelDemo
//
//  Created by sunyazhou on 2019/3/20.
//  Copyright © 2019 sunyazhou.com. All rights reserved.
//

#import "NSAttributedString+SizeExtension.h"


@implementation NSAttributedString (SizeExtension)

- (CGSize)multiLineSize:(CGFloat)width {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}


@end
