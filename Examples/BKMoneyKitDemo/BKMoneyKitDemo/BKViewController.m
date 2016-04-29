//
//  BKViewController.m
//  BKMoneyKitDemo
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKViewController.h"

@interface BKViewController ()

@end

@implementation BKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cardNumberField.showsCardLogo = YES;
    
//    self.currencyTextField.numberFormatter.currencySymbol = @"";
//    self.currencyTextField.numberFormatter.currencyCode = @"KRW";
    
    [self.cardNumberField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cardExpiryField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.currencyTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.birthdayField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.cardNumberField becomeFirstResponder];
    
    self.cardNumberLabel.cardNumberFormatter.maskingCharacter = @"●";       // BLACK CIRCLE        25CF
    self.cardNumberLabel.cardNumberFormatter.maskingGroupIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}


- (void)textFieldEditingChanged:(id)sender
{
    if (sender == self.cardNumberField) {
        
        NSString *cardCompany = self.cardNumberField.cardCompanyName;
        if (nil == cardCompany) {
            cardCompany = @"unknown";
        }
        
        self.cardNumberLabel.cardNumber = self.cardNumberField.cardNumber;
        
        self.cardNumberInfoLabel.text = [NSString stringWithFormat:@"company=%@\nnumber=%@", cardCompany, self.cardNumberField.cardNumber];
        
    } else if (sender == self.cardExpiryField) {
        
        NSDateComponents *dateComp = self.cardExpiryField.dateComponents;
        self.cardExpiryLabel.text = [NSString stringWithFormat:@"month=%ld, year=%ld", (long)dateComp.month, (long)dateComp.year];
        
    } else if (sender == self.currencyTextField) {
        
        self.currencyTextLabel.text = [NSString stringWithFormat:@"currencyCode=%@\namount=%@",
                                       self.currencyTextField.numberFormatter.currencyCode,
                                       self.currencyTextField.numberValue.description];
    } else if (sender == self.birthdayField) {
        
        NSDateComponents *dateComp = self.birthdayField.dateComponents;
        
        // Note: ALWAYS check that date is valid before displaying, because typing in day before leap year means it is not valid
        // Use [BKBirthdayField isLeapYear] and [BKBirthdayField isValidDate] in your custom logic to handle those cases
        self.birthdayTextLabel.text = [NSString stringWithFormat:@"month=%ld, day=%ld, year=%ld", (long)dateComp.month, (long)dateComp.day, (long)dateComp.year];
        
        // For years that aren't leap years, date may be invalid if month == 2, so check && print special message
        if (![self.birthdayField isLeapYear] && dateComp.month == 2 && dateComp.year != 0) {
            
            if (![self.birthdayField isValidDate]) {
                self.birthdayTextLabel.text = @"Invalid for non-leap year";
            }
        }
    }
}


@end
