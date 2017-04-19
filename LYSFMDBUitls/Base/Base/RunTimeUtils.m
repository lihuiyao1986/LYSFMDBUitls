//
//  RunTimeUtils.m
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "RunTimeUtils.h"
#import <objc/runtime.h>

@implementation RunTimeUtils

#pragma mark - 获取某个类所有的属性
+(NSArray*)objPropNames:(Class)clz{
    
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(clz, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

#pragma mark - 属性和数据库列对应的字典
+(NSDictionary*)objPropColumnNames:(Class)clazz{
    
    ///存储所有的属性名称
    NSMutableDictionary *allNames = [NSMutableDictionary dictionary];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(clazz, &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString *propName = [NSString stringWithUTF8String:propertyName];
        NSString *columnName = [propName lowercaseString];
        [allNames setObject:propName forKey:columnName];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

#pragma mark - 对象转字典
+(NSDictionary*)objToDict:(id)obj{
    
    ///存储所有的属性名称
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([obj class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        NSString *propName = [NSString stringWithUTF8String:propertyName];
        id propValue = [obj valueForKey:propName];
        if (propValue) {
            [result setObject:propValue forKey:propName];
        }
    }
    
    ///释放
    free(propertys);
    
    return result;

}

@end
