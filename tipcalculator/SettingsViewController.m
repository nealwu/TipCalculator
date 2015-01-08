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
@property (weak, nonatomic) IBOutlet UIStepper *avgServiceStepper;
@property (weak, nonatomic) IBOutlet UIStepper *greatServiceStepper;
@property (weak, nonatomic) IBOutlet UILabel *badServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *greatServiceLabel;

- (void)setLabelPercentagesWithBadService:(NSInteger)badServiceTip withAvgService:(NSInteger)avgServiceTip withGreatService:(NSInteger)greatServiceTip;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = @"Settings";
    }

    return self;
}

- (void)setLabelPercentagesWithBadService:(NSInteger)badServiceTip withAvgService:(NSInteger)avgServiceTip withGreatService:(NSInteger)greatServiceTip {
    self.badServiceLabel.text = [NSString stringWithFormat:@"%ld%%", badServiceTip];
    self.avgServiceLabel.text = [NSString stringWithFormat:@"%ld%%", avgServiceTip];
    self.greatServiceLabel.text = [NSString stringWithFormat:@"%ld%%", greatServiceTip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger badServiceTip = [defaults integerForKey:@"badServiceTip"];
    NSInteger avgServiceTip = [defaults integerForKey:@"avgServiceTip"];
    NSInteger greatServiceTip = [defaults integerForKey:@"greatServiceTip"];

    [self setLabelPercentagesWithBadService:badServiceTip withAvgService:avgServiceTip withGreatService:greatServiceTip];

    // Set the stepper values
    self.badServiceStepper.value = badServiceTip == 0 ? DEFAULT_BAD_SERVICE_TIP : badServiceTip;
    self.avgServiceStepper.value = avgServiceTip == 0 ? DEFAULT_AVG_SERVICE_TIP : avgServiceTip;
    self.greatServiceStepper.value = greatServiceTip == 0 ? DEFAULT_GREAT_SERVICE_TIP : greatServiceTip;
}

- (IBAction)steppersChanged {
    NSInteger badServiceTip = self.badServiceStepper.value;
    NSInteger avgServiceTip = self.avgServiceStepper.value;
    NSInteger greatServiceTip = self.greatServiceStepper.value;

    [self setLabelPercentagesWithBadService:badServiceTip withAvgService:avgServiceTip withGreatService:greatServiceTip];

    // Save to the NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:badServiceTip forKey:@"badServiceTip"];
    [defaults setInteger:avgServiceTip forKey:@"avgServiceTip"];
    [defaults setInteger:greatServiceTip forKey:@"greatServiceTip"];
    [defaults synchronize];
}

@end
