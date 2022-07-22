//
//  BKCardNumberFormatter.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKCardPatternInfo.h"


@interface BKCardNumberFormatter : NSFormatter

/**
 * The card pattern info that is used last time.
 */
@property (nonatomic, strong, readonly) BKCardPatternInfo *cardPatternInfo;

/**
 * The masking character. If this property is nil, entire card number will be shown.
 */
@property (nonatomic, strong) NSString *maskingCharacter;

/**
 * Card number group indexes to mask. 
 * For example you can mask second, third and fourth group by setting [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)] to this property.
 * As a result, '1234 1234 1234 1234' will be '1234 **** **** ****'.
 */
@property (nonatomic, strong) NSIndexSet *maskingGroupIndexSet;

/**
 * Card number group separater. By default ' '(one space character) will be used.
 * For example, if you set '-', '1234-1234-1234-1234' will be returned.
 */
@property (nonatomic, strong) NSString *groupSeparater;

/**
 * Returns formatted card number string from raw string.
 */
- (NSString *)formattedStringFromRawString:(NSString *)rawString;

/**
 * Returns raw string from formatted string.
 */
- (NSString *)rawStringFromFormattedString:(NSString *)string;

@end
