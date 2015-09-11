//
//  MakeReservationViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/11/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "MakeReservationViewController.h"
#import "Reservation.h"
#import "Hotel.h"
#import "Guest.h"
#import "AppDelegate.h"

@interface MakeReservationViewController ()<UITextFieldDelegate>

@property(strong, nonatomic) UITextField *firstNameTextField;
@property(strong, nonatomic) UITextField *lastNameTextField;
@property(strong, nonatomic) UILabel *startDateLabel;
@property(strong, nonatomic) UILabel *endDateLabel;
@property(strong, nonatomic) UILabel *hotelNameLabel;
@property(strong, nonatomic) UILabel *roomInformationLabel;
@property (strong,nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation MakeReservationViewController

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  
  self.firstNameTextField = [[UITextField alloc] init];
  [self.firstNameTextField setTranslatesAutoresizingMaskIntoConstraints:false];
  self.firstNameTextField.placeholder = @"First Name";
  self.firstNameTextField.textColor = [UIColor blackColor];
  self.lastNameTextField = [[UITextField alloc] init];
  [self.lastNameTextField setTranslatesAutoresizingMaskIntoConstraints:false];
  self.lastNameTextField.placeholder = @"Last Name";
  self.startDateLabel = [[UILabel alloc] init];
  [self.startDateLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  self.startDateLabel.text = [NSString stringWithFormat:@"%@", self.startDate];
  
  self.endDateLabel = [[UILabel alloc] init];
  [self.endDateLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  self.endDateLabel.text = [NSString stringWithFormat:@"%@", self.endDate];
  self.hotelNameLabel = [[UILabel alloc] init];
  [self.hotelNameLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  self.hotelNameLabel.text = self.selectedRoom.hotel.name;
  self.roomInformationLabel = [[UILabel alloc] init];
  [self.roomInformationLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  
  [rootView addSubview:self.firstNameTextField];
  [rootView addSubview:self.lastNameTextField];
  [rootView addSubview:self.startDateLabel];
  [rootView addSubview:self.endDateLabel];
  [rootView addSubview:self.hotelNameLabel];
  [rootView addSubview:self.roomInformationLabel];
  
  //Reference to objects in view.
  NSDictionary *views = @{@"firstNameTextField" : self.firstNameTextField, @"lastNameTextField" : self.lastNameTextField, @"startDateLabel" : self.startDateLabel, @"endDateLabel" : self.endDateLabel, @"hotelNameLabel" : self.hotelNameLabel, @"roomInformationLabel" : self.roomInformationLabel};
  
  //First name textfield
  NSArray *firstNameTextFieldHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstNameTextField]|" options:0 metrics:nil views:views];
  [rootView addConstraints:firstNameTextFieldHorizontalConstraints];
  
  NSArray *firstNameTextFieldVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-65-[firstNameTextField]" options:0 metrics:nil views:views];
  [rootView addConstraints:firstNameTextFieldVerticalConstraints];
  
  //Last name textfield
  NSArray *lastNameTextFieldHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lastNameTextField]|" options:0 metrics:nil views:views];
  [rootView addConstraints:lastNameTextFieldHorizontalConstraints];
  
  NSArray *lastNameTextFieldVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[firstNameTextField][lastNameTextField]" options:0 metrics:nil views:views];
  [rootView addConstraints:lastNameTextFieldVerticalConstraints];
  
  //Start date label
  NSArray *startDateLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startDateLabel]|" options:0 metrics:nil views:views];
  [rootView addConstraints:startDateLabelHorizontalConstraints];
  
  NSArray *startDateLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastNameTextField][startDateLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:startDateLabelVerticalConstraints];
  
  //End date label
  NSArray *endDateLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endDateLabel]|" options:0 metrics:nil views:views];
  [rootView addConstraints:endDateLabelHorizontalConstraints];
  
  NSArray *endDateLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[startDateLabel][endDateLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:endDateLabelVerticalConstraints];
  
  //Hotel Name label
  NSArray *hotelNameLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hotelNameLabel]|" options:0 metrics:nil views:views];
  [rootView addConstraints:hotelNameLabelHorizontalConstraints];
  
  NSArray *hotelNameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[endDateLabel][hotelNameLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:hotelNameLabelVerticalConstraints];
  
  //Room Information label
  NSArray *roomInformationLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[roomInformationLabel]|" options:0 metrics:nil views:views];
  [rootView addConstraints:roomInformationLabelHorizontalConstraints];
  
  NSArray *roomInformationLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[hotelNameLabel][roomInformationLabel]" options:0 metrics:nil views:views];
  [rootView addConstraints:roomInformationLabelVerticalConstraints];
  
  UIButton *makeReservationButton = [[UIButton alloc] init];
  //Fire method when button clicked
  [makeReservationButton addTarget:self action:@selector(makeReservationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  //Button setup
  [makeReservationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [makeReservationButton setTitle:@"Next" forState:UIControlStateNormal];
  [makeReservationButton setTranslatesAutoresizingMaskIntoConstraints:false];
  [rootView addSubview:makeReservationButton];
  
  NSLayoutConstraint *makeReservationButtonCenterX = [NSLayoutConstraint constraintWithItem:makeReservationButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  makeReservationButtonCenterX.active = true;
  
  NSLayoutConstraint *makeReservationButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:makeReservationButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8];
  makeReservationButtonBottomConstraint.active = true;
  
  self.view = rootView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return true;
}

- (void)makeReservationButtonPressed:(UIButton *)sender {
  AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
  self.managedObjectContext = appDelegate.managedObjectContext;
  Reservation *newReservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.managedObjectContext];
  newReservation.startDate = self.startDate;
  newReservation.endDate = self.endDate;
  newReservation.guest.firstName = self.firstNameTextField.text;
  newReservation.guest.lastName = self.lastNameTextField.text;
  newReservation.room = self.selectedRoom;
  //Save
  NSError *saveError;
  BOOL result = [self.managedObjectContext save:&saveError];
  if (!result) {
    NSLog(@" %@",saveError.localizedDescription);
  }
  [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  NSLog(@"%@    %@     %@",self.startDate, self.endDate, self.selectedRoom.number);
    // Do any additional setup after loading the view.
  self.title = @"Ugliest View Controller Ever.";
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
