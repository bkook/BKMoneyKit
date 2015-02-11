//
//  BKCurrencyTextField.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2013. 11. 7..
//  Copyright (c) 2013년 Byungkook Jang. All rights reserved.
//

#import "BKForwardingTextField.h"

@interface BKCurrencyTextField : BKForwardingTextField

@property (strong, nonatomic, readonly) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NSDecimalNumber *numberValue; // textField number

@end
