//
//  XLFormSectionDescriptor+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormSectionDescriptor+Devise.h"

#import "XLFormRowDescriptor+Devise.h"

NSString * const DVSFormEmailTag = @"email";
NSString * const DVSFormPasswordTag = @"password";
NSString * const DVSFormProceedButtonTag = @"proceedButton";
NSString * const DVSFormDismissButtonTag = @"dismissButton";

@implementation XLFormSectionDescriptor (Devise)

- (void)dvs_addEmailAndPassword {
    [self addFormRow:[XLFormRowDescriptor dvs_emailRowWithTag:DVSFormEmailTag]];
    [self addFormRow:[XLFormRowDescriptor dvs_passwordRowWithTag:DVSFormPasswordTag]];
}

- (void)dvs_addDismissButtonWithAction:(void (^)(XLFormRowDescriptor *))action {
    [self addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormDismissButtonTag
                                                         title:NSLocalizedString(@"Cancel", nil)
                                                         color:[UIColor redColor]
                                                        action:action]];
}

- (void)dvs_addProceedButtonWithTitle:(NSString *)title action:(void (^)(XLFormRowDescriptor *))action {
    [self addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormProceedButtonTag
                                                         title:title
                                                         color:[UIColor blueColor]
                                                        action:action]];
}

@end