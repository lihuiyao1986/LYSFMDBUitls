//
//  LocationDao.h
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "LocationDaoModel.h"

@interface LocationDao : NSObject

+ (instancetype)sharedInstance;

#pragma mark - 保存定位信息
-(BOOL)saveLocation:(LocationDaoModel*)location;

#pragma mark - 根据员工ID查询员工的定位信息
-(NSArray*)queryByStaffId:(NSString*)staffId;

#pragma mark - 根据记录ID删除
-(BOOL)deleteByRecordId:(NSString*)recordId;

#pragma mark - 根据记录IDS批量删除
-(BOOL)deleteByRecordIDs:(NSArray*)recordIds;
@end
