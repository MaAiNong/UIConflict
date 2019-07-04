//
//  QYPlayerViewConflictManager.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictManager.h"
@interface QYPlayerViewConflictManager()

//@property(nonatomic,strong)NSMapTable* conflictCustom;
@property(nonatomic,strong)NSHashTable* conflictTable;

@property(nonatomic,copy)NSDictionary* conflictConfiguration_higher;//包含所有 低优先级注册的高优先级信息
@property(nonatomic,strong)NSDictionary* conflictConfiguration_lower;//包含所有 高优先级对应的低优先级信息，由conflictConfiguration_higher 解析出来

@end

#define CONFLICT_REASON(_PRIORITY_,_TYPE_) [self conflictResonWithPriority:(_PRIORITY_) conflictType:(_TYPE_)]

@implementation QYPlayerViewConflictManager

-(id)init{
    if (self = [super init]) {
        self.conflictTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

//销毁
-(void)destroy{
    if(_conflictTable){
        [_conflictTable removeAllObjects];
        _conflictTable = nil;
    }
    if (_conflictConfiguration_higher) {
        _conflictConfiguration_higher = nil;
    }
    if (_conflictConfiguration_lower) {
        _conflictConfiguration_lower = nil;
    }
}

//注册需要使用的 QYConflictViewConfig
-(void)registConflictConfiguration:(NSDictionary*)configuration{
    if (configuration&&[QYConflictViewConfig isValidConflictConfig:configuration]) {
        
        [self.conflictTable removeAllObjects];
        self.conflictConfiguration_higher = configuration;
        self.conflictConfiguration_lower = [self getLowerRelationshipFromHigher:self.conflictConfiguration_higher];
        
    }else{
#if DEBUG
        NSLog(@"configuration %@ not valid",configuration);
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"--------------------------------------------------------");
        NSAssert(NO, @"not valid configuration");
#endif
    }
}


/**
 是否可展示
 只要与高优先级中的任意一项冲突 就不可展示
 @param view view
 @return YES 可以展示 NO 不可以展示
 */
-(BOOL)canShowView:(UIView<QYPlayerViewConflictProtocol>*)view{
    
    BOOL canShowView = YES;
    if(self.conflictConfiguration_higher.count>0){
        NSArray* higherConflicts = [self.conflictConfiguration_higher objectForKey:@(view.conflict_showPriority)];
        if ([higherConflicts isKindOfClass:[NSArray class]] && higherConflicts.count>0) {
            
            for (NSDictionary* conflict in higherConflicts) {
                QYView_ShowPriority viewPriority = [conflict[KEY_PRIORITY] intValue];
                QYView_ConflictType confictType = [conflict[KEY_CONFLICT] intValue];
                
                NSEnumerator *enumerator = [self.conflictTable objectEnumerator];
                UIView<QYPlayerViewConflictProtocol>* conflictView;
                
                //如果有一个有冲突则不能展示 否则可以展示
                while ((conflictView = [enumerator nextObject])) {
                   
                    if (viewPriority == conflictView.conflict_showPriority&&//符合匹配的高优先级view
                        conflictView != view && //不是同一个View
                        [conflictView conflict_isShowing]//当前正在展示
                        ) {
                        
                        if([self isView:view conflictWithView:conflictView conflictType:confictType]){
                            canShowView = NO;
                            break;
                        }
                    }
                }
            }
        }
    }
    return canShowView;
}

//@[
//@{@(QYViewPriority_RollAD):@(QYViewConflictType_Exclusion)},
//@{@(QYViewPriority_PauseAD):@(QYViewConflictType_Exclusion)},
//]
//检查与特定高优先级view的冲突情况
-(BOOL)canShowView:(UIView<QYPlayerViewConflictProtocol>*)view withConflict:(NSArray*)conflicts{
    
    return YES;
}

//注册VIew
-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view customHigherPriority:(NSSet*)HigherPriorities{
    
    if ([view conformsToProtocol:@protocol(QYPlayerViewConflictProtocol)]) {
        
        if ([HigherPriorities isKindOfClass:[NSSet class]]&& HigherPriorities.count>0) {
            
            
        }
        else{
            
            if (![self.conflictTable containsObject:view]) {
                [self.conflictTable addObject:view];
            }
        }
        return YES;
    }else{
#if DEBUG
        NSLog(@"view %@ not conformsTo QYPlayerViewConflictProtocol",view);
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"--------------------------------------------------------");
        NSAssert(NO, @"not valid view");
#endif
        return NO;
        
    }
}

-(BOOL)registView:(UIView<QYPlayerViewConflictProtocol>*)view{
    
    return  [self registView:view customHigherPriority:nil];
}

-(void)deregistView:(UIView<QYPlayerViewConflictProtocol>*)view{
    
    [self.conflictTable removeObject:view];
    
}

- (void)handleView:(UIView<QYPlayerViewConflictProtocol> *)view show:(BOOL)isShow{
    
    if ([self registView:view]) {//如果没有注册主动给注册一下 顺便做一下检查

        BOOL isValid = ([view conflict_isShowing]==isShow);
        if(!isValid){
#if DEBUG
            NSLog(@"show message not equal %@",@(isShow));
            NSLog(@"%@",[NSThread callStackSymbols]);
            NSAssert(isValid,@"show message not equal",nil);
#endif
            return;
        }
        
        if([view conflict_isShowing]){
            //隐藏优先级低的
            [self hideViewPriorityLowerThan:view];
            
        }else{
            //显示优先级低的
            [self showViewPriorityLowerThan:view];
        }
    }
}

#pragma mark --- handle PriorityLower
//显示优先级低的view
-(void)showViewPriorityLowerThan:(UIView<QYPlayerViewConflictProtocol> *)view{
    
    if (self.conflictTable.count>0 && [self.conflictConfiguration_lower isKindOfClass:[NSDictionary class]]) {
        //遍历出低优先级的View 然后判断他们能不能显示
        NSArray* conflicts = [self.conflictConfiguration_lower objectForKey:@(view.conflict_showPriority)];
        if ([conflicts isKindOfClass:[NSArray class]] && conflicts.count>0) {
            
            for (NSDictionary* conflict in conflicts) {
                QYView_ShowPriority viewPriority = [conflict[KEY_PRIORITY] intValue];
                QYView_ConflictType confictType = [conflict[KEY_CONFLICT] intValue];
                
                NSEnumerator *enumerator = [self.conflictTable objectEnumerator];
                
                UIView<QYPlayerViewConflictProtocol>* conflictView;
                while ((conflictView = [enumerator nextObject])) {
                    //获取低优先级View 并且从整体判断要不要显示
                    if (viewPriority == conflictView.conflict_showPriority &&
                        conflictView != view && //不是同一个View
                        ![conflictView conflict_isShowing] && //当前不在显示
                        [self canShowView:conflictView]) {//可以显示
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
#if DEBUG
                            NSLog(@"%@ 显示view：%@ %@ ",NSStringFromSelector(_cmd),@(conflictView.conflict_showPriority),@(view.conflict_showPriority));
#endif
                            [conflictView conflict_show:CONFLICT_REASON(view.conflict_showPriority, confictType)];
                            [self handleView:conflictView show:YES];
                        });
                    }
                }
            }
            
        }else{
#if DEBUG
            NSLog(@"%@ 没有比这个view优先级低的注册：%@ ",NSStringFromSelector(_cmd),@(view.conflict_showPriority));
#endif
        }
        
    }else{
#if DEBUG
        NSLog(@"%@ 冲突表：%@ or lower：为空:%@",NSStringFromSelector(_cmd),@(self.conflictTable.count),self.conflictConfiguration_lower);
#endif
    }
}

//通知低优先级view隐藏
-(void)hideViewPriorityLowerThan:(UIView<QYPlayerViewConflictProtocol> *)view{
    
    if (self.conflictTable.count>0 && [self.conflictConfiguration_lower isKindOfClass:[NSDictionary class]]) {
        
        NSArray* conflicts = [self.conflictConfiguration_lower objectForKey:@(view.conflict_showPriority)];
        if ([conflicts isKindOfClass:[NSArray class]] && conflicts.count>0) {
            
            for (NSDictionary* conflict in conflicts) {
                QYView_ShowPriority viewPriority = [conflict[KEY_PRIORITY] intValue];
                QYView_ConflictType confictType = [conflict[KEY_CONFLICT] intValue];
                
                NSEnumerator *enumerator = [self.conflictTable objectEnumerator];
                UIView<QYPlayerViewConflictProtocol>* conflictView;
                while ((conflictView = [enumerator nextObject])) {
                    //低优先级 并且 和 当前要显示的view 冲突
                    if (viewPriority == conflictView.conflict_showPriority&&
                        conflictView != view && //不是同一个View
                        [conflictView conflict_isShowing]&&//当前正在展示
                        [self isView:view conflictWithView:conflictView conflictType:confictType]) {

                    
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
#if DEBUG
                            NSLog(@"%@ 隐藏view：%@ %@ ",NSStringFromSelector(_cmd),@(conflictView.conflict_showPriority),@(view.conflict_showPriority));
#endif
                            [conflictView conflict_hide:CONFLICT_REASON(view.conflict_showPriority,confictType)];
                            [self handleView:conflictView show:NO];
                        });
                    }
                }
            }
        
        }else{
#if DEBUG
            NSLog(@"%@ 没有比这个view优先级低的注册：%@ ",NSStringFromSelector(_cmd),@(view.conflict_showPriority));
#endif
        }
        
    }else{
#if DEBUG
        NSLog(@"%@ 冲突表：%@ or lower：为空:%@",NSStringFromSelector(_cmd),@(self.conflictTable.count),self.conflictConfiguration_lower);
#endif
    }
}

-(QYConflictReason*)conflictResonWithPriority:(QYView_ShowPriority)pri conflictType:(QYView_ConflictType)type{
    QYConflictReason* reason = [[QYConflictReason alloc] init];
    
    reason.conflict_showPriority = pri;
    reason.conflict_Type = type;
    reason.conflict_manager = self;
    
    return reason;
}


//从view1 视角看 和view2 的关系
//判断是否冲突，前提是两者有冲突连接
-(BOOL)isView:(UIView<QYPlayerViewConflictProtocol> *)view1 conflictWithView:(UIView<QYPlayerViewConflictProtocol> *)view2 conflictType:(QYView_ConflictType)conflictType{
    
    //同一UI肯定无冲突
    if (view1 == view2) {
        return NO;
    }
    
    BOOL view1Showing = YES;//从view1 视角看 和view2 的关系
    BOOL view2Showing = [view2 conflict_isShowing];
    if (view1Showing==view2Showing){
        if (QYViewConflictType_Exclusion == conflictType) {
        {
#if DEBUG
            NSLog(@"view conflict QYViewConflictType_Exclusion %@ %@",view1,view2);
#endif
            return YES;//同时显示而且是互斥
        }
            
        }else if(QYViewConflictType_Intersection == conflictType){
            CGRect view1rect = [view1 convertRect:view1.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect view2rect = [view1 convertRect:view2.bounds toView:[UIApplication sharedApplication].keyWindow];
            if (CGRectIntersectsRect(view1rect, view2rect)) {
#if DEBUG
                NSLog(@"view conflict QYViewConflictType_Intersection %@ %@",view1,view2);
#endif
                return YES;
            }
        }
    }
#if DEBUG
    NSLog(@"view not conflict %@ %@ %@",view1,view2,@(conflictType));
#endif
    return NO;
}

#pragma mark --- util
//工具方法
-(NSDictionary*)getLowerRelationshipFromHigher:(NSDictionary*)higher{
    if (![higher isKindOfClass:[NSDictionary class]]  || higher.allKeys.count<=0) {
        return @{};
    }
    
    //1 提取出当前higher里面所有的类型////////////////////////////////////////////////////////////
    NSMutableSet* lowerAllkeys = [[NSMutableSet alloc] init];
    if (higher.allKeys.count>0) {
        [lowerAllkeys addObjectsFromArray:higher.allKeys];
    }
    
    for (NSArray* higherRelation in higher.allValues) {
        if ([higherRelation isKindOfClass:[NSArray class]]) {
            for (NSDictionary* conflict in higherRelation) {
                if ([conflict isKindOfClass:[NSDictionary class]]&&[conflict objectForKey:KEY_PRIORITY]) {
                    [lowerAllkeys addObject:[conflict objectForKey:KEY_PRIORITY]];
                }
            }
        }
    }
    
    //2 把所有的 key 按照优先级排序，因为优先级越低，需要遍历的可能性越小 ////////////////////////////////////////////////////////////
    NSArray *sortedArray = [lowerAllkeys.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = obj1;
        NSNumber *number2 = obj2;
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending; //升序
    }];
    
    //3 以所有的类型为key 遍历优先级比较低的关系////////////////////////////////////////////////////////////
    NSMutableDictionary* lower = [[NSMutableDictionary alloc] init];
    
    for (NSNumber* lowerKey in sortedArray) {
        
        NSMutableArray* lowerValue = [[NSMutableArray alloc] init];
        
        [higher enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSArray* higherConflicts = obj;
            if ([higherConflicts isKindOfClass:[NSArray class]]) {
                for (NSDictionary* conflict in higherConflicts) {
                    if ([conflict isKindOfClass:[NSDictionary class]] && conflict[KEY_PRIORITY]) {
                        
                        if ([conflict[KEY_PRIORITY] isEqualToValue:lowerKey]) {
                            NSNumber* conflictType = conflict[KEY_CONFLICT];
                            if (key&&conflictType) {
                                NSDictionary* lowerConflict = @{KEY_PRIORITY:key,
                                                                KEY_CONFLICT:conflictType};
                                [lowerValue addObject:lowerConflict];
                            }
                        }
                    }
                }
            }
            
        }];
        
        [lower setObject:lowerValue forKey:lowerKey];
    }
    
    return lower;
    
}


@end
