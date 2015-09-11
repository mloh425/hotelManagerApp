//
//  HotelListViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/7/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "HotelListViewController.h"
#import "RoomsViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"

@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray * hotels;

@property (nonatomic, strong) UITableView *hotelListTableView;

@end

@implementation HotelListViewController
- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  
  self.hotelListTableView = [[UITableView alloc] initWithFrame:rootView.frame style:UITableViewStylePlain];
  [self.hotelListTableView setTranslatesAutoresizingMaskIntoConstraints:false]; //Remember this!
  //  hotelListTableView.backgroundColor = [UIColor redColor];
  [rootView addSubview:self.hotelListTableView];
  
  //Reference to objects in view.
  NSDictionary *views = @{@"tableView" : self.hotelListTableView};
  
  //Constraints, Vertical then Horizontal
  NSArray *hotelListTableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
  [rootView addConstraints:hotelListTableViewHorizontalConstraints];
  
  NSArray *hotelListTableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
  [rootView addConstraints:hotelListTableViewVerticalConstraints];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self fetchData];

  self.hotelListTableView.delegate = self;
  self.hotelListTableView.dataSource = self;
  [self.hotelListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HotelCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData {
  AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];

  NSManagedObjectContext* context = appDelegate.managedObjectContext;
  
  
 // AppDelegate* appDelegate2 = [UIApplication sharedApplication].delegate; -> another way of referencing app delegate stuff
  
  NSError *fetchError;
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  self.hotels = [context executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError) {
    NSLog(@"%@", fetchError.localizedDescription);
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

// Return the number of rows for each section in your static table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.hotels.count;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //static NSString *CellIdentifier = @"HotelCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell"];
  
  Hotel *hotelAtIndex = [self.hotels objectAtIndex:indexPath.row];
  cell.textLabel.text = hotelAtIndex.name;
  
  return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.hotelListTableView deselectRowAtIndexPath:indexPath animated:true];
  //NSInteger selectedRow = indexPath.row;
  RoomsViewController *roomsViewController = [[RoomsViewController alloc] init];
  roomsViewController.hotel = self.hotels[indexPath.row];
  [self.navigationController pushViewController:roomsViewController animated:true];
  NSLog(@"Browse Hotel Selected");

  
}

@end
