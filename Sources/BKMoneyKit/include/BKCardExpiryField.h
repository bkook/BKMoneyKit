//
//  BKCardExpiryField.h
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 7. 6..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKForwardingTextField.h"

@interface BKCardExpiryField : BKForwardingTextField

/**
 * Date components that user typed. Undetermined components would be zero.
 */
@property (nonatomic, strong) NSDateComponents      *dateComponents;

+ (NSInteger)currentYear;

@end
