//
//  AMInternationalPhoneInput.h
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 30/06/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMInternationalPhoneField : UITextField<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

- (void)setCountryWithCode:(NSString *)code;
- (NSString *)defaultCountry;
- (IBAction)hideCountryList;


@property (nonatomic, readwrite) NSString *phoneNumber;


@end
