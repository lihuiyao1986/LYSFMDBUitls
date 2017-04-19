//
//  DBManager.m
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "DBManager.h"

@interface DBManager ()

@property(nonatomic,copy,readonly)NSString * dbPath;

@end

@implementation DBManager

SingletonM(Instance)

-(FMDatabaseQueue*)db{
    if (!_db) {
        _db = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    }
    return _db;
}

#pragma mark - 数据库文件地址
-(NSString*)dbPath{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"db.sqlite"];
}

#pragma mark - 文档路径
-(NSString*)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

@end
