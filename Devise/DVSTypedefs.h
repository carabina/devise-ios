//
//  DVSTypedefs.h
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DVSUser;

typedef void (^DVSErrorBlock)(NSError *error);
typedef void (^DVSVoidBlock)(void);

typedef NSDictionary *(^DVSExtraParamsBlock)(void);