//
//  BKMoneyUtils.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKMoneyUtils.h"

@implementation BKMoneyUtils

+ (NSRegularExpression *)nonNumericRegularExpression
{
    return [NSRegularExpression regularExpressionWithPattern:@"[^0-9]+" options:0 error:nil];
}

+ (NSCharacterSet *)numberCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
}

+ (UIImage *)cardLogoImageWithShortName:(NSString *)shortName
{
    UIImage *cardLogoImage = nil;
    
    if (shortName) {
        cardLogoImage = [UIImage imageNamed:[NSString stringWithFormat:@"BKMoneyKit.bundle/CardLogo/%@", shortName]];
    }
    
    if (nil == cardLogoImage) {
        cardLogoImage = [UIImage imageNamed:@"BKMoneyKit.bundle/CardLogo/default"];
    }
    
    return cardLogoImage;
}

@end
