//
//  AMInternationalPhoneTableView.h
//  AMInternationalPhoneField
//
//  Created by antoine marandon on 03/07/2017.
//  Copyright © 2017 antoine marandon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMCountries.h"
#import "AMInternationalPhoneField.h"

@interface AMInternationalPhoneCollectionView : UICollectionView

- (AMInternationalPhoneCollectionView *)initWithParent:(AMInternationalPhoneField *)parent;

@end

@interface AMInternationalPhoneCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AMCountry *country;

@end
