//
//  DVSUserSpec.m
//
//  Copyright 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSTestConfiguration.h"
#import "DVSTestUser.h"

SPEC_BEGIN(DVSUserSpec)

describe(@"DVSUser", ^{

    context(@"when newly initialized", ^{

        __block DVSUser *user = nil;

        beforeEach(^{
            user = [[DVSUser alloc] init];
        });

        it(@"should use a shared configuration", ^{
            [[[[user class] configuration] should] beIdenticalTo:[DVSConfiguration sharedConfiguration]];
        });

    });

    __block DVSTestConfiguration *configuration = nil;
    __block DVSTestUser *user = nil;

    beforeEach(^{
        NSURL *serverURL = [NSURL URLWithString:@"http://devise-tests/"];
        configuration = [[DVSTestConfiguration alloc] initWithServerURL:serverURL appendPathComponents:NO];
        [[user class] setConfiguration:configuration];
        user = [[DVSTestUser alloc] init];
    });

    describe(@"registering a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRegisterRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{
            
            beforeEach(^{
                user.email = @"john.appleseed@example.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [user registerWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [user registerWithSuccess:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

            it(@"should save the user locally", ^{
                [user registerWithSuccess:nil failure:nil];
                [[expectFutureValue([[user class] localUser]) shouldEventually] equal:user];
            });

        });

        describe(@"validation", ^{

            context(@"using no email", ^{

                beforeEach(^{
                    user.email = nil;
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

            context(@"using email with invalid syntax", ^{

                beforeEach(^{
                    user.email = @"john.appleseed.example.com";
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });

            context(@"using no password", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@example.com";
                    user.password = nil;
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user registerWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });

        });

    });

    describe(@"logging in a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserLogInRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
                user.password = @"$eCR3t";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [user loginWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

            it(@"should fill the user object", ^{
                [user loginWithSuccess:nil failure:nil];
                [[expectFutureValue(user.identifier) shouldEventually] beNonNil];
                [[expectFutureValue(user.sessionToken) shouldEventually] beNonNil];
            });

            it(@"should save the user locally", ^{
                [user loginWithSuccess:nil failure:nil];
                [[expectFutureValue([[user class] localUser]) shouldEventually] equal:user];
            });

        });

        describe(@"validation", ^{

            context(@"using no email", ^{

                beforeEach(^{
                    user.email = nil;
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user loginWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

            context(@"using email with invalid syntax", ^{

                beforeEach(^{
                    user.email = @"john.appleseed.example.com";
                    user.password = @"$eCR3t";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user loginWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

            context(@"using no password", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@example.com";
                    user.password = nil;
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user loginWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });
                
            });
            
        });
        
    });

    describe(@"updating user's email", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserUpdateRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.email = @"john.appleseed@example.com";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [user updateWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

            });

            describe(@"validation", ^{

                context(@"using no email", ^{

                    beforeEach(^{
                        user.email = nil;
                    });

                    it(@"should fail", ^{
                        __block BOOL failure = NO;
                        [user updateWithSuccess:nil failure:^(NSError *error) {
                            failure = YES;
                        }];
                        [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                    });

                });

                context(@"using email with invalid syntax", ^{

                    beforeEach(^{
                        user.email = @"john.appleseed.example.com";
                    });

                    it(@"should fail", ^{
                        __block BOOL failure = NO;
                        [user updateWithSuccess:nil failure:^(NSError *error) {
                            failure = YES;
                        }];
                        [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                    });

                });
                
            });

        });
        
    });

    describe(@"deleting a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserDeleteRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [user deleteAccountWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

                it(@"should remove the locally saved user", ^{
                    [user deleteAccountWithSuccess:nil failure:nil];
                    [[expectFutureValue([[user class] localUser]) shouldEventually] beNil];
                });

            });

        });
        
    });

    describe(@"changing password of a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserChangePasswordRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"when authorized", ^{

            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });

            context(@"using correct data", ^{

                beforeEach(^{
                    user.password = @"n3w_$eCR3t";
                });

                it(@"should succeed", ^{
                    __block BOOL success = NO;
                    [user changePasswordWithSuccess:^{
                        success = YES;
                    } failure:nil];
                    [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
                });

            });

            describe(@"validation", ^{

                context(@"using no password", ^{

                    beforeEach(^{
                        user.password = nil;
                    });

                    it(@"should fail", ^{
                        __block BOOL failure = NO;
                        [user changePasswordWithSuccess:nil failure:^(NSError *error) {
                            failure = YES;
                        }];
                        [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                    });

                });
                
            });
            
        });
        
    });

    describe(@"reminding password to a user", ^{

        __block id<OHHTTPStubsDescriptor> stub = nil;

        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserRemindPasswordRequestsWithOptions:nil];
        });

        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });

        context(@"using correct data", ^{

            beforeEach(^{
                user.email = @"john.appleseed@example.com";
            });

            it(@"should succeed", ^{
                __block BOOL success = NO;
                [user remindPasswordWithSuccess:^{
                    success = YES;
                } failure:nil];
                [[expectFutureValue(theValue(success)) shouldEventually] beTrue];
            });

        });

        describe(@"validation", ^{

            context(@"using no email", ^{

                beforeEach(^{
                    user.email = nil;
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user remindPasswordWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

            context(@"using email with invalid syntax", ^{

                beforeEach(^{
                    user.email = @"john.appleseed.example.com";
                });

                it(@"should fail", ^{
                    __block BOOL failure = NO;
                    [user remindPasswordWithSuccess:nil failure:^(NSError *error) {
                        failure = YES;
                    }];
                    [[expectFutureValue(theValue(failure)) shouldEventually] beTrue];
                });

            });

        });
        
    });
    
    describe(@"loggin out a user", ^{
        
        context(@"when authorized", ^{
            
            beforeEach(^{
                user.identifier = @"1";
                user.email = @"john.appleseed@example.com";
                user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
                [[user class] setLocalUser:user];
            });
            
            it(@"should remove locally saved user", ^{
                [user logout];
                [[expectFutureValue([[user class] localUser]) shouldNotEventually] beIdenticalTo:user];
            });
        });
    });
    
    describe(@"serialized user", ^{
        
        __block DVSTestUser *decodedUser;
        __block NSMutableData *archivedData;
        
        beforeEach(^{
            user.identifier = @"1";
            user.email = @"john.appleseed@example.com";
            user.sessionToken = @"xXx_s3ss10N_t0K3N_xXx";
            user.name = @"John";
            [[user class] setLocalUser:user];
            
            archivedData = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archivedData];
            NSString *userObjectKey = @"userKey";
            
            [archiver encodeObject:user forKey:userObjectKey];
            [archiver finishEncoding];
            
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:[archivedData copy]];
            decodedUser = (DVSTestUser *)[unarchiver decodeObjectOfClass:[DVSTestUser class] forKey:userObjectKey];
        });
        
        it(@"should have been saved", ^{
            [[expectFutureValue(@([archivedData length])) shouldEventually] beGreaterThan:@0];
        });
        
        it(@"should equal after decode", ^{
            [[expectFutureValue(decodedUser) shouldEventually] equal:user];
        });
        
        it(@"should have additional parameter", ^{
            [[expectFutureValue(decodedUser.name) shouldEventually] beNonNil];
        });
        
    });

});

SPEC_END
