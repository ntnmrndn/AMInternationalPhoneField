//
//  AMCountries.m
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 30/06/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

@import UIKit;

#import "AMCountries.h"


#if __has_include(<libPhoneNumber-iOS/NBPhoneNumber.h>)

#import <libPhoneNumber-iOS/NBPhoneNumber.h>
#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>

#else 

@import libPhoneNumber_iOS;

#endif




@implementation AMCountry

+ (instancetype)fromJSON:(NSDictionary *)dictionnary {
    AMCountry *country = [[AMCountry alloc] init];
    country.code = dictionnary[@"code"];
    country.name = dictionnary[@"name"];
    country.dialCode = dictionnary[@"dial_code"];
    return country;
}

- (NSString *)flag {
    int base = 127462 -65;
    wchar_t bytes[2] = {
        base +[self.code characterAtIndex:0],
        base +[self.code characterAtIndex:1]
    };
        
    return [[NSString alloc] initWithBytes:bytes
                                        length:self.code.length *sizeof(wchar_t)
                                      encoding:NSUTF32LittleEndianStringEncoding];
}


@end


@interface AMCountries ()

@property (nonatomic, strong) NSArray<AMCountry *>*countries;

@end

@implementation AMCountries

- (AMCountry *)findFromPhoneNumber:(NSString *)phoneNumber {
    AMCountry *matchingCountry = nil;
    
    for (AMCountry *country in self.countries) {
        if ([phoneNumber hasPrefix:country.dialCode]) {
            if (matchingCountry) {
                return nil;
            }
            matchingCountry = country;
        }
    }
    return matchingCountry;
}

- (AMCountry *)findWithCountryCode:(NSString *)countryCode {
    for (AMCountry *country in self.countries) {
        if ([country.code isEqualToString:countryCode]) {
            return country;
        }
    
    }
    return nil;
}


- (NSInteger)count {
    return self.countries.count;
}


- (AMCountry *)atIndex:(NSInteger) i {
    return self.countries[i];
}


- (instancetype) init {
    self = [super init];
    NSMutableArray *countries = [[NSMutableArray alloc] init];
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[AMCountries class]];
    NSURL *bundleURL = [NSBundle URLForResource:@"AMInternationalPhoneField" withExtension:@"bundle" subdirectory:nil inBundleWithURL:frameWorkBundle.bundleURL];
    //XXX should not be needed if we are distributed through pods.
    NSURL *jsonURL = [bundleURL URLByAppendingPathComponent:@"AMCountries.json"];
    if (!bundleURL) {
        jsonURL = [[NSBundle mainBundle] URLForResource:@"AMCountries" withExtension:@"json"];
    }
    NSData *data = [NSData dataWithContentsOfURL:jsonURL];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    
    for (NSDictionary *dic in json) {
        AMCountry *country = [AMCountry fromJSON:dic];
        [countries addObject:country];
    }
    self.countries = countries;

    return self;
}

@end

