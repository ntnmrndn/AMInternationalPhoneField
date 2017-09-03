//
//  AMCountries.h
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 30/06/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AMCountry : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *dialCode;
@property (nonatomic, strong) NSString *name;
- (NSString *)flag;

@end


@interface AMCountries : NSObject
/**
 * Return a country from a given phone number.
 * The result can be inaccurate if multiple countries share the same identifier (Ex: US and Canada).
 */
- (AMCountry *)findFromPhoneNumber:(NSString *)phoneNumber;
- (AMCountry *)findWithCountryCode:(NSString *)countryCode;
- (NSInteger)count;
- (AMCountry *)atIndex:(NSInteger)i;

@end
