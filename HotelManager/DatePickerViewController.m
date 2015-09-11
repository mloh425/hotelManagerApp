//
//  DatePickerViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/8/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "DatePickerViewController.h"
#import "ReservationRoomPickerViewController.h"

@interface DatePickerViewController ()
  @property(strong, nonatomic)UIDatePicker *startDatePicker;
  @property(strong, nonatomic)UIDatePicker *endDatePicker;
  @property(strong, nonatomic)UILabel *startDateLabel;
  @property(strong, nonatomic)UILabel *endDateLabel;
  @property(strong, nonatomic)NSDateFormatter *dateFormatter;
@end

@implementation DatePickerViewController

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  
  self.startDatePicker = [[UIDatePicker alloc] init];
  self.startDatePicker.datePickerMode = UIDatePickerModeDate;
  [self.startDatePicker setTranslatesAutoresizingMaskIntoConstraints:false];
  rootView.backgroundColor = [UIColor whiteColor];
  [rootView addSubview: self.startDatePicker];
  
  self.endDatePicker = [[UIDatePicker alloc] init];
  self.endDatePicker.datePickerMode = UIDatePickerModeDate;
  [self.endDatePicker setTranslatesAutoresizingMaskIntoConstraints:false];
  rootView.backgroundColor = [UIColor whiteColor];
  [rootView addSubview: self.endDatePicker];
  
  self.startDateLabel = [[UILabel alloc] init];
  [self.startDateLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  self.startDateLabel.text = @"Select Check In Date";
  [rootView addSubview: self.startDateLabel];
  
  self.endDateLabel = [[UILabel alloc] init];
  [self.endDateLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  self.endDateLabel.text = @"Select Check Out Date";
  [rootView addSubview: self.endDateLabel];
  
  NSDictionary *views = @{@"startDatePicker" : self.startDatePicker,@"endDatePicker" :  self.endDatePicker, @"startDateLabel" : self.startDateLabel, @"endDateLabel" : self.endDateLabel};
  
  //Start Date Label Constraints
  NSArray *startDateLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[startDateLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:startDateLabelHorizontalConstraints];
  NSArray *startDateLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-70-[startDateLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:startDateLabelVerticalConstraints];
  
  //Start Date Picker Constraints
  NSArray *startDatePickerHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startDatePicker]|" options:0 metrics:nil views:views];
  [rootView addConstraints:startDatePickerHorizontalConstraints];
  NSArray *startDatePickerVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[startDateLabel][startDatePicker]" options:0 metrics:nil views:views];
  [rootView addConstraints:startDatePickerVerticalConstraints];

  //End Date Label Constraints
  NSArray *endDateLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endDateLabel]|" options:0 metrics:nil views:views];
  [rootView addConstraints:endDateLabelHorizontalConstraints];
  NSArray *endDateLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[startDatePicker][endDateLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:endDateLabelVerticalConstraints];
  
  //End Date Picker Constraints
  NSArray *endDatePickerHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endDatePicker]|" options:0 metrics:nil views:views];
  [rootView addConstraints:endDatePickerHorizontalConstraints];
  NSArray *endDatePickerVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[endDateLabel][endDatePicker]" options:0 metrics:nil views:views];
  [rootView addConstraints:endDatePickerVerticalConstraints];
  
  UIButton *nextButton = [[UIButton alloc] init];
  //Fire method when button clicked
  [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  //Button setup
  [nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [nextButton setTitle:@"Next" forState:UIControlStateNormal];
  [nextButton setTranslatesAutoresizingMaskIntoConstraints:false];
  [rootView addSubview:nextButton];
  
  NSLayoutConstraint *nextButtonCenterX = [NSLayoutConstraint constraintWithItem:nextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  nextButtonCenterX.active = true;
  
  NSLayoutConstraint *nextButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:nextButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8];
  nextButtonBottomConstraint.active = true;
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonPressed:(UIButton *)sender {
  ReservationRoomPickerViewController *reservationRoomPickerViewController = [[ReservationRoomPickerViewController alloc] init];
  reservationRoomPickerViewController.startDate = self.startDatePicker.date;
  reservationRoomPickerViewController.endDate = self.endDatePicker.date;
  [self.navigationController pushViewController:reservationRoomPickerViewController animated:true];
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
