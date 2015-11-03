//
//  BudgetsViewController.h
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface BudgetsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *pieGraphView;
@property (strong, nonatomic) IBOutlet UIView *barGraphView;

@end
