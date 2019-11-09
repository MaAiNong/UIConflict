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

//唯一初始化方法
-(id)init;

//注册需要使用的 QYConflictViewConfig
-(void)registConflictConfiguration:(NSDictionary*)configuration;

//单纯注册
-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view;
-(void)registViews:(NSArray<UIView<QYPlayerViewConflictProtocol>* >*)views;

/**
 注册需要处理优先级的view 完全走 QYConflictViewConfig 里的优先级配置字典
 
 除了注册外，
 
 @param view 符合QYPlayerViewConflictProtocol 的view
 @return YES 注册成功; NO 注册失败-不符合QYPlayerViewConflictProtocol
 */
-(BOOL)registAndCheckView:(UIView<QYPlayerViewConflictProtocol>*)view;
-(void)registAndCheckViews:(NSArray<UIView<QYPlayerViewConflictProtocol>* >*)views;


/**
 取消注册,会更新其他view的显示隐藏状态
 @param view 需要删除处理的view
 */
-(void)deregistView:(UIView<QYPlayerViewConflictProtocol>*)view;
-(void)deregistViews:(NSArray<UIView<QYPlayerViewConflictProtocol>* >*)views;

/**
 所有view 全部取消注册
 */
-(void)deregistAllViews;


/**
 是否可展示
 只要与高优先级中的任意一项冲突 就不可展示
 @param view  view
 @return YES 可以展示 NO 不可以展示
 */
-(BOOL)canShowView:(UIView<QYPlayerViewConflictProtocol>*)view;

/**
 
 view 显示隐藏发生变化，通过 [view conflict_isShowing] 来获取当前状态，并通知其他view更新状态，
 如果需要释放view，可以调用 deregistView:，此时不需要再 调用此方法
 
 使用前请务必注册 务必保证 conflict_isShowing 准确性
 使用前请务必注册 务必保证 conflict_isShowing 准确性
 使用前请务必注册 务必保证 conflict_isShowing 准确性
*/
-(void)notifyOtherViewsShowStatusChanged:(UIView<QYPlayerViewConflictProtocol>*)view;


/// 作用同上
/// @param view view
/// @param isShow 对view 当前展示状态的预期，如果预期与 view QYViewConflictAction_ShowState 不符合 将不执行任何操作，如符合同上述方法
-(void)notifyOtherViewsShowStatusChanged:(UIView<QYPlayerViewConflictProtocol>*)view showExpected:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
