//
//  ReservationRoomPickerViewController.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/10/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "ReservationRoomPickerViewController.h"
#import "MakeReservationViewController.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "Room.h"
#import "Reservation.h"


//Implement room filtering system based on availability.
@interface ReservationRoomPickerViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
  @property (strong, nonatomic) NSArray *rooms;
  @property (strong, nonatomic) NSArray *hotels;
  @property (nonatomic, strong) UITableView *roomListTableView;
  @property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ReservationRoomPickerViewController

- (void)loadView {
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  
  self.roomListTableView = [[UITableView alloc] initWithFrame:rootView.frame style:UITableViewStyleGrouped];
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
  self.roomListTableView.delegate = self;
  self.roomListTableView.dataSource = self;
  [self.roomListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RoomCell"];
  NSError *error;
  if (![[self fetchedResultsController] performFetch:&error]) {
    // Update to handle the error appropriately.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    exit(-1);  // Fail
  }
  self.title = @"Rooms Available for Booking";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
//  AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
//  NSManagedObjectContext* context = appDelegate.managedObjectContext;
//  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:context];
//  [fetchRequest setEntity:entity];
//  
//  NSSortDescriptor *sortRoomsByHotel = [[NSSortDescriptor alloc] initWithKey:@"hotel.name" ascending:NO];
//  NSSortDescriptor *sortRoomsByNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
//  
//  fetchRequest.sortDescriptors = @[sortRoomsByHotel, sortRoomsByNumber];
//  
//  
//  NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"hotel.name" cacheName:nil];
//  self.fetchedResultsController = theFetchedResultsController;
//  self.fetchedResultsController.delegate = self;
//  
//  return self.fetchedResultsController;
//  
//  
  
  //Find reservations within that date range.
  //If reservations are found within that date range, get the room(s)
  //Store the rooms into an unavailable array
  //Set up another fetch
  
  AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
  NSManagedObjectContext* context = appDelegate.managedObjectContext;
  
  //Fetches reservations made for those dates.
  NSFetchRequest *fetchReservationsRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reservation" inManagedObjectContext:context];
  [fetchReservationsRequest setEntity:entity];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@",self.endDate,self.startDate];
  fetchReservationsRequest.predicate = predicate;
  NSError *fetchError;
  NSArray *results = [context executeFetchRequest:fetchReservationsRequest error:&fetchError];
  
  //Stores all the rooms in an array with reservations made in those date Ranges
  NSMutableArray *unavailableRooms = [[NSMutableArray alloc] init];
  for (Reservation *reservation in results) {
    [unavailableRooms addObject:reservation.room];
  }
  
  //Fetches for all rooms that are not in the room.
  NSFetchRequest *finalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
  NSPredicate *finalPredicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
  finalRequest.predicate = finalPredicate;
  NSError *finalError;
  
  if (finalError) {
    return nil;
  }
  
  NSSortDescriptor *sortRoomsByHotel = [[NSSortDescriptor alloc] initWithKey:@"hotel.name" ascending:NO];
  NSSortDescriptor *sortRoomsByNumber = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
  
  finalRequest.sortDescriptors = @[sortRoomsByHotel, sortRoomsByNumber];
  
  NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:finalRequest managedObjectContext:context sectionNameKeyPath:@"hotel.name" cacheName:nil];
  self.fetchedResultsController = theFetchedResultsController;
  self.fetchedResultsController.delegate = self;
  
  return self.fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSLog(@"%lu", (unsigned long)self.fetchedResultsController.sections.count);
  return self.fetchedResultsController.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%@", room.number];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of Beds: %@, Rate: $%@", room.beds, room.rate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
  // Set up the cell with room information.
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.roomListTableView deselectRowAtIndexPath:indexPath animated:true];
  //NSInteger selectedRow = indexPath.row;
  MakeReservationViewController *makeReservationViewController = [[MakeReservationViewController alloc] init];
  makeReservationViewController.selectedRoom = [self.fetchedResultsController objectAtIndexPath:indexPath];
  makeReservationViewController.startDate = self.startDate;
  makeReservationViewController.endDate = self.endDate;
  [self.navigationController pushViewController:makeReservationViewController animated:true];
  NSLog(@"Entered Make Reservation VC.");
}

#pragma mark - NSFetchedResultsController Delegate Boiler Plate Code from Apple
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
  [self.roomListTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  UITableView *tableView = self.roomListTableView;
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.roomListTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.roomListTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self.roomListTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
  [self.roomListTableView endUpdates];
}
@end
