//
//  RunTimeUtils.h
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunTimeUtils : NSObject

#pragma mark - 获取某个类所有的属性
+(NSArray*)objPropNames:(Class)clz;

#pragma mark - 属性和数据库列对应的字典
+(NSDictionary*)objPropColumnNames:(Class)clazz;

#pragma mark - 对象转字典
+(NSDictionary*)objToDict:(id)obj;

@end
