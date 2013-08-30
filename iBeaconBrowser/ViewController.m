//
//  ViewController.m
//  iBeaconBrowser
//
//  Created by Luis Abreu on 30/08/2013.
//  Copyright (c) 2013 lmjabreu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *nearbyBeacons;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Fix UITableView positioning
    [self.tableView setContentInset:UIEdgeInsetsMake(20,
                                                     self.tableView.contentInset.left,
                                                     self.tableView.contentInset.bottom,
                                                     self.tableView.contentInset.right)];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self startRangingBeacons];
}

// Start browsing for beacons
- (void)startRangingBeacons
{
    // I belong to this major group (Apple)
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:@"96BF94BC-4C17-42D8-90B4-7ACBE7A8DEA0"];
    // I belong to this region (eg: Apple Store)
    NSString *regionIdentifier = @"AppleStore";

    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                           identifier:regionIdentifier];

    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to Range"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it"
                                              otherButtonTitles:nil];
    [alertView show];
}

// Handle when beacons come in range
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count) {
        NSLog(@"Found beacons!: %@ in region: %@", beacons, region);
        self.nearbyBeacons = beacons;
    } else {
        NSLog(@"No Beacons found.");
        CLBeacon *unknownBeacon = [[CLBeacon alloc] init];
        self.nearbyBeacons = @[unknownBeacon];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyBeacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"BeaconCell" forIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = self.nearbyBeacons[indexPath.row];
    
    switch (beacon.proximity) {
        case CLProximityImmediate:
            cell.detailTextLabel.text = @"Immediate";
            break;
            
        case CLProximityNear:
            cell.detailTextLabel.text = @"Near";
            break;
            
        case CLProximityFar:
            cell.detailTextLabel.text = @"Far";
            break;
            
        case CLProximityUnknown:
            cell.detailTextLabel.text = @"Unknown";
            break;
            
        default:
            cell.detailTextLabel.text = @"N/A";
            break;
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%i: %@.%@", indexPath.row, beacon.major, beacon.minor];
}

@end
