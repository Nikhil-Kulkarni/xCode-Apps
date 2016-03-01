//
//  AddViewController.h
//  Calorie
//
//  Created by Nikhil Kulkarni on 2/19/16.
//  Copyright © 2016 Nikhil Kulkarni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController
@property (weak, nonatomic) NSMutableArray *foods;
@property (nonatomic) UInt64 calorieCount;
@property (nonatomic) UInt64 goal;

@property (strong, nonatomic) IBOutlet UITextField *foodName;
@property (strong, nonatomic) IBOutlet UITextField *numberCalories;

- (IBAction)save:(UIBarButtonItem *)sender;
- (IBAction)cancel:(id)sender;

@end
