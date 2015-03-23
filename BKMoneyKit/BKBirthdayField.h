//
//  BKBirthdayField.h
//  BKMoneyKit
//
//  Created by Joefrey Kibuule on 3/22/15.
//  Copyright (c) 2015 Byungkook Jang. All rights reserved.
//

#import "BKForwardingTextField.h"

@interface BKBirthdayField : BKForwardingTextField

/**
 * Date components that user typed. Undetermined components would be zero.
 */
@property (nonatomic, strong) NSDateComponents      *dateComponents;

/**
 * Returns if current date in birthday field is leap year. Year not typed yes always returns NO.
 */
- (BOOL)isLeapYear;

/**
 * Checks if current month/day/year is valid date
 * @note: ALWAYS check if date before using, due to leap year logic and day being typed before year
 */
- (BOOL)isValidDate;

@end
