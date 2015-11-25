//
//  CustomLabel.h
//  婚礼记
//
//  Created by Lovetong on 15/3/3.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel

@property (retain, nonatomic) NSDictionary *dictionary;

- (void)setLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize;

+ (CustomLabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize;

- (void)setLabelWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

+ (CustomLabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize;

@end
