//
//  BKCardExpiryField.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 7. 6..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKCardExpiryField.h"
#import "BKMoneyUtils.h"

@interface BKCardExpiryField ()

@property (nonatomic, strong) NSRegularExpression *nonNumericRegularExpression;
@property (nonatomic, strong) NSCharacterSet *numberCharacterSet;

@end

@implementation BKCardExpiryField

- (void)commonInit
{
    [super commonInit];
    
    self.placeholder = @"MM / YY";
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
    
    if (numberOnlyString.length > 4) {
        return NO;
    }
    
    if (numberOnlyString.length == 1 && [numberOnlyString substringToIndex:1].integerValue > 1) {
        numberOnlyString = [@"0" stringByAppendingString:numberOnlyString];
    }
    
    NSMutableString *formattedString = [NSMutableString string];
    
    if (numberOnlyString.length > 0) {
        
        NSString *monthString = [numberOnlyString substringToIndex:MIN(2, numberOnlyString.length)];
        
        if (monthString.length == 2) {
            NSInteger monthInteger = monthString.integerValue;
            if (monthInteger < 1 || monthInteger > 12) {
                return NO;
            }
        }
        [formattedString appendString:monthString];
    }
    
    if (numberOnlyString.length > 1) {
        [formattedString appendString:@" / "];
    }
    
    if (numberOnlyString.length > 2) {
        NSString *yearString = [numberOnlyString substringFromIndex:2];
        [formattedString appendString:yearString];
    }

    [self setText:formattedString];
    
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

+ (NSInteger)currentYear
{
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return currentDateComponents.year;
}

- (NSDateComponents *)dateComponentsWithString:(NSString *)string
{
    NSString *numberString = [self numberOnlyStringWithString:string];
    
    NSDateComponents *result = [[NSDateComponents alloc] init];
    result.year = 0;
    result.month = 0;
    
    if (numberString.length > 1) {
        result.month = [[numberString substringToIndex:2] integerValue];
    }
    
    if (numberString.length > 3) {
        NSInteger currentYear = [[self class] currentYear];
        result.year = [[numberString substringFromIndex:2] integerValue] + (currentYear / 100 * 100);
    }
    
    return result;
}

#pragma mark - Public methods

- (NSDateComponents *)dateComponents
{
    return [self dateComponentsWithString:self.text];
}

- (void)setDateComponents:(NSDateComponents *)dateComponents
{
    [self setText:[NSString stringWithFormat:@"%02ld / %02ld", (long)dateComponents.month, (long)dateComponents.year % 100]];
}

@end
