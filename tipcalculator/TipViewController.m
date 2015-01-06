//
//  TipViewController.m
//  tipcalculator
//
//  Created by Neal Wu on 1/4/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

- (void)onSettingsButton;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateValues];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger badServiceTip = [defaults integerForKey:@"badServiceTip"];
    NSInteger avgServiceTip = [defaults integerForKey:@"avgServiceTip"];
    NSInteger greatServiceTip = [defaults integerForKey:@"greatServiceTip"];

    [self.tipControl setTitle:[NSString stringWithFormat:@"%ld%%", badServiceTip] forSegmentAtIndex:0];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%ld%%", avgServiceTip] forSegmentAtIndex:1];
    [self.tipControl setTitle:[NSString stringWithFormat:@"%ld%%", greatServiceTip] forSegmentAtIndex:2];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (IBAction)billEditingDidBegin {
    NSLog(@"Editing begin");

    if (self.billTextField.text.length == 0) {
        self.billTextField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    }
}

- (IBAction)billEditingDidEnd {
    NSLog(@"Editing end");

    NSString *billValue = self.billTextField.text;
    billValue = [billValue stringByReplacingOccurrencesOfString:@"$" withString:@""];
    billValue = [billValue stringByReplacingOccurrencesOfString:@"," withString:@""];

    double value = [billValue doubleValue];
    NSLog(@"%f", value);

    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    self.billTextField.text = [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
}

- (IBAction)billEditingChanged {
    NSLog(@"Editing changed");
}

- (void)updateValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger badServiceTip = [defaults integerForKey:@"badServiceTip"];
    NSInteger avgServiceTip = [defaults integerForKey:@"avgServiceTip"];
    NSInteger greatServiceTip = [defaults integerForKey:@"greatServiceTip"];
    NSArray *tipValues = @[@(badServiceTip), @(avgServiceTip), @(greatServiceTip)];

    NSString *billValue = self.billTextField.text;
    billValue = [billValue stringByReplacingOccurrencesOfString:@"$" withString:@""];
    billValue = [billValue stringByReplacingOccurrencesOfString:@"," withString:@""];

    double billAmount = [billValue doubleValue];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue] / 100.0;
    float totalAmount = billAmount + tipAmount;

    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
