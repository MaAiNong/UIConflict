//
//  QYPlayerViewConflictManager.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictManager.h"
@interface QYPlayerViewConflictManager()

@property(nonatomic,strong)NSMapTable* conflictCustom;
@property(nonatomic,strong)NSHashTable* conflictTable;

@end

@implementation QYPlayerViewConflictManager

-(id)init{
    if (self = [super init]) {
        self.conflictCustom = [NSMapTable weakToStrongObjectsMapTable];
        self.conflictTable = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

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

-(void)handleViewAffectConflict:(UIView<QYPlayerViewConflictProtocol>*)view{
    
    if([view conflict_isShowing]){
        //隐藏优先级低的
        
        
    }else{
        //显示优先级低的
    }
    
}


@end
