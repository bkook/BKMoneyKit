//
//  BKForwardingTextField.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 24..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKForwardingTextField.h"

@interface BKForwardingTextField ()

@end

@implementation BKForwardingTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [super setDelegate:self];
}

#pragma mark - Fowarding

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    if (_userDelegate != delegate) {
        _userDelegate = delegate;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([_userDelegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_userDelegate];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    } else {
        return [_userDelegate respondsToSelector:aSelector];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (nil == signature) {
        signature = [(NSObject *)_userDelegate methodSignatureForSelector:aSelector];
    }
    return signature;
}

@end
