//
//  OHHTTPStubs+DeviseTests.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>

#import "DVSHTTPClient+User.h"
#import "OHHTTPStubs+DeviseDemoTests.h"

NSString * const DVSHTTPStubsAllowedMethodsKey = @"DVSHTTPStubsAllowedMethodsKey";

@implementation OHHTTPStubs (DeviseTests)

#pragma mark - Specific stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRegisterRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultRegisterPath;
    options = [self dvs_postOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:[self dvs_defaultUserResponse] statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserLogInRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultLogInPath;
    options = [self dvs_postOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        return [self dvs_responseWithJSON:[self dvs_defaultUserResponse] statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserRemindPasswordRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultRemindPasswordPath;
    options = [self dvs_postOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserDeleteRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultDeletePath;
    options = [self dvs_deleteOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:[self dvs_defaultUserResponse] statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserUpdateRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultUpdatePath;
    options = [self dvs_putOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:[self dvs_defaultUserResponse] statusCode:200];
    }];
}

+ (id<OHHTTPStubsDescriptor>)dvs_stubUserChangePasswordRequestsWithOptions:(NSDictionary *)options {
    NSString *path = DVSHTTPClientDefaultChangePasswordPath;
    options = [self dvs_putOptionsForReceivedOptions:options];
    return [self dvs_stubRequestsForPath:path options:options response:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self dvs_responseWithJSON:[self dvs_defaultUserResponse] statusCode:200];
    }];
}

#pragma mark - General stubs

+ (id<OHHTTPStubsDescriptor>)dvs_stubRequestsForPath:(NSString *)path options:(NSDictionary *)options response:(OHHTTPStubsResponseBlock)response {
    return [self stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *baseUrl = [[DVSConfiguration sharedConfiguration] baseURL].absoluteString;
        NSString *fullResourcePath = [NSString stringWithFormat:@"%@/%@", baseUrl, path];
        if (![request.URL.absoluteString isEqualToString:fullResourcePath]) {
            return NO;
        }
        if (options[DVSHTTPStubsAllowedMethodsKey]) {
            if ([options[DVSHTTPStubsAllowedMethodsKey] indexOfObject:request.HTTPMethod] == NSNotFound) {
                return NO;
            }
        }
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return response(request);
    }];
}



#pragma mark - Users

+ (NSDictionary *)dvs_defaultUserResponse {
    return @{ @"user": @{
                      @"id": @1,
                      @"email": @"john.appleseed@example.com",
                      @"authenticationToken": @"xXx_s3ss10N_t0K3N_xXx",
                      @"createdAt": @"1970-01-01T00:00:00.000Z",
                      @"updatedAt": @"1970-01-01T00:00:00.000Z",
                      } };
}

#pragma mark - Options

+ (NSDictionary *)dvs_postOptionsForReceivedOptions:(NSDictionary *)receivedOptions {
    return [self dvs_optionsForReceivedOptions:receivedOptions andMethod:@"POST"];
}

+ (NSDictionary *)dvs_deleteOptionsForReceivedOptions:(NSDictionary *)receivedOptions {
    return [self dvs_optionsForReceivedOptions:receivedOptions andMethod:@"DELETE"];
}

+ (NSDictionary *)dvs_putOptionsForReceivedOptions:(NSDictionary *)receivedOptions {
    return [self dvs_optionsForReceivedOptions:receivedOptions andMethod:@"PUT"];
}

+ (NSDictionary *)dvs_optionsForReceivedOptions:(NSDictionary *)receivedOptions andMethod:(NSString *)methodName {
    return [self dvs_optionsDictionaryForReceivedOptions:receivedOptions
                                          defaultOptions:@{ DVSHTTPStubsAllowedMethodsKey: @[ methodName ] }];
}

#pragma mark - Convenience methods

+ (OHHTTPStubsResponse *)dvs_responseWithJSON:(id)jsonObject statusCode:(int)statusCode {
    return [OHHTTPStubsResponse responseWithJSONObject:jsonObject statusCode:statusCode headers:nil];
}

+ (NSDictionary *)dvs_optionsDictionaryForReceivedOptions:(NSDictionary *)options defaultOptions:(NSDictionary *)defaults {
    NSMutableDictionary *mutableOptions = (options != nil) ? [options mutableCopy] : [NSMutableDictionary dictionary];
    [defaults enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (mutableOptions[key] == nil) {
            mutableOptions[key] = obj;
        }
    }];
    return [mutableOptions copy];
}

@end
