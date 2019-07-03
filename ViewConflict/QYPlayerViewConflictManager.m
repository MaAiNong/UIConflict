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

@implementation QYPlayerViewConflictManager

-(id)init{
    if (self = [super init]) {
//      self.conflictCustom = [NSMapTable weakToStrongObjectsMapTable];
        self.conflictTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
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
 
    return YES;
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
    
#if DEBUG
    BOOL isValid = ([view conflict_isShowing]==isShow);
    if(!isValid){
        NSLog(@"show message not equal %@",@(isShow));
        NSLog(@"%@",[NSThread callStackSymbols]);
    }
    NSAssert(isValid,@"show message not equal",nil);
    
#endif
    
    if ([view conformsToProtocol:@protocol(QYPlayerViewConflictProtocol)]) {

        if([view conflict_isShowing]){
            //隐藏优先级低的
            [self hideViewPriorityLowerThan:view];
            
        }else{
            //显示优先级低的
        }
    }
    
}

-(void)hideViewPriorityLowerThan:(UIView<QYPlayerViewConflictProtocol> *)view{
    
    if (self.conflictTable.count>0) {
        NSEnumerator *enumerator = [self.conflictTable objectEnumerator];
        id value;
        
        while ((value = [enumerator nextObject])) {
            /* code that acts on the hash table's values */
        }
    }
}

-(void)showViewPriorityLowerThan:(UIView<QYPlayerViewConflictProtocol> *)view{
    
}


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
                if ([conflict isKindOfClass:[NSDictionary class]] && conflict.allKeys.count>0) {
                    [lowerAllkeys addObjectsFromArray:conflict.allKeys];
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
                    if ([conflict.allKeys containsObject:lowerKey]) {
                        NSNumber* conflictType = conflict[lowerKey];
                        if (key&&conflictType) {
                            NSDictionary* lowerConflict = @{key:conflictType};
                            [lowerValue addObject:lowerConflict];
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
