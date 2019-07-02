//
//  QYPlayerViewConflictManager.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYPlayerViewConflictDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYPlayerViewConflictManager : NSObject

-(id)init;


/**
 是否可展示

 @param view
 @return YES 可以展示 NO 不可以展示
 */
-(BOOL)canShowView:(UIView<QYPlayerViewConflictProtocol>*)view;


/**
  不走  QYShowPriority.plist 里的优先级
  不走  QYShowPriority.plist 里的优先级
  不走  QYShowPriority.plist 里的优先级
 
  根据view实例 定制HigherPriorities 注册需要处理优先级的view

 @param view 符合QYPlayerViewConflictProtocol 的view
 @param HigherPriorities 比注册view 优先级更高的view 里面的内容
 @return YES 注册成功; NO 注册失败-不符合QYPlayerViewConflictProtocol
 */
//-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view customHigherPriority:(NSSet*)HigherPriorities;


/**
 注册需要处理优先级的view 完全走 QYShowPriority.plist 里的优先级
 注册需要处理优先级的view 完全走 QYShowPriority.plist 里的优先级
 注册需要处理优先级的view 完全走 QYShowPriority.plist 里的优先级
 
 @param view 符合QYPlayerViewConflictProtocol 的view
 @return YES 注册成功; NO 注册失败-不符合QYPlayerViewConflictProtocol
 */
-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view;


/**
 取消注册

 @param view 需要删除处理的view
 */
-(void)deregistView:(UIView<QYPlayerViewConflictProtocol>*)view;


/**
 
 view 显示隐藏发生变化
 
 在这个方法里面会去取 conflict_isShowing
     * YES 此view正显示 隐藏互斥优先级低的互斥view
     * NO  此view正隐藏 可以允许低优先级的互斥view显示
 
 其他情况 如 frame调整
 */
-(void)handleViewAffectConflict:(UIView<QYPlayerViewConflictProtocol>*)view;

@end

NS_ASSUME_NONNULL_END
