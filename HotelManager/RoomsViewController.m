//
//  RoomsViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/9/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "RoomsViewController.h"
#import "Hotel.h"

@interface RoomsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSArray * rooms;
@property (nonatomic, strong) UITableView *roomListTableView;
@end

@implementation RoomsViewController

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  
  self.roomListTableView = [[UITableView alloc] initWithFrame:rootView.frame style:UITableViewStylePlain];
  [self.roomListTableView setTranslatesAutoresizingMaskIntoConstraints:false]; //Remember this!
  [rootView addSubview:self.roomListTableView];
  
  //Reference to objects in view.
  NSDictionary *views = @{@"tableView" : self.roomListTableView};
  
  //Constraints, Vertical then Horizontal
  NSArray *roomListTableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:views];
  [rootView addConstraints:roomListTableViewHorizontalConstraints];
  
  NSArray *roomListTableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:views];
  [rootView addConstraints:roomListTableViewVerticalConstraints];
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //Store Hotel's rooms property (NSSet) into a new array and set it to private property.
  self.rooms = [self.hotel.rooms allObjects];
  [self.roomListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RoomCell"];
  self.roomListTableView.delegate = self;
  self.roomListTableView.dataSource = self;
  self.roomListTableView.rowHeight = 100;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

// Return the number of rows for each section in your static table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rooms.count;
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  static NSString *CellIdentifier =@"RoomCell";
//  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
  Room *roomAtIndex = [self.rooms objectAtIndex:indexPath.row];
  
  cell.textLabel.numberOfLines = 0;
  cell.textLabel.text =[NSString stringWithFormat:@"Room number: %@\nNumber of Beds: %@\nRate: %@", roomAtIndex.number, roomAtIndex.beds, roomAtIndex.rate];

  return cell;
}

#pragma mark - UITableViewDelegate

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  [self.roomListTableView deselectRowAtIndexPath:indexPath animated:true];
//  //NSInteger selectedRow = indexPath.row;
//  RoomsViewController *roomsViewController = [[RoomsViewController alloc] init];
//  roomsViewController.hotel = self.rooms[indexPath.row];
//  [self.navigationController pushViewController:roomsViewController animated:true];
//  NSLog(@"Browse Hotel Selected");
//  
//  
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
