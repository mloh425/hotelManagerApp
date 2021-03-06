//
//  AppDelegate.m
//  HotelManager
//
//  Created by Sau Chung Loh on 9/7/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import "AppDelegate.h"
#import "HotelListViewController.h"
#import "DatePickerViewController.h"
#import "MenuViewController.h"
#import "Hotel.h"
#import "Room.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  NSDate *now = [NSDate date]; //Gets current date and time
  NSDate *later = [NSDate dateWithTimeIntervalSinceNow:30]; //Time 30 seconds from moment this is fired
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
  NSLog(@"Year is: %ld", (long)components.year);
  NSDateComponents *newComponents = [[NSDateComponents alloc] init];
  newComponents.year = 1990;
  newComponents.day = 25;
  newComponents.month = 12;
  
  NSDate *xmasIn1990 = [calendar dateFromComponents:newComponents];
  NSLog(@"%@",xmasIn1990);
  // Override point for customization after application launch.
  //Creating a new object / entity
  //Already created once, for now do not put it here as it will create another one.

  
  //  NSError *fetchError;
  //
  //  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  //  NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  //  NSLog(@"%lu", (unsigned long) results.count);
  //Query in coreData
  [self seedCoreDataIfNeeded];
  //Creates a window based on device's screen size
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [self.window makeKeyAndVisible];
  
  MenuViewController *menuViewController = [[MenuViewController alloc] init];
  
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
 // HotelListViewController *hotelListViewController = [[HotelListViewController alloc] init]; //Root VC setup
 // DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] init];
 // dummyRoot.view.backgroundColor = [UIColor whiteColor];
  
  //This method will go to LoadView and view did load first!
  self.window.rootViewController = navigationController;
  //  self.window.rootViewController = datePickerViewController;
  
  
  return YES;
}

- (void) seedCoreDataIfNeeded {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *fetchError;
  NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&fetchError];
  if (count == 0) {
    //    seed database, load JSON locally
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"hotels" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError *jsonError;
    NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    if (jsonError) {
      return;
    } else {
      NSArray *hotelArray = rootObject[@"Hotels"];
      for (NSDictionary *hotel in hotelArray) {
        NSString *name = hotel[@"name"];
        NSString *location = hotel[@"Downtown"];
        NSNumber *stars = hotel[@"stars"];
        NSArray *rooms = hotel[@"rooms"];
        Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
        hotel.name = name;
        hotel.location = location;
        hotel.stars = stars;
        for (NSDictionary *room in rooms) {
          NSNumber *roomNumber = room[@"number"];
          NSNumber *beds = room[@"beds"];
          NSNumber *rate = room[@"rate"];
          Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.managedObjectContext];
          room.number = roomNumber;
          room.beds = beds;
          room.rate = rate;
          room.hotel = hotel;
        }
      }
      NSError *saveError;
      BOOL result = [self.managedObjectContext save:&saveError];
      if (!result) {
        NSLog(@" %@",saveError.localizedDescription);
      }
    }
  }
}

+ (AppDelegate *)sharedAppDelegate
{
  return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "CF.HotelManager" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotelManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotelManager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
