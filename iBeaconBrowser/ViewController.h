//
//  ViewController.h
//  iBeaconBrowser
//
//  Created by Luis Abreu on 30/08/2013.
//  Copyright (c) 2013 lmjabreu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@end
