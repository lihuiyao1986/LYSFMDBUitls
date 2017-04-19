//
//  DaoUtils.h
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "DBManager.h"


@interface DaoUtils : NSObject

SingletonH(Instance)

@property(nonatomic,assign)BOOL showSql;

#pragma mark - 创建表的sql
-(NSString*)createTableSql:(Class)clazz;

#pragma mark - 删除表的sql
-(NSString*)dropTableSql:(Class)clazz;

#pragma mark - 判断表是否存在的sql
-(NSString*)tableExistSql:(Class)clazz;

#pragma mark - 删除的sql
-(NSString *)delSql:(Class)clazz whereSql:(NSString*)whereSql;

#pragma mark - 查询的sql
-(NSString*)querySql:(Class)clazz whereSql:(NSString*)whereSql;

#pragma mark - 更新语句
-(NSString*)updateSql:(id)obj whereSql:(NSString*)whereSql;

#pragma mark - 保存语句
-(NSString*)saveSql:(id)obj;

#pragma mark - 更新表列的sql
-(NSString*)updateTableColumnSql:(Class)clazz columns:(NSArray*)columns;

#pragma mark - 查询
-(NSArray*)queryList:(Class)clazz whereStr:(NSString*)whereStr params:(NSDictionary*)params itemPackBlock:(NSArray* (^)(FMResultSet *rowSet,NSDictionary * columnNames))itemPackBlock;

#pragma mark - 更新
-(BOOL)update:(NSString*)sql params:(NSDictionary*)params;

#pragma mark - 删除表
-(BOOL)dropTable:(Class)clazz;

#pragma mark - 删除
-(BOOL)deleteRecord:(Class)clazz whereStr:(NSString*)whereStr params:(NSDictionary*)params;

#pragma mark - 保存
-(BOOL)save:(id)item;

#pragma mark - 修改
-(BOOL)modify:(id)obj whereStr:(NSString*)whereStr params:(NSDictionary*)params;

#pragma mark - 创建表
-(BOOL)createTable:(Class)clazz;

#pragma mark - 判断表是否存在
-(BOOL)isTableExist:(Class)clazz;

#pragma mark - 更新表
-(void)checkTableUpdate:(Class)clazz;

#pragma mark - 格式化列值
-(NSString*)formatColumnValue:(NSString*)columnValue;

@end
