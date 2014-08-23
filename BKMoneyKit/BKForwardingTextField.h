//
//  BKForwardingTextField.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKForwardingTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign, readonly) id<UITextFieldDelegate> userDelegate;

- (void)commonInit;

@end
