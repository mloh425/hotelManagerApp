//
//  MakeReservationViewController.h
//  HotelManager
//
//  Created by Sau Chung Loh on 9/11/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface MakeReservationViewController : UIViewController

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) Room *selectedRoom;

@end
