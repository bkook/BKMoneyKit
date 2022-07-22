//
//  BKCurrencyTextField.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2013. 11. 7..
//  Copyright (c) 2013년 Byungkook Jang. All rights reserved.
//

#import "BKCurrencyTextField.h"
#import "BKMoneyUtils.h"

@interface BKCurrencyTextField ()

@property (strong, nonatomic) NSNumberFormatter     *numberFormatter;
@property (strong, nonatomic) NSRegularExpression   *nonNumericRegularExpression;
@property (nonatomic, strong) NSCharacterSet        *numberCharacterSet;

@end

@implementation BKCurrencyTextField

- (void)commonInit
{
    [super commonInit];
    
    self.keyboardType = UIKeyboardTypeNumberPad;
    //self.textAlignment = NSTextAlignmentRight;
    
    _numberFormatter = [[NSNumberFormatter alloc] init];
    _numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;

    _nonNumericRegularExpression = [BKMoneyUtils nonNumericRegularExpression];
    _numberCharacterSet = [BKMoneyUtils numberCharacterSet];
    
    self.placeholder = [_numberFormatter stringFromNumber:@(0)];
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
    
    NSString *newString = [currentText stringByReplacingCharactersInRange:range withString:string];
    
    NSString *digits = [self stringByRemovingNonNumericCharacters:newString];

    if (digits.length == 0) {
        return string.length == 0;
    }

    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:digits];
    
    if (self.numberFormatter.maximumFractionDigits > 0) {
        decimalNumber = [decimalNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:self.numberFormatter.maximumFractionDigits isNegative:NO]];
    }
    
    // get current cursor position
    UITextRange* selectedRange = [textField selectedTextRange];
    UITextPosition* start = textField.beginningOfDocument;
    NSInteger cursorOffset = [textField offsetFromPosition:start toPosition:selectedRange.start];
    NSUInteger currentLength = currentText.length;
    
    // update text field
    self.numberValue = decimalNumber;
    
    // if the cursor was not at the end of the string being entered, restore cursor position
    if (cursorOffset != currentLength) {
        NSInteger lengthDelta = newString.length - currentLength;
        NSInteger newCursorOffset = MAX(0, MIN(newString.length, cursorOffset + lengthDelta));
        UITextPosition* newPosition = [textField positionFromPosition:textField.beginningOfDocument offset:newCursorOffset];
        UITextRange* newRange = [textField textRangeFromPosition:newPosition toPosition:newPosition];
        [textField setSelectedTextRange:newRange];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

#pragma mark - Private Methods

- (NSString *)stringByRemovingNonNumericCharacters:(NSString *)string
{
    return [self.nonNumericRegularExpression stringByReplacingMatchesInString:string
                                                                      options:0
                                                                        range:NSMakeRange(0, string.length)
                                                                 withTemplate:@""];
}

#pragma mark - Public Methods

- (void)setNumberValue:(NSDecimalNumber *)numberValue
{
    if (nil == numberValue || [numberValue compare:[NSDecimalNumber zero]] == NSOrderedSame || [numberValue compare:[NSDecimalNumber notANumber]] == NSOrderedSame) {
        self.text = nil;
    } else {
        self.text = [_numberFormatter stringFromNumber:numberValue];
    }
}

- (NSDecimalNumber *)numberValue
{
    if (self.text.length == 0) {
        return nil;
    }
    
    NSDecimal decimal = [_numberFormatter numberFromString:self.text].decimalValue;
    return [NSDecimalNumber decimalNumberWithDecimal:decimal];
}

@end
