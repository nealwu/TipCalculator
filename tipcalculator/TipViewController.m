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
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

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

        self.currencyFormatter = [[NSNumberFormatter alloc] init];
        [self.currencyFormatter setLocale:[NSLocale currentLocale]];
        [self.currencyFormatter setMaximumFractionDigits:2];
        [self.currencyFormatter setMinimumFractionDigits:2];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
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
    [self updateValues];
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

    self.billTextField.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
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

    for (int i = 0; i < 3; i++) {
        [self.tipControl setTitle:[NSString stringWithFormat:@"%@%%", tipValues[i]] forSegmentAtIndex:i];
    }

    NSString *billValue = self.billTextField.text;
    billValue = [billValue stringByReplacingOccurrencesOfString:@"$" withString:@""];
    billValue = [billValue stringByReplacingOccurrencesOfString:@"," withString:@""];

    double billAmount = [billValue doubleValue];
    double tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue] / 100.0;
    double totalAmount = billAmount + tipAmount;

    self.tipLabel.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:tipAmount]];
    self.totalLabel.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:totalAmount]];
}

- (void)onSettingsButton {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

@end
