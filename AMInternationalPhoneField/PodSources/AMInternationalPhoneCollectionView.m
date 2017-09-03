//
//  AMInternationalPhoneTableView.m
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 03/07/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

#import "AMInternationalPhoneCollectionView.h"

@implementation AMInternationalPhoneCollectionView

- (AMInternationalPhoneCollectionView *)initWithParent:(AMInternationalPhoneField *)parent {
    self = [self initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    self.delegate = parent;
    self.dataSource = parent;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    [self registerNib:[UINib nibWithNibName:@"AMInternationalPhoneCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AMInternationalPhoneCollectionViewCell"];
    return self;
}

@end

@interface AMInternationalPhoneCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *flag;
@property (nonatomic, weak) IBOutlet UILabel *countryName;
@property (nonatomic, weak) IBOutlet UILabel *countryDialCode;

@end

@implementation AMInternationalPhoneCollectionViewCell

- (void)setCountry:(AMCountry *)country {
    self.countryDialCode.text = country.dialCode;
    self.flag.text = country.flag;
    self.countryName.text = country.name;
    _country = country;
}


@end
