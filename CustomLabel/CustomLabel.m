//
//  CustomLabel.m
//  婚礼记
//
//  Created by Lovetong on 15/3/3.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "CustomLabel.h"
#import "UIColor+info.h"

typedef NS_ENUM(NSInteger, ClassOffTextString) {
    isNSString,
    isNSMutableAttributedString
};

@interface CustomLabel ()

@property (assign, nonatomic) ClassOffTextString classOffTextString;

@end

@implementation CustomLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setMasksToBounds:YES];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
    }
    return self;
}

- (void)setLabelWithText:(NSString *)text fontSize:(CGFloat)fontSize
{
    [self getSizeWithCurrentSize:self.frame.size text:text fontSize:fontSize classOffTextString:isNSString];
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    [self setText:text];
}

+ (CustomLabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)fontSize
{
    CustomLabel *customLabel = [[CustomLabel alloc] initWithFrame:frame];
    [customLabel setLabelWithText:text fontSize:fontSize];
    return customLabel;
}

- (void)setLabelWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 3;
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowColor = [UIColor colorWithHexString:@"66ffff"];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:fontName size:fontSize],NSFontAttributeName,[UIColor colorWithHexString:@"dddddd"],NSForegroundColorAttributeName,[NSNumber numberWithInt:0],NSStrokeWidthAttributeName,shadow,NSShadowAttributeName,[NSNumber numberWithInt:0],NSStrikethroughStyleAttributeName, nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    [self getSizeWithCurrentSize:self.frame.size text:string fontSize:fontSize classOffTextString:isNSMutableAttributedString];
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    [self setAttributedText:string];
}

+ (CustomLabel *)customLabelWithFrame:(CGRect)frame text:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)fontSize
{
    CustomLabel *customLabel = [[CustomLabel alloc] initWithFrame:frame];
    [customLabel setLabelWithText:text fontName:fontName fontSize:fontSize];
    return customLabel ;
}

- (void)getSizeWithCurrentSize:(CGSize)size text:(id)text fontSize:(CGFloat)fontSize  classOffTextString:(ClassOffTextString)classOffTextString
{
    if (!size.width && size.height) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    } else if (size.width && !size.height) {
        size.height = 10000;
    } if (classOffTextString == isNSString) {
        NSDictionary *stringAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        CGRect frame = [(NSString *)text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:stringAttribute context:nil];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, frame.size.height)];
    } else {
        CGRect frame = [(NSMutableAttributedString *)text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, frame.size.height)];
    }
}

@end
