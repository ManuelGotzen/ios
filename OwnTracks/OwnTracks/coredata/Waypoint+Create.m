//
//  Waypoint+Create.m
//  OwnTracks
//
//  Created by Christoph Krey on 29.06.15.
//  Copyright © 2015-2016 OwnTracks. All rights reserved.
//

#import "Waypoint+Create.h"
#import "Friend+Create.h"
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation Waypoint (Create)

- (void)getReverseGeoCode
{
    if (!self.placemark) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.lat doubleValue]
                                                          longitude:[self.lon doubleValue]];
        [geocoder reverseGeocodeLocation:location completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             if (!self.isDeleted) {
                 if ([placemarks count] > 0) {
                     CLPlacemark *placemark = placemarks[0];
                     self.placemark = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                     self.belongsTo.topic = self.belongsTo.topic;
                 } else {
                     self.placemark = nil;
                 }
             }
         }];
    }
}

- (NSString *)coordinateText {
    return [NSString stringWithFormat:@"%g,%g (%@%.0f%@)",
            [self.lat doubleValue],
            [self.lon doubleValue],
            NSLocalizedString(@"±", @"Short for deviation as in (±3m)"),
            [self.acc doubleValue],
            NSLocalizedString(@"m", @"Short for meters as in (±3m)")
            ];
}

- (NSString *)timestampText {
    return [NSDateFormatter localizedStringFromDate:self.tst
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterMediumStyle];
}

- (NSString *)infoText {
    return [NSString stringWithFormat:@"%@%0.f%@ (%@%.0f%@) %0.f%@ %0.f%@",
            NSLocalizedString(@"✈︎", @"Short for altitude as in ✈︎1000m"),
            [self.alt doubleValue],
            NSLocalizedString(@"m", @"Short for meters as in ✈︎1000m"),
            NSLocalizedString(@"±", @"Short for deviation as in (±3m)"),
            [self.vac doubleValue],
            NSLocalizedString(@"m", @"Short for meters as in (±3m)"),
            [self.vel doubleValue],
            NSLocalizedString(@"km/h", @"Short for kilometers per hour as in 120km/h"),
            [self.cog doubleValue],
            NSLocalizedString(@"°", @"Short for degrees celsius as in 20°")
            ];
}


@end
