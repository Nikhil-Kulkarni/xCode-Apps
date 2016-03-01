//
//  ViewController.m
//  Calorie
//
//  Created by Nikhil Kulkarni on 2/19/16.
//  Copyright © 2016 Nikhil Kulkarni. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <PNChart.h>
#import <STPopup/STPopup.h>
#import "NKFirstLaunch.h"
#import <QuartzCore/QuartzCore.h>

@interface PopupViewController : UIViewController
@property (strong, nonatomic) UITextField *field;
@end

@implementation PopupViewController

- (NSManagedObjectContext *) managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = nil;
    context = [delegate managedObjectContext];
    return context;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"Goal";
        self.navigationItem.rightBarButtonItem = nil;
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Add views here
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 - 15 - 30, self.view.frame.size.width - 30, 30)];
    [self.field setPlaceholder:@"Goal"];
    [self.field setKeyboardType:UIKeyboardTypeNumberPad];
    self.field.layer.borderColor = [UIColor blackColor].CGColor;
    self.field.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.field];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 88, self.view.frame.size.height - 10 - 60, 176, 50)];
    UIColor *darkBlue = [UIColor colorWithRed:39.0/255.0 green:56.0/255.0 blue:76.0/255.0 alpha:1.0];
    [button setBackgroundColor:darkBlue];
    [button setTitle:@"Save Goal" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(saveGoal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void) saveGoal {
    NSString *goal = self.field.text;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    NSMutableArray *arr = [context executeFetchRequest:fetchRequest error:nil].mutableCopy;
    if (arr.count != 0) {
        NSManagedObject *obj = arr[0];
        [obj setValue:[NSNumber numberWithInt:goal.intValue] forKey:@"goal"];
        NSLog(@"%d", goal.intValue);
    } else {
        NSLog(@"Making new object");
        NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Goal" inManagedObjectContext:context];
        [obj setValue:[NSNumber numberWithInt:goal.intValue] forKey:@"goal"];
    }
    [context save:nil];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.field endEditing:true];
}


@end

@interface ViewController ()

@end

@implementation ViewController

int offset = 0;

- (NSManagedObjectContext *) managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = nil;
    context = [delegate managedObjectContext];
    return context;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    if ([NKFirstLaunch isFirstLaunch]) {
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[PopupViewController new]];
        [popupController presentInViewController:self];
        [self.popupController pushViewController:self animated:true];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIColor *darkRed = [UIColor colorWithRed:180.0/255.0 green:36.0/255.0 blue:28.0/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:226.0/255.0 green:51.0/255.0 blue:42.0/255.0 alpha:1.0];
    UIColor *gray = [UIColor colorWithRed:131.0/255.0 green:149.0/255.0 blue:148.0/255.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:38.0/255.0 green:130.0/255.0 blue:213.0/255.0 alpha:1.0];
    UIColor *darkBlue = [UIColor colorWithRed:39.0/255.0 green:56.0/255.0 blue:76.0/255.0 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:21.0/255.0 green:178.0/255.0 blue:137.0/255.0 alpha:1.0];
    UIColor *orange = [UIColor colorWithRed:255.0/255.0 green:130.0/255.0 blue:0.0 alpha:1.0];
    UIColor *darkGrey = [UIColor colorWithRed:107.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:1.0];
    
    [[self navigationController] setNavigationBarHidden:false];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = orange;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Top View
    UIView *topLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [topLeftView setBackgroundColor:darkRed];
    [self.view addSubview:topLeftView];
    UIView *topRightView = [[UIView alloc] initWithFrame:CGRectMake(topLeftView.frame.origin.x + topLeftView.frame.size.width, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [topRightView setBackgroundColor:red];
    [self.view addSubview:topRightView];
    
    // Middle Views
    UIView *middleLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, topLeftView.frame.origin.y + topLeftView.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [middleLeftView setBackgroundColor:darkGrey];
    [self.view addSubview:middleLeftView];
    UIView *middleRightView = [[UIView alloc] initWithFrame:CGRectMake(middleLeftView.frame.origin.x + middleLeftView.frame.size.width, topLeftView.frame.origin.y + topLeftView.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [middleRightView setBackgroundColor:gray];
    [self.view addSubview:middleRightView];
    
    // Bottom Views
    UIView *bottomLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, middleLeftView.frame.origin.y + topLeftView.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [bottomLeftView setBackgroundColor:darkBlue];
    [self.view addSubview:bottomLeftView];
    UIView *bottomRightView = [[UIView alloc] initWithFrame:CGRectMake(bottomLeftView.frame.origin.x + bottomLeftView.frame.size.width, middleLeftView.frame.origin.y + topLeftView.frame.size.height, self.view.frame.size.width / 2, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3)];
    [bottomRightView setBackgroundColor:blue];
    [self.view addSubview:bottomRightView];
    
    // Number calories consumed this week
    UILabel *caloriesThisWeek = [[UILabel alloc] initWithFrame:CGRectMake(topLeftView.frame.size.width / 2 - 50, topLeftView.frame.size.height / 2 - 50, 100, 100)];
    [caloriesThisWeek setText:[NSString stringWithFormat:@"%@", [self getCalorieCount]]];
    [caloriesThisWeek setTextAlignment:NSTextAlignmentCenter];
    [caloriesThisWeek setTextColor:[UIColor whiteColor]];
    caloriesThisWeek.font = [caloriesThisWeek.font fontWithSize:28.0];
    [topLeftView addSubview:caloriesThisWeek];
    
    // Get Goal from Core Data
    NSManagedObjectContext *goalContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Goal"];
    NSMutableArray *arr = [goalContext executeFetchRequest:fetchRequest error:nil].mutableCopy;
    if (arr.count == 0) {
        self.goal = 0;
    } else {
        NSManagedObject *obj = arr[0];
        self.goal = [[obj valueForKey:@"Goal"] intValue];
    }
    
    // Percentage of goal consumed
    UILabel *percentageOfGoal = [[UILabel alloc] initWithFrame:CGRectMake(topRightView.frame.size.width / 2 - 50, topRightView.frame.size.height / 2 - 50, 100, 100)];
    if (self.goal == 0) {
        [percentageOfGoal setText:[NSString stringWithFormat:@"No Goal"]];
    } else {
        NSLog(@"%llu", self.calorieCount);
        [percentageOfGoal setText:[NSString stringWithFormat:@"%d%%", (int)((double)self.calorieCount / self.goal * 100)]];
    }
    [percentageOfGoal setTextAlignment:NSTextAlignmentCenter];
    [percentageOfGoal setTextColor:[UIColor whiteColor]];
    percentageOfGoal.font = [caloriesThisWeek.font fontWithSize:28.0];
    [middleLeftView addSubview:percentageOfGoal];
    
    // The goal for this week
    UILabel *thisWeeksGoal = [[UILabel alloc] initWithFrame:CGRectMake(middleLeftView.frame.size.width / 2 - 50, middleLeftView.frame.size.height / 2 - 50, 100, 100)];
    if (self.goal == 0) {
        [thisWeeksGoal setText:@"No Goal"];
    } else {
        [thisWeeksGoal setText:[NSString stringWithFormat:@"%llu", self.goal]];
    }
    [thisWeeksGoal setTextAlignment:NSTextAlignmentCenter];
    [thisWeeksGoal setTextColor:[UIColor whiteColor]];
    thisWeeksGoal.font = [caloriesThisWeek.font fontWithSize:28.0];
    [topRightView addSubview:thisWeeksGoal];
    
    // Food History
    UILabel *foodHistory = [[UILabel alloc] initWithFrame:CGRectMake(middleRightView.frame.size.width / 2 - 50, middleRightView.frame.size.height / 2 - 50, 100, 100)];
    [foodHistory setText:@"History"];
    [foodHistory setTextAlignment:NSTextAlignmentCenter];
    [foodHistory setTextColor:[UIColor whiteColor]];
    foodHistory.font = [caloriesThisWeek.font fontWithSize:28.0];
    [middleRightView addSubview:foodHistory];
    
    // Qeury db
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Foods"];
    self.foods = [context executeFetchRequest:request error:nil].mutableCopy;
    
    // Food History mini table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, middleRightView.frame.size.width, middleRightView.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = gray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [middleRightView addSubview:self.tableView];
    
    // Graph
    PNCircleChart *circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(15, 15, bottomLeftView.frame.size.width - 30, bottomLeftView.frame.size.height - 40) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:(int)((double)self.calorieCount / self.goal * 100)] clockwise:NO shadow:NO shadowColor:nil];
    [circleChart setBackgroundColor:[UIColor clearColor]];
    [circleChart setStrokeColor:PNGreen];
    [circleChart strokeChart];
    [bottomLeftView addSubview:circleChart];
    
    // Add Button
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(bottomRightView.frame.size.width / 2 - 25, bottomRightView.frame.size.height / 2 - 25, 50, 50)];
    UIImage *image = [UIImage imageNamed:@"addButton"];
    [addButton setImage:image forState:UIControlStateNormal];
    [bottomRightView addSubview:addButton];
    [addButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // History Button
    UIButton *historyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, middleRightView.frame.size.width, middleRightView.frame.size.width)];
    [middleRightView addSubview:historyButton];
    [historyButton addTarget:self action:@selector(historyPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // Goal Button
    UIButton *goalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, topRightView.frame.size.width, topRightView.frame.size.height)];
    [topRightView addSubview:goalButton];
    [goalButton addTarget:self action:@selector(goalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"addFood"]) {
//        UIViewController *destination = (AddViewController *)segue.destinationViewController;
        
    }
}

#pragma mark - Table view data source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.foods.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
        [cell.textLabel setText:@"No History"];
        
        UIColor *gray = [UIColor colorWithRed:131.0/255.0 green:149.0/255.0 blue:148.0/255.0 alpha:1.0];
        [cell setBackgroundColor:gray];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 30)];
    NSManagedObject *obj = [self.foods objectAtIndex:self.foods.count - indexPath.row - 1];
    [cell.textLabel setText:[obj valueForKey:@"name"]];
    
    UIColor *gray = [UIColor colorWithRed:131.0/255.0 green:149.0/255.0 blue:148.0/255.0 alpha:1.0];
    [cell setBackgroundColor:gray];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.foods.count == 0) {
        return 1;
    }
    return self.foods.count;
}

- (NSString *) getCalorieCount {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Foods"];
    NSArray *arr = [context executeFetchRequest:fetchRequest error:nil];
    NSNumber *countSum = [arr valueForKeyPath:@"@sum.calories"];
    NSString *str = [NSString stringWithFormat:@"%@", countSum];
    self.calorieCount = [str intValue];
    return str;
}

- (void) goalButtonPressed {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[PopupViewController new]];
    [popupController presentInViewController:self];
    [self.popupController pushViewController:[ViewController new] animated:YES];
}

- (void) buttonPressed {
    [self performSegueWithIdentifier:@"addFood" sender:nil];
}

- (void) historyPressed {
    [self performSegueWithIdentifier:@"showHistory" sender:nil];
}

- (IBAction)cancel:(UIStoryboardSegue *)segue {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
