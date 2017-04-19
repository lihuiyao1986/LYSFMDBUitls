//
//  DaoUtils.m
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "DaoUtils.h"
#import "RunTimeUtils.h"

@implementation DaoUtils

SingletonM(Instance)

#pragma mark - 创建表的sql
-(NSString*)createTableSql:(Class)clazz{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement,",NSStringFromClass(clazz)];
    NSArray *propNameList = [RunTimeUtils objPropNames:clazz];
    [propNameList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != propNameList.count - 1) {
            [sql appendFormat:@" %@ text,",[obj lowercaseString]];
        }else{
            [sql appendFormat:@" %@ text",[obj lowercaseString]];
        }
    }];
    [sql appendFormat:@")"];
    return sql;
}

#pragma mark - 删除表的sql
-(NSString*)dropTableSql:(Class)clazz{
    return [NSString stringWithFormat:@"drop table if exists %@",NSStringFromClass(clazz)];
}

#pragma mark - 判断表是否存在的sql
-(NSString*)tableExistSql:(Class)clazz{
    return [NSString stringWithFormat:@"SELECT COUNT(*) as count FROM sqlite_master where type='table' and name='%@'",NSStringFromClass(clazz)];
}

#pragma mark - 删除的sql
-(NSString *)delSql:(Class)clazz whereSql:(NSString*)whereSql{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"delete from %@ ",NSStringFromClass(clazz)];
    if (whereSql.length > 0) {
        [sql appendString:whereSql];
    }
    return sql;
}

#pragma mark - 查询的sql
-(NSString*)querySql:(Class)clazz whereSql:(NSString*)whereSql{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select "];
    NSArray *propNameList = [RunTimeUtils objPropNames:clazz];
    [propNameList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != propNameList.count - 1) {
            [sql appendFormat:@" %@ ,",[obj lowercaseString]];
        }else{
            [sql appendFormat:@" %@ ",[obj lowercaseString]];
        }
    }];
    [sql appendFormat:@" from %@ ",NSStringFromClass(clazz)];
    if (whereSql.length > 0) {
        [sql appendString:whereSql];
    }
    return sql;
}

#pragma mark - 更新语句
-(NSString*)updateSql:(id)obj whereSql:(NSString*)whereSql{
    NSMutableString *tempSql = [NSMutableString stringWithFormat:@"update %@ set",NSStringFromClass([obj class])];
    NSArray *propNameList = [RunTimeUtils objPropNames:[obj class]];
    [propNameList enumerateObjectsUsingBlock:^(id  _Nonnull propName, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [obj valueForKey:propName];
        if (value.length > 0) {
            [tempSql appendFormat:@" %@ = : %@ ,",[obj lowercaseString],[obj lowercaseString]];
        }
    }];
    NSMutableString *sql = [NSMutableString string];
    if ([tempSql hasSuffix:@","]) {
        [sql appendString:[tempSql substringToIndex:tempSql.length - 1]];
    }else{
        [sql appendString:tempSql];
    }
    if (whereSql.length > 0) {
        [sql appendString:whereSql];
    }
    return sql;
}

#pragma mark - 保存语句
-(NSString*)saveSql:(id)obj{
    NSMutableString *tempSql = [NSMutableString stringWithFormat:@"insert into %@ ",NSStringFromClass([obj class])];
    NSMutableString *tempFieldNameSql = [NSMutableString stringWithFormat:@"("];
    NSMutableString *tempFieldValueSql = [NSMutableString stringWithFormat:@"values("];
    NSArray *propNameList = [RunTimeUtils objPropNames:[obj class]];
    [propNameList enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [obj valueForKey:key];
        if (value.length > 0) {
            [tempFieldNameSql appendFormat:@"%@",key];
            [tempFieldValueSql appendFormat:@":%@",key];
            [tempFieldNameSql appendString:@","];
            [tempFieldValueSql appendString:@","];
        }
    }];
    NSMutableString *fieldNameSql = [NSMutableString string];
    NSMutableString *fieldValueSql = [NSMutableString string];
    if ([tempFieldNameSql hasSuffix:@","]) {
        [fieldNameSql appendFormat:@"%@", [tempFieldNameSql substringToIndex:tempFieldNameSql.length - 1]];
    }
    if ([tempFieldValueSql hasSuffix:@","]) {
        [fieldValueSql appendFormat:@"%@", [tempFieldValueSql substringToIndex:tempFieldValueSql.length - 1]];
    }
    [fieldNameSql appendString:@")"];
    [fieldValueSql appendString:@")"];
    [tempSql appendFormat:@"%@%@",fieldNameSql,fieldValueSql];
    return tempSql;
}

#pragma mark - 查询表字段
-(NSString*)tableColumnsSql:(Class)clazz{
    return [NSString stringWithFormat:@"PRAGMA table_info(%@)",NSStringFromClass(clazz)];
}

#pragma mark - 更新表列的sql
-(NSString*)updateTableColumnSql:(Class)clazz columns:(NSArray*)columns{
    NSMutableString *sql = [NSMutableString string];
    [columns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [sql appendFormat:@"ALTER TABLE %@ ADD COLUMN %@ text;",NSStringFromClass(clazz),obj];
    }];
    return sql;
}

#pragma mark - 查询
-(NSArray*)queryList:(Class)clazz whereStr:(NSString*)whereStr params:(NSDictionary*)params itemPackBlock:(NSArray* (^)(FMResultSet *rowSet,NSDictionary * columnNames))itemPackBlock{
    NSMutableArray * result = [NSMutableArray array];
    NSDictionary * columnPropMap = [RunTimeUtils objPropColumnNames:clazz];
    __weak typeof (self)MyWeakSelf = self;
    [[DBManager sharedInstance].db inDatabase:^(FMDatabase *db) {
        NSString *sql = [self querySql:clazz whereSql:whereStr];
        if (MyWeakSelf.showSql) {
            NSLog(@"执行的sql为: %@",sql);
        }
        FMResultSet *rowSet = [db executeQuery:sql withParameterDictionary:params];
        if (itemPackBlock) {
            [result addObjectsFromArray:itemPackBlock(rowSet,rowSet.columnNameToIndexMap)];
        }else{
            while ([rowSet next]) {
                id itemObj = [clazz new];
                [rowSet.columnNameToIndexMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *propValue = [rowSet stringForColumn:key];
                    NSString *propName = [columnPropMap objectForKey:key];
                    if (propName.length > 0) {
                        [itemObj setValue:propValue forKey:propName];
                    }
                }];
                [result addObject:itemObj];
            }
        }
        [rowSet close];
    }];
    return [result copy];
}

#pragma mark - 更新
-(BOOL)update:(NSString*)sql params:(NSDictionary*)params{
    __block BOOL result = NO;
    if (self.showSql) {
        NSLog(@"执行的sql为: %@",sql);
    }
    [[DBManager sharedInstance].db inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql withParameterDictionary:params];
    }];
    return result;
}

#pragma mark - 删除表
-(BOOL)dropTable:(Class)clazz{
    return [self update:[self dropTableSql:clazz] params:nil];
}

#pragma mark - 删除
-(BOOL)deleteRecord:(Class)clazz whereStr:(NSString*)whereStr params:(NSDictionary*)params{
    return [self update:[self delSql:clazz whereSql:whereStr] params:params];
}

#pragma mark - 保存
-(BOOL)save:(id)item{
    return [self update:[self saveSql:item] params:[RunTimeUtils objToDict:item]];
}

#pragma mark - 修改
-(BOOL)modify:(id)obj whereStr:(NSString*)whereStr params:(NSDictionary*)params{
    return [self update:[self updateSql:obj whereSql:whereStr] params:params];
}

#pragma mark - 创建表
-(BOOL)createTable:(Class)clazz{
    return [self update:[self createTableSql:clazz] params:nil];
}

#pragma mark - 判断表是否存在
-(BOOL)isTableExist:(Class)clazz{
    __block BOOL result = NO;
    __weak typeof (self)MyWeakSelf = self;
    [[DBManager sharedInstance].db inDatabase:^(FMDatabase *db) {
        NSString *sql = [self tableExistSql:clazz];
        if (MyWeakSelf.showSql) {
            NSLog(@"执行的sql为: %@",sql);
        }
        FMResultSet *rowSet = [db executeQuery:sql];
        if([rowSet next]) {
           result = [rowSet intForColumn:@"count"] > 0;
        }
        [rowSet close];
    }];
    return result;
}

#pragma mark - 更新表
-(void)checkTableUpdate:(Class)clazz{
    if ([self isTableExist:clazz]) {
        NSArray * diffColumns = [self diffColumn:clazz];
        if (diffColumns.count > 0) {
            [self update:[self updateTableColumnSql:clazz columns:[self diffColumn:clazz]] params:nil];
        }
    }else{
        [self createTable:clazz];
    }
}

#pragma mark - 获取差异化的列
-(NSArray*)diffColumn:(Class)clazz{
    NSMutableArray * result = [NSMutableArray array];
    NSArray *currentColumns = [[self tableColumns:clazz] allKeys];
    NSArray *propNames = [RunTimeUtils objPropNames:clazz];
    [propNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![currentColumns containsObject:[obj lowercaseString]]) {
            [result addObject:[obj lowercaseString]];
        }
    }];
    return result;
}

#pragma mark - 获取表对应的列
-(NSDictionary*)tableColumns:(Class)clazz{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    __weak typeof (self)MyWeakSelf = self;
    [[DBManager sharedInstance].db inDatabase:^(FMDatabase *db) {
        NSString * sql = [self tableColumnsSql:clazz];
        if (MyWeakSelf.showSql) {
            NSLog(@"执行的sql为: %@",sql);
        }
        FMResultSet *rowset = [db executeQuery:sql];
        while ([rowset next]) {
            [result setObject:[rowset stringForColumn:@"type"] forKey:[rowset stringForColumn:@"name"]];
        }
        [rowset close];
    }];
    return result;
}


#pragma mark - 格式化列值
-(NSString*)formatColumnValue:(NSString*)columnValue{
    columnValue = columnValue.length == 0 ? @"" : columnValue;
    return [NSString stringWithFormat:@"'%@'",columnValue];
}

@end
