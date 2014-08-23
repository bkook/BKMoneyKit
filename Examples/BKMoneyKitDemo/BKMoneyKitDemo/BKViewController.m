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
    
    self.currencyTextField.numberFormatter.currencySymbol = @"";
    self.currencyTextField.numberFormatter.currencyCode = @"KRW";
    
    [self.cardNumberField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cardExpiryField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.currencyTextField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.cardNumberField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldEditingChanged:(id)sender
{
    if (sender == self.cardNumberField) {
        
        NSString *cardCompany = self.cardNumberField.cardCompanyName;
        if (nil == cardCompany) {
            cardCompany = @"unknown";
        }
        
        self.cardNumberLabel.text = [NSString stringWithFormat:@"company=%@\nnumber=%@", cardCompany, self.cardNumberField.cardNumber];
        
    } else if (sender == self.cardExpiryField) {
        
        NSDateComponents *dateComp = self.cardExpiryField.dateComponents;
        self.cardExpiryLabel.text = [NSString stringWithFormat:@"month=%d, year=%d", dateComp.month, dateComp.year];
        
    } else if (sender == self.currencyTextField) {
        
        self.currencyTextLabel.text = [NSString stringWithFormat:@"currencyCode=%@\namount=%@",
                                       self.currencyTextField.numberFormatter.currencyCode,
                                       self.currencyTextField.numberValue.description];
    }
}


@end
