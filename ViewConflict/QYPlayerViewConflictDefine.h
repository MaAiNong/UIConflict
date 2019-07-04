//
//  QYPlayerViewConflictDefine.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QYPlayerViewConflictConstants.h"
NS_ASSUME_NONNULL_BEGIN

@class QYConflictReason;
@class QYPlayerViewConflictManager;
@protocol  QYPlayerViewConflictDelegate <NSObject>


@end

////////////////////////////////////////////////////////////////////////////////////

@protocol  QYPlayerViewConflictProtocol <NSObject>

@required

@property(nonatomic,assign)QYView_ShowPriority conflict_showPriority;

//是否正在展示
-(BOOL)conflict_isShowing;

//隐藏
-(void)conflict_hide:(QYConflictReason*)hideReason;

//显示
-(void)conflict_show:(QYConflictReason*)hideReason;

@end

////////////////////////////////////////////////////////////////////////////////////
@interface QYConflictReason : NSObject

@property(nonatomic,assign)QYView_ShowPriority conflict_showPriority;//导致隐藏的view类型
@property(nonatomic,assign)QYView_ConflictType conflict_Type;//导致隐藏的冲突类型
@property(nonatomic,weak)QYPlayerViewConflictManager* conflict_manager;//manager

@end

////////////////////////////////////////////////////////////////////////////////////

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
