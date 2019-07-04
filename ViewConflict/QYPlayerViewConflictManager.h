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

//销毁
-(void)destroy;

//注册需要使用的 QYConflictViewConfig
-(void)registConflictConfiguration:(NSDictionary*)configuration;

/**
 是否可展示
 只要与高优先级中的任意一项冲突 就不可展示
 @param view  view 
 @return YES 可以展示 NO 不可以展示
 */
-(BOOL)canShowView:(UIView<QYPlayerViewConflictProtocol>*)view;

/**
 注册需要处理优先级的view 完全走 QYConflictViewConfig 里的优先级配置字典
 
 @param view 符合QYPlayerViewConflictProtocol 的view
 @return YES 注册成功; NO 注册失败-不符合QYPlayerViewConflictProtocol
 */
-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view;


-(void)registViews:(NSArray<QYPlayerViewConflictProtocol>*)views;


/**
 取消注册

 @param view 需要删除处理的view
 */
-(void)deregistView:(UIView<QYPlayerViewConflictProtocol>*)view;


/**
 view 显示隐藏发生变化
 * 内部 会以 [view conflict_isShowing] 为准，如果和isShow不一致，会直接return
 * 内部 会以 [view conflict_isShowing] 为准，如果和isShow不一致，会直接return
 * 内部 会以 [view conflict_isShowing] 为准，如果和isShow不一致，会直接return
 
 @param view 显隐发生变化的View
 @param isShow 这个值仅仅
    * YES 此view正显示 隐藏互斥优先级低的互斥view
    * NO  此view正隐藏 可以允许低优先级的互斥view显示
*/
-(void)handleView:(UIView<QYPlayerViewConflictProtocol>*)view show:(BOOL)isShow;


-(void)updateShowHideStatusForView:(UIView<QYPlayerViewConflictProtocol> *)view;

-(void)updateShowHideStatusForArray:(NSArray<QYPlayerViewConflictProtocol> *)views;

@end

NS_ASSUME_NONNULL_END
