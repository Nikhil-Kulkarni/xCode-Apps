//
//  AddViewController.m
//  Calorie
//
//  Created by Nikhil Kulkarni on 2/19/16.
//  Copyright © 2016 Nikhil Kulkarni. All rights reserved.
//

#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface AddViewController ()
@end

@implementation AddViewController

- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    context = [delegate managedObjectContext];
    return context;
}

- (void)viewWillAppear:(BOOL)animated {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"CalorieCount"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:false];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:130.0/255.0 blue:0.0 alpha:1.0];
    
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

- (IBAction)save:(UIBarButtonItem *)sender {
    NSManagedObjectContext *foodContext = [self managedObjectContext];
    
    if (![self.foodName.text  isEqual: @""] && ![self.numberCalories.text isEqual:@""]) {
        [self.foods addObject:self.foodName.text];
        self.calorieCount += self.numberCalories.text.intValue;
        NSManagedObject *food = [NSEntityDescription insertNewObjectForEntityForName:@"Foods" inManagedObjectContext:foodContext];
        [food setValue:self.foodName.text forKey:@"name"];
        [food setValue:[NSNumber numberWithInt:self.numberCalories.text.intValue] forKey:@"calories"];
        [food setValue:[NSNumber numberWithInt:1] forKey:@"servings"];
        
        NSError *error;
        if(![foodContext save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Success");
        }
    }
}

@end
