//
//  MenuViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/9/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "MenuViewController.h"
#import "HotelListViewController.h"
#import "DatePickerViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation MenuViewController

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  self.tableView = [[UITableView alloc] initWithFrame:rootView.frame style:UITableViewStyleGrouped];
  [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
  [rootView addSubview:self.tableView];
  
  NSDictionary *views = @{@"tableView" : self.tableView};
  
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
  [rootView addConstraints:tableViewVerticalConstraints];
  [rootView addConstraints:tableViewHorizontalConstraints];
  
  self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
 // self.tableView.rowHeight = ([UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.bounds.size.height) / 3;
  self.tableView.rowHeight = 40;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // configure cell...
  switch(indexPath.row) { // assuming there is only one section
    case 0:
      cell.textLabel.text = @"Browse Hotels";
      break;
    case 1:
      cell.textLabel.text = @"Book Hotel";
      break;
    case 2:
      cell.textLabel.text = @"Find your Reservations";
      break;
    default:
      break;
  }
  return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:true];
  NSInteger selectedRow = indexPath.row;
  switch(selectedRow) { // assuming there is only one section
    case 0: {
      HotelListViewController *hotelListViewController = [[HotelListViewController alloc] init];
      [self.navigationController pushViewController:hotelListViewController animated:true];
      NSLog(@"Browse Hotel Selected");
      break;
    }
    case 1: {
      DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] init];
      [self.navigationController pushViewController:datePickerViewController animated:true];
      NSLog(@"Book Room Selected");
      break;
    }
    case 2: {
      NSLog(@"Browse Reservation Selected");
      break;
    default:
      break;
    }
  }
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


