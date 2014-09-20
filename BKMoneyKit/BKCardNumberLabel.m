//
//  BKCardNumberLabel.m
//  BKMoneyKitDemo
//
//  Created by Byungkook Jang on 2014. 9. 21..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKCardNumberLabel.h"
#import "BKMoneyUtils.h"

@interface BKCardNumberLabel ()

@property (nonatomic, strong) BKCardNumberFormatter *cardNumberFormatter;
@property (nonatomic, strong) UIImageView *cardLogoImageView;

@end

@implementation BKCardNumberLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _cardNumberFormatter = [[BKCardNumberFormatter alloc] init];
    self.showsCardLogo = YES;
}

#pragma mark - UIView

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize result = [super sizeThatFits:size];
    
    if (self.showsCardLogo) {
        result.width += CGRectGetWidth(self.cardLogoImageView.frame);
    }
    
    return result;
}

#pragma mark - UILabel

- (void)drawTextInRect:(CGRect)rect
{
    if (self.showsCardLogo) {
        rect = CGRectOffset(rect, CGRectGetWidth(self.cardLogoImageView.frame), 0);
        [super drawTextInRect:rect];
    } else {
        [super drawTextInRect:rect];
    }
}

#pragma mark - Public Methods

- (void)setShowsCardLogo:(BOOL)showsCardLogo
{
    if (_showsCardLogo != showsCardLogo) {
        
        [_cardLogoImageView removeFromSuperview];
        
        _showsCardLogo = showsCardLogo;
        
        if (showsCardLogo) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44.f, CGRectGetHeight(self.frame))];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeCenter;
            [self addSubview:imageView];
            
            self.cardLogoImageView = imageView;
            
            [self updateCardLogoImage];
        }
    }
}

- (void)updateCardLogoImage
{
    if (nil == self.cardLogoImageView) {
        return;
    }
    
    BKCardPatternInfo *patternInfo = self.cardNumberFormatter.cardPatternInfo;
    
    UIImage *cardLogoImage = [BKMoneyUtils cardLogoImageWithShortName:patternInfo.shortName];
    
    self.cardLogoImageView.image = cardLogoImage;
}

- (void)setCardNumber:(NSString *)cardNumber
{
    self.text = [self.cardNumberFormatter formattedStringFromRawString:cardNumber];
    [self updateCardLogoImage];
}

- (NSString *)cardNumber
{
    return [self.cardNumberFormatter rawStringFromFormattedString:self.text];
}

- (NSString *)cardCompanyName
{
    return self.cardNumberFormatter.cardPatternInfo.companyName;
}

@end
