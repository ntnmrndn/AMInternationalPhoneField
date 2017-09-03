//
//  AMInternationalPhoneInput.m
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 30/06/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

#import "AMInternationalPhoneField.h"
#import "AMCountries.h"
#import "AMInternationalPhoneCollectionView.h"
#if __has_include(<libPhoneNumber-iOS/NBPhoneNumber.h>)

#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>
#import <libPhoneNumber-iOS/NBPhoneNumber.h>
#import <libPhoneNumber-iOS/NBAsYouTypeFormatter.h>

#else

@import libPhoneNumber_iOS;

#endif


@interface AMInternationalPhoneField ()

@property (nonatomic, weak) UILabel *currentFlag;
@property (nonatomic, strong) AMCountries *coutries;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AMCountry *country;
@property (nonatomic, strong) NBPhoneNumberUtil *phoneNumberUtil;
@property (nonatomic, strong) NBAsYouTypeFormatter *formatter;

@end


@implementation AMInternationalPhoneField


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coutries = [[AMCountries alloc] init];
    self.delegate = self;

    UILabel *currentFlag = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 70, self.frame.size.height)];
    currentFlag.font = self.font;
    UICollectionView *collectionView = [[AMInternationalPhoneCollectionView alloc] initWithParent:self];

    self.currentFlag = currentFlag;
    self.collectionView = collectionView;
    self.leftView = [[UIView alloc] init];
    self.leftViewMode = UITextFieldViewModeAlways;
    [self.leftView addSubview:self.currentFlag];
    [[UIApplication sharedApplication].windows.lastObject addSubview:self.collectionView];
    [self setCountryWithCode:[self defaultCountry]];
    if (self.borderStyle == UITextBorderStyleRoundedRect) {
        self.collectionView.layer.cornerRadius = 5;
        self.collectionView.clipsToBounds = YES;
    }
    self.phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
    [self addTarget:self action:@selector(updatedText) forControlEvents:UIControlEventEditingChanged];
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleCollectionView)]];
    UINib *nib = [UINib nibWithNibName:@"AMInternationalPhoneCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"AMInternationalPhoneCollectionViewCell"];
    self.collectionView.hidden = YES;
}


- (UIView *)ancestorView {
    UIView *parent = self;
    while (parent.superview) {
        parent = parent.superview;
    }
    return parent; //Does not feels right
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect absoluteFrame = [self convertRect:self.bounds toView:nil];
    if (self.hidden) {
        self.collectionView.frame = CGRectMake(absoluteFrame.origin.x , absoluteFrame.origin.y + absoluteFrame.size.height, absoluteFrame.size.width, 25);
    } else {
        self.collectionView.frame = CGRectMake(absoluteFrame.origin.x, absoluteFrame.origin.y + absoluteFrame.size.height, absoluteFrame.size.width, self.ancestorView.frame.size.height - absoluteFrame.origin.y - absoluteFrame.size.height - 5.0);
    }
}


- (void)toggleCollectionView {
    CGRect absoluteFrame = [self convertRect:self.bounds toView:nil];

    if (self.collectionView.hidden) {
        self.collectionView.hidden = NO;
        [self.collectionView.superview bringSubviewToFront:self.collectionView];
        self.collectionView.frame = CGRectMake(absoluteFrame.origin.x, absoluteFrame.origin.y + absoluteFrame.size.height, absoluteFrame.size.width, 25);
        [UIView animateWithDuration:0.3 animations:^{
            self.collectionView.frame = CGRectMake(absoluteFrame.origin.x, absoluteFrame.origin.y + absoluteFrame.size.height, absoluteFrame.size.width, (self.ancestorView.frame.size.height - absoluteFrame.origin.y - absoluteFrame.size.height) * 0.8);
        }];
        [self resignFirstResponder];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect absoluteFrame = [self convertRect:self.bounds toView:nil];
            self.collectionView.frame = CGRectMake(absoluteFrame.origin.x , absoluteFrame.origin.y + absoluteFrame.size.height, absoluteFrame.size.width, 25);
        } completion:^(BOOL finished) {
            self.collectionView.hidden = YES;
        }];
    }
}


- (NSString *)phoneNumber {
    NSString *internationalInputString = [self.country.dialCode stringByAppendingString:self.text];
    return [[internationalInputString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789+"].invertedSet] componentsJoinedByString:@""];
}


- (void)setPhoneNumber:(NSString *)phoneNumber {
    NBPhoneNumber *parsedNumber = [self.phoneNumberUtil parse:phoneNumber defaultRegion:nil error:nil];
    if (!parsedNumber) {
        return ;
    }
    self.country = [self.coutries findFromPhoneNumber:phoneNumber];
    self.text = parsedNumber.nationalNumber.stringValue;
    [self updatedText];
}


- (IBAction)hideCountryList {
    if (!self.collectionView.hidden) {
        [self toggleCollectionView];
    }
}


- (BOOL)becomeFirstResponder {
    [self hideCountryList];
    return [super becomeFirstResponder];
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    CGSize size = [self.currentFlag.text sizeWithAttributes:@{NSFontAttributeName : self.currentFlag.font}];
    return CGRectMake(5, 0, size.width + 5, size.height);
}


-(void)setCountry:(AMCountry *)country {
    self.currentFlag.text = [NSString stringWithFormat:@"%@ %@", country.flag, country.dialCode];
    
    if (country) {
        self.formatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:country.code];
    }
    self.text = self.text;
    _country = country;
}



- (void)updatedText {
    if ([self.text hasPrefix:@"+"]) {
        AMCountry *matchingCountry = [self.coutries findFromPhoneNumber:self.text];
        if (matchingCountry) {
            self.country = matchingCountry;
            self.text = @"";
            return ;
        }
    }
    if ([self.country.dialCode hasPrefix:@"+1"] && self.country.dialCode.length == 5) {
        return ; //XXX Disable formattingr due to issue with north american territories.
    }
    NSString *formattedText = [self.formatter inputString:self.phoneNumber];
    NSString *strippedFormattedText = [formattedText substringFromIndex:self.country.dialCode.length];
    if (![strippedFormattedText isEqualToString:self.text]) {
        self.text = strippedFormattedText;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.coutries.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.country = [self.coutries atIndex:indexPath.row];
    [self toggleCollectionView];
    [self becomeFirstResponder];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AMInternationalPhoneCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"AMInternationalPhoneCollectionViewCell" forIndexPath:indexPath];
    cell.country = [self.coutries atIndex:indexPath.row];
    return cell;
}


- (void)setCountryWithCode:(NSString *)code {
    self.country = [self.coutries findWithCountryCode:code];
}



- (NSString *)defaultCountry {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
    if ([[NSLocale currentLocale] respondsToSelector:@selector(countryCode)]) {
        return [NSLocale currentLocale].countryCode;
    }
#pragma clang diagnostic pop
    return [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
}



@end
