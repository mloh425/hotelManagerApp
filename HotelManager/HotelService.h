//
//  HotelService.h
//  HotelManager
//
//  Created by Sau Chung Loh on 9/9/15.
//  Copyright (c) 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HotelService : NSObject

+ (NSArray *)availableRoomsForStartDate:(NSDate *)startDate endDate:(NSDate *)endate;

@end
