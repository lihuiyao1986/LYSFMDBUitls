//
//  LocationDao.m
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "LocationDao.h"
#import "DBManager.h"
#import "DaoUtils.h"

static LocationDao *_instance;

@implementation LocationDao

#pragma mark - 保存定位信息
-(BOOL)saveLocation:(LocationDaoModel *)location{
    if (!location) {return NO;}
    location.recordId = [self formatDate:[NSDate new] format:@"yyyyMMddHHmmssSSS"];// 添加唯一记录
    location.locateTime = location.locateTime.length  == 0 ?  [self formatDate:[NSDate new] format:@"yyyyMMddHHmmss"]:  location.locateTime;
    return [[DaoUtils sharedInstance]save:location];
}

#pragma mark - 根据员工ID查询员工的定位信息
-(NSArray*)queryByStaffId:(NSString*)staffId{
    return [[DaoUtils sharedInstance]queryList:[LocationDaoModel class] whereStr:[NSString stringWithFormat:@" where staffid = %@ ",[[DaoUtils sharedInstance] formatColumnValue:staffId]] params:nil itemPackBlock:nil];
}

#pragma mark - 根据记录ID删除
-(BOOL)deleteByRecordId:(NSString *)recordId{
    if (recordId.length <= 0) {return NO;}
    return [[DaoUtils sharedInstance]deleteRecord:[LocationDaoModel class] whereStr:[NSString stringWithFormat:@" where recordid = %@ ",[[DaoUtils sharedInstance] formatColumnValue:recordId]] params:nil];
}

#pragma mark - 根据记录IDS批量删除
-(BOOL)deleteByRecordIDs:(NSArray*)recordIds{
    if (recordIds.count <= 0) {
        return NO;
    }
    NSMutableString *whereSql = [NSMutableString stringWithFormat:@" where recordid in ("];
    [recordIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [whereSql appendFormat:@"%@,",[[DaoUtils sharedInstance] formatColumnValue:obj]];
    }];
    if ([whereSql hasSuffix:@","]) {
        whereSql = [NSMutableString stringWithFormat:@"%@",[whereSql substringToIndex:whereSql.length - 1]];
    }
    [whereSql appendString:@")"];
    return [[DaoUtils sharedInstance]deleteRecord:[LocationDaoModel class] whereStr:whereSql params:nil];
}

#pragma mark - 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[DaoUtils sharedInstance]checkTableUpdate:[LocationDaoModel class]];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

#pragma mark - 格式化日期
-(NSString*)formatDate:(NSDate*)date format:(NSString*)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

@end
