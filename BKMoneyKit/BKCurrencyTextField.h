//
//  BKCurrencyTextField.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2013. 11. 7..
//  Copyright (c) 2013년 Byungkook Jang. All rights reserved.
//

#import "BKForwardingTextField.h"

@interface BKCurrencyTextField : BKForwardingTextField

/**
 * The currency style number formatter. 
 * You can change currency by changing currencyCode or locale property of this formatter.
 */
@property (strong, nonatomic, readonly) NSNumberFormatter   *numberFormatter;

/**
 * The decimal number that user typed.
 */
@property (strong, nonatomic) NSDecimalNumber               *numberValue;

@end
