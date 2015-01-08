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
@property (strong, nonatomic) NSString *currencySymbol;
@property (weak, nonatomic) IBOutlet UILabel *groupSizeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *groupSizeStepper;
@property (weak, nonatomic) IBOutlet UILabel *totalPerPersonLabel;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

- (void)onSettingsButton;

- (double)parseAmount:(NSString *)amount;
- (NSString *)formatAmount:(double)amount;
- (double)roundCents:(double)amount;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title = @"Tip Calculator";

        self.currencyFormatter = [[NSNumberFormatter alloc] init];
        [self.currencyFormatter setLocale:[NSLocale currentLocale]];
        [self.currencyFormatter setMaximumFractionDigits:2];
        [self.currencyFormatter setMinimumFractionDigits:2];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        self.currencyFormatter.lenient = YES;
        self.currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    }

    return self;
}

- (double)parseAmount:(NSString *)amount {
    return [[self.currencyFormatter numberFromString:amount] doubleValue];
}

- (NSString *)formatAmount:(double)amount {
    return [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:amount]];
}

- (double)roundCents:(double)amount {
    return round(100 * amount) / 100;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double savedBillAmount = [defaults doubleForKey:@"billAmount"];

    double lastUpdatedTime = [defaults doubleForKey:@"lastUpdatedTime"];
    double currentTime = [[NSDate date] timeIntervalSinceReferenceDate];

    // Only reuse the previous bill amount if we're within the valid time window
    if (currentTime - lastUpdatedTime < MAXIMUM_BILL_HOLD_TIME) {
        self.billTextField.text = [self formatAmount:savedBillAmount];
    }

    self.groupSizeStepper.value = [self.groupSizeLabel.text integerValue];
    [self updateValues];
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
    if ([self parseAmount:self.billTextField.text] == 0) {
        self.billTextField.text = @"";
    }

    // Remove the extra characters to leave only the number
    self.billTextField.text = [self.billTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.billTextField.text = [self.billTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.billTextField.text = [self.billTextField.text stringByReplacingOccurrencesOfString:self.currencySymbol withString:@""];
}

- (IBAction)billEditingDidEnd {
    double value = [self parseAmount:self.billTextField.text];
    self.billTextField.text = [self formatAmount:value];
}

- (IBAction)billEditingChanged {
    [self updateValues];
}

- (void)updateValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger badServiceTip = [defaults integerForKey:@"badServiceTip"];
    NSInteger avgServiceTip = [defaults integerForKey:@"avgServiceTip"];
    NSInteger greatServiceTip = [defaults integerForKey:@"greatServiceTip"];
    NSArray *tipValues = @[@(badServiceTip), @(avgServiceTip), @(greatServiceTip)];

    // Set the segmented control button values
    for (int i = 0; i < 3; i++) {
        [self.tipControl setTitle:[NSString stringWithFormat:@"%@%%", tipValues[i]] forSegmentAtIndex:i];
    }

    double billAmount = [self roundCents:[self parseAmount:self.billTextField.text]];
    double tipAmount = [self roundCents:billAmount * [tipValues[self.tipControl.selectedSegmentIndex] doubleValue] / 100.0];
    double totalAmount = [self roundCents:billAmount + tipAmount];

    self.tipLabel.text = [self formatAmount:tipAmount];
    self.totalLabel.text = [self formatAmount:totalAmount];

    int groupSize = (int) self.groupSizeStepper.value;
    self.totalPerPersonLabel.text = [self formatAmount:totalAmount / groupSize];

    double currentTime = [[NSDate date] timeIntervalSinceReferenceDate];
    [defaults setDouble:billAmount forKey:@"billAmount"];
    [defaults setDouble:currentTime forKey:@"lastUpdatedTime"];
    [defaults synchronize];
}

- (void)onSettingsButton {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

- (IBAction)groupSizeChanged {
    self.groupSizeLabel.text = [NSString stringWithFormat:@"%.0f", self.groupSizeStepper.value];
    [self updateValues];
}

@end
