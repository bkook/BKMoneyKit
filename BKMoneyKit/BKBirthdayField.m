//
//  BKBirthdayField.m
//  BKMoneyKit
//
//  Created by Joefrey Kibuule on 3/22/15.
//  Copyright (c) 2015 Byungkook Jang. All rights reserved.
//

#import "BKBirthdayField.h"
#import "BKMoneyUtils.h"

@interface BKBirthdayField ()

@property (nonatomic, strong) NSRegularExpression *nonNumericRegularExpression;
@property (nonatomic, strong) NSCharacterSet *numberCharacterSet;

@end

@implementation BKBirthdayField

- (void)commonInit
{
    [super commonInit];
    
    self.placeholder = @"MM / DD / YYYY";
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.clearButtonMode = UITextFieldViewModeAlways;
    
    _numberCharacterSet = [BKMoneyUtils numberCharacterSet];
    _nonNumericRegularExpression = [BKMoneyUtils nonNumericRegularExpression];
}

- (void)dealloc
{
}

- (NSString *)numberOnlyStringWithString:(NSString *)string
{
    return [self.nonNumericRegularExpression stringByReplacingMatchesInString:string
                                                                      options:0
                                                                        range:NSMakeRange(0, string.length)
                                                                 withTemplate:@""];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.userDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        if (NO == [self.userDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
            return NO;
        }
    }
    
    NSString *currentText = textField.text;
    
    NSCharacterSet *nonNumberCharacterSet = [self.numberCharacterSet invertedSet];
    
    if (string.length == 0 && [[currentText substringWithRange:range] stringByTrimmingCharactersInSet:nonNumberCharacterSet].length == 0) {
        // find non-whitespace character backward
        NSRange numberCharacterRange = [currentText rangeOfCharacterFromSet:self.numberCharacterSet
                                                                    options:NSBackwardsSearch
                                                                      range:NSMakeRange(0, range.location)];
        // adjust replace range
        if (numberCharacterRange.location != NSNotFound) {
            range = NSUnionRange(range, numberCharacterRange);
        }
    }
    
    NSString *replacedString = [currentText stringByReplacingCharactersInRange:range withString:string];
    NSString *numberOnlyString = [self numberOnlyStringWithString:replacedString];
    
    if (numberOnlyString.length > 8) {
        return NO;
    }
    
    if (numberOnlyString.length == 1 && [numberOnlyString substringToIndex:1].integerValue > 1) {
        numberOnlyString = [@"0" stringByAppendingString:numberOnlyString];
    }
    
    NSInteger monthInteger = 0;
    NSMutableString *formattedString = [NSMutableString string];
    
    if (numberOnlyString.length > 0) {
        NSString *monthString = [numberOnlyString substringToIndex:MIN(2, numberOnlyString.length)];
        
        if (monthString.length == 2) {
            monthInteger = monthString.integerValue;
            if (monthInteger < 1 || monthInteger > 12) {
                return NO;
            }
        }
        [formattedString appendString:monthString];
    }
    
    if (numberOnlyString.length > 1) {
        [formattedString appendString:@" / "];
    }
    
    if ([numberOnlyString length] > 2) {
        NSInteger numOfDayDigits = numberOnlyString.length > 3 ? 2 : 1;
        NSString *dayString = [numberOnlyString substringWithRange:NSMakeRange(2, numOfDayDigits)];
        
        if (dayString.length == 1) {
            NSInteger dayInteger = dayString.integerValue;
            
            if (dayInteger < 0 || dayInteger > 3) {
                return NO;
            }
        } else if (dayString.length == 2) {
            NSInteger dayInteger = dayString.integerValue;
            
            if (![self isValidDay:dayInteger forMonth:monthInteger]) {
                return NO;
            }
        }
        [formattedString appendString:dayString];
    }
    
    if (numberOnlyString.length > 3) {
        [formattedString appendString:@" / "];
    }
    
    if (numberOnlyString.length > 4) {
        NSString *yearString = [numberOnlyString substringFromIndex:4];
        [formattedString appendString:yearString];
    }
    
    [self setText:formattedString];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

- (NSDateComponents *)dateComponentsWithString:(NSString *)string
{
    NSString *numberString = [self numberOnlyStringWithString:string];
    
    NSDateComponents *result = [[NSDateComponents alloc] init];
    result.year = 0;
    result.month = 0;
    result.day = 0;
    
    if (numberString.length > 1) {
        result.month = [[numberString substringToIndex:2] integerValue];
    }
    
    if (numberString.length > 2) {
        NSInteger numOfDayDigits = (numberString.length > 3) ? 2 : 1;
        result.day = [[numberString substringWithRange:NSMakeRange(2, numOfDayDigits)] integerValue];
    }
    
    if (numberString.length > 4) {
        result.year = [[numberString substringFromIndex:4] integerValue];
    }
    
    return result;
}

+ (BOOL)isLeapYearForYear:(NSInteger)year {
    
    if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isValidDay:(NSInteger)day forMonth:(NSInteger)month {
    
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            if (day < 1 || day > 31) {
                return NO;
            }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            if (day < 1 || day > 30) {
                return NO;
            }
            break;
        case 2:
            // Month is typed before year, won't know if it's a leap year, bound check against upper limit
            if (day < 1 || day > 29) {
                return NO;
            }
            break;
        default:
            return NO;
            break;
    }
    
    return YES;
}

#pragma mark - Public methods

- (NSDateComponents *)dateComponents
{
    return [self dateComponentsWithString:self.text];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents
{
    [self setText:[NSString stringWithFormat:@"%02ld / %02ld / %02ld", (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.year]];
}

- (BOOL)isLeapYear {
    NSDateComponents *currentComponents = [self dateComponents];
    
    if (currentComponents.year == 0) {
        return NO;
    }
    
    return [[self class] isLeapYearForYear:currentComponents.year];
}

- (BOOL)isValidDate {
    NSDateComponents *currentComponents = [self dateComponents];
    
    if (currentComponents.year != 0) {
        
        if (currentComponents.month > 0 && currentComponents.month < 13) {
            
            if ([[self class] isLeapYearForYear:currentComponents.year]) {
                
                if (self.dateComponents.day > 0 && self.dateComponents.day < 30) {
                    return YES;
                }
            } else {
                if (self.dateComponents.day > 0 && self.dateComponents.day < 29) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

@end
