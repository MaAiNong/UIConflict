//
//  QYPlayerViewConflictDefine.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictDefine.h"
static QYConflictViewConfig* _sharedConfiguration;
@implementation QYConflictViewConfig
{
    NSDictionary* _mainPlayerConflictConfiguration;
}

+(QYConflictViewConfig*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfiguration = [[QYConflictViewConfig alloc] init];
    });
    return _sharedConfiguration;
}

-(NSDictionary*)mainPlayerConflict{
    
    if (_mainPlayerConflictConfiguration) {
        return _mainPlayerConflictConfiguration;
    }
    else{
        _mainPlayerConflictConfiguration =
        @{
            @(QYViewPriority_CommonViewAD):@[
                                            @{@(QYViewPriority_RollAD):@(QYViewConflictType_Exclusion)},
                                            @{@(QYViewPriority_PauseAD):@(QYViewConflictType_Exclusion)},
                                        ],
            
            @(QYViewPriority_ReadyBuyOverlay):@[
                                            @{@(QYViewPriority_RollAD):@(QYViewConflictType_Exclusion)},
                                            @{@(QYViewPriority_CommonViewAD):@(QYViewConflictType_Intersection)},
                                        ],
        };
        
        return _mainPlayerConflictConfiguration;
    }
}

//检验是否配置是否符合基本标准
+(BOOL)isValidConflictConfig:(NSDictionary*)conflicts{
 
    return YES;
}

@end
