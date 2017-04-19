//
//  DBManager.h
//  GisHelper
//
//  Created by jk on 2017/4/17.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "FMDB.h"

@interface DBManager : NSObject

SingletonH(Instance)

@property(nonatomic,strong)FMDatabaseQueue *db;

@end
