//
//  ViewController.h
//  Calorie
//
//  Created by Nikhil Kulkarni on 2/19/16.
//  Copyright © 2016 Nikhil Kulkarni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *foods;
@property (nonatomic) UInt64 calorieCount;
@property (nonatomic) UInt64 goal;
@property (strong, nonatomic) UITableView *tableView;
@end

