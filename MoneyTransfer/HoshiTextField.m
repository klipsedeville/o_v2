//
//  HoshiTextField.m
//  CCTextFieldEffects
//
//  Created by Kelvin on 6/25/16.
//  Copyright © 2016 Cokile. All rights reserved.
//

#import "HoshiTextField.h"

@interface HoshiTextField ()

@property (strong, nonatomic) CALayer *inactiveBorderLayer;
@property (strong, nonatomic) CALayer *activeBorderLayer;
@property (nonatomic) CGPoint activePlaceholderPoint;

@end

@implementation HoshiTextField

#pragma mark - Constants
static CGFloat const activeBorderThickness = 1;
static CGFloat const inactiveBorderThickness = 0.7;
static CGPoint const textFieldInsets = {0, 8};
static CGPoint const placeholderInsets = {0, 6};
static CGPoint const iPadPlaceholderInsets = {0, 10};


#pragma mark - Custom accessorys
- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    
    [self updateBorder];
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    [self updateBorder];
    [self updatePlaceholder];
}

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.inactiveBorderLayer = [[CALayer alloc] init];
        self.activeBorderLayer = [[CALayer alloc] init];
        self.placeholderLabel = [[UILabel alloc] init];
        
        
        self.borderInactiveColor = [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0];
        self.borderActiveColor = [UIColor colorWithRed:0.4157 green:0.4745 blue:0.5373 alpha:1.0];
        self.placeholderColor = self.borderInactiveColor;
        self.cursorColor = [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0];
        self.textColor = [UIColor colorWithRed:0.2785 green:0.2982 blue:0.3559 alpha:1.0];
        
        self.placeholderFontScale = 0.65;
        self.activePlaceholderPoint = CGPointZero;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
        }
        else
        {
            self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
        }
        
    }
    
    return self;
}

#pragma mark - Overridden methods
- (void)drawRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.placeholderLabel.frame = CGRectInset(frame, iPadPlaceholderInsets.x, iPadPlaceholderInsets.y);
    }
    else
    {
        self.placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y);
    }
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.placeholderLabel.font = [self placeholderFontFromFont:[UIFont fontWithName:@"MyriadPro-Regular" size:32]];
    }
    else
    {
        self.placeholderLabel.font = [self placeholderFontFromFont:[UIFont fontWithName:@"MyriadPro-Regular" size:16]];
    }

    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
    [self addSubview:self.placeholderLabel];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (void)animateViewsForTextEntry {
    
    self.placeholderLabel.textColor = [self colorWithHexString:@"3ec6f0"];
    
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.placeholderLabel.frame = CGRectMake(10, self.placeholderLabel.frame.origin.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
            self.placeholderLabel.alpha = 0;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:24];
            }
            else
            {
                self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
            }
            
        } completion:^(BOOL finished) {
            if (self.didBeginEditingHandler != nil) {
                self.didBeginEditingHandler();
            }
        }];
    }

    
    [self layoutPlaceholderInTextRect];
    self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
    
    [UIView animateWithDuration:0.2 animations:^{
        self.placeholderLabel.alpha = 0.5;
    }];
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:YES];
}

- (void)animateViewsForTextDisplay {
    
    self.placeholderLabel.textColor = [self colorWithHexString:@"51595c"];
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
    
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.alpha = 1.0;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
            }
            else
            {
                self.placeholderLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
            }
            
        } completion:^(BOOL finished) {
            if (self.didEndEditingHandler != nil) {
                self.didEndEditingHandler();
            }
        }];
    
    }
    
}

#pragma mark - Private methods
- (void)updateBorder{
    self.inactiveBorderLayer.frame = [self rectForBorderThickness:inactiveBorderThickness isFilled:YES];
    self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
    self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if ([self isFirstResponder] || self.text.length!=0) {
        [self animateViewsForTextEntry];
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    UIFont *smallerFont = [UIFont fontWithName:font.fontName size:font.pointSize*self.placeholderFontScale];
    
    return smallerFont;
}

- (CGRect)rectForBorderThickness:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, CGRectGetWidth(self.frame), thickness);
    } else {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, 0, thickness);
    }
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width/2-self.placeholderLabel.bounds.size.width/2;
            break;
        case NSTextAlignmentRight:
            originX += textRect.size.width-self.placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    
    self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height/2, CGRectGetWidth(self.placeholderLabel.bounds), CGRectGetHeight(self.placeholderLabel.bounds));
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.activePlaceholderPoint = CGPointMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y-self.placeholderLabel.frame.size.height-iPadPlaceholderInsets.y);
    }
    else
    {
        self.activePlaceholderPoint = CGPointMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y-self.placeholderLabel.frame.size.height-placeholderInsets.y);
    }
}

#pragma mark ########
#pragma mark Color HexString methods

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
