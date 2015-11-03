//
//  BudgetsViewController.m
//  ReceiptVision
//
//  Created by Nikhil Kulkarni on 9/26/15.
//  Copyright © 2015 Nikhil Kulkarni. All rights reserved.
//

#import "BudgetsViewController.h"

@interface BudgetsViewController ()

@end

@implementation BudgetsViewController

NSArray *items;
NSArray *spent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    items = @[[PNPieChartDataItem dataItemWithValue:20 color:PNGreen description:@"Clothing"], [PNPieChartDataItem dataItemWithValue:10 color:PNDarkBlue description:@"Electronics"], [PNPieChartDataItem dataItemWithValue:5 color:PNGreen description:@"Entertainment"], [PNPieChartDataItem dataItemWithValue:14 color:PNDarkBlue description:@"Gas"], [PNPieChartDataItem dataItemWithValue:13 color:PNGreen description:@"Gifts"], [PNPieChartDataItem dataItemWithValue:15 color:PNDarkBlue description:@"Grocery"], [PNPieChartDataItem dataItemWithValue:8 color:PNGreen description:@"Miscellaneous"], [PNPieChartDataItem dataItemWithValue:15 color:PNDarkBlue description:@"Restaurants"]];
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(25, 25, self.pieGraphView.frame.size.width - 50, self.pieGraphView.frame.size.height - 50) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Next" size:8.0];
    [pieChart strokeChart];
    [self.pieGraphView addSubview:pieChart];
    
    PNBarChart *barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 25, self.barGraphView.frame.size.width, self.barGraphView.frame.size.height - 25)];
    [barChart setXLabels:@[@"Clothing", @"Electronics", @"Entertainment", @"Gas", @"Gifts", @"Grocery", @"Miscellaneous", @"Restaurants"]];
    spent = @[@30, @50, @70, @30, @80, @40, @20, @35];
    [barChart setYValues:spent];
    [barChart setYMaxValue:100];
    [barChart strokeChart];
    [self.barGraphView addSubview:barChart];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
