//
//  LocationDaoModel.h
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationDaoModel : NSObject

#pragma mark - 记录ID
@property(nonatomic,copy) NSString *recordId;

#pragma mark - 员工id
@property(nonatomic,copy) NSString *staffId;

#pragma mark - 员工姓名
@property(nonatomic,copy) NSString *staffName;

#pragma mark - 经度
@property(nonatomic,copy) NSString *lon;

#pragma mark - 纬度
@property(nonatomic,copy) NSString *lat;

#pragma mark - 地址
@property(nonatomic,copy) NSString *address;

#pragma mark - 定位时间
@property(nonatomic,copy) NSString *locateTime;


@end
