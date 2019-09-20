//
//  QYConflictViewConfig.h
//  ViewConflict
//
//  Created by xukaitian on 2019/9/20.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYConflictViewConfig : NSObject

+(QYConflictViewConfig*)sharedInstance;

//字典的键 为 NSNumber类型，QYView_ShowPriority，低优先级UI类型
//字典的值 为 数组，数组内容为 高优先级UI类型 以及 冲突方式 QYPlayerConflictType
-(NSDictionary*)mainPlayerConflict;


/**
 检验是否配置是否符合基本标准

 表中不能出现环形依赖，否则会形成检查死锁
 必须严格遵守，key 的优先级 < value优先级
 
 @param conflicts 配置表
 @return YES 符合 NO 不符合
 */
+(BOOL)isValidConflictConfig:(NSDictionary*)conflicts;

@end

NS_ASSUME_NONNULL_END
