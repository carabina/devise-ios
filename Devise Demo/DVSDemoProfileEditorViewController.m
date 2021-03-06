//
//  ProfileEditorViewController.m
//  Devise
//
//  Created by Grzegorz Lesiak on 20/11/14.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSDemoProfileEditorViewController.h"
#import <Devise/Devise.h>

#import "UIAlertView+DeviseDemo.h"
#import "DVSDemoUser.h"
#import "DVSDemoUserDataSource.h"

static NSString * const DVSTitleForAlertCancelButton = @"Close";
static NSString * const DVSTitleForEmail = @"E-mail address";

@interface DVSDemoProfileEditorViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) DVSDemoUserDataSource *userDataSource;
@property (strong, nonatomic) NSString *originalEmail;

@end

@implementation DVSDemoProfileEditorViewController

#pragma mark - Object lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDataSource = [DVSDemoUserDataSource new];
    
    NSString *emailTitle = NSLocalizedString(DVSTitleForEmail, nil);
    [self addFormWithTitleToDataSource:emailTitle
                    accessibilityLabel:DVSAccessibilityLabel(@"E-mail field")
                          keyboardType:UIKeyboardTypeEmailAddress];
    [self setValue:[DVSDemoUser localUser].email forTitle:emailTitle];
}

#pragma mark - UIControl events

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender {
    DVSDemoUser *localUser = [DVSDemoUser localUser];
    
    self.originalEmail = localUser.email;
    
    localUser.dataSource = self.userDataSource;
    localUser.email = [self valueForTitle:NSLocalizedString(DVSTitleForEmail, nil)];
    
    __weak typeof(self) weakSelf = self;
    [localUser updateWithSuccess:^{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile updated", nil)
                                    message:NSLocalizedString(@"Your profile was updated.", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(DVSTitleForAlertCancelButton, nil)
                          otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        localUser.email = weakSelf.originalEmail;
        UIAlertView *errorAlert = [UIAlertView dvs_alertViewForError:error
                                        statusDescriptionsDictionary:@{ @422: NSLocalizedString(@"E-mail is already taken.", nil) }];
        [errorAlert show];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(DVSTitleForAlertCancelButton, nil)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
