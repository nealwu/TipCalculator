//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Neal Wu on 1/4/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *badServiceStepper;
@property (weak, nonatomic) IBOutlet UIStepper *averageServiceStepper;
@property (weak, nonatomic) IBOutlet UIStepper *greatServiceStepper;
@property (weak, nonatomic) IBOutlet UILabel *badServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *greatServiceLabel;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.badServiceStepper.value = 10;
    self.averageServiceStepper.value = 15;
    self.greatServiceStepper.value = 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)steppersChanged {
    self.badServiceLabel.text = [NSString stringWithFormat:@"%.0f%%", self.badServiceStepper.value];
    self.averageServiceLabel.text = [NSString stringWithFormat:@"%.0f%%", self.averageServiceStepper.value];
    self.greatServiceLabel.text = [NSString stringWithFormat:@"%.0f%%", self.greatServiceStepper.value];
}

@end
