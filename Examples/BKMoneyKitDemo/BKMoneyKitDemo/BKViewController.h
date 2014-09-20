//
//  BKViewController.h
//  BKMoneyKitDemo
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"
#import "BKCurrencyTextField.h"
#import "BKCardNumberLabel.h"

@interface BKViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BKCardNumberField *cardNumberField;
@property (weak, nonatomic) IBOutlet BKCardNumberLabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet BKCardExpiryField *cardExpiryField;
@property (weak, nonatomic) IBOutlet BKCurrencyTextField *currencyTextField;

@property (weak, nonatomic) IBOutlet UILabel *cardNumberInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardExpiryLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyTextLabel;

@end
