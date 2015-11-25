//
//  CustomView.m
//  CCMV
//
//  Created by zd on 15/4/17.
//  Copyright (c) 2015年 zd. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (nonatomic, assign) CGPoint touchedPoint;

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.touchedPoint = [touch locationInView:self];
    [self hitTest:self.touchedPoint withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIScrollView *scrollView = [[self subviews] firstObject];
    for (UIButton *button in scrollView.subviews) {
        
        if ([button isKindOfClass:[UIButton class]]) {
            
            if ([self pointInside:point withEvent:event]) {
                
                return button;
            }
        }
    }
    
    if ([self pointInside:point withEvent:event]) {
        
        return scrollView;
    }
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
