//
//  QYPlayerViewConflictDefine.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictDefine.h"
#import "QYPlayerViewConflictConstants.h"
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
          @(QYViewPriority_CommonViewAD):
  @[
  @{KEY_PRIORITY:@(QYViewPriority_RollAD),KEY_CONFLICT:@(QYViewConflictType_Exclusion)},
  @{KEY_PRIORITY:@(QYViewPriority_PauseAD),KEY_CONFLICT:@(QYViewConflictType_Exclusion)},
  ],
          
          @(QYViewPriority_ReadyBuyOverlay):
  @[
  @{KEY_PRIORITY:@(QYViewPriority_RollAD),KEY_CONFLICT:@(QYViewConflictType_Exclusion)},
  @{KEY_PRIORITY:@(QYViewPriority_CommonViewAD),KEY_CONFLICT:@(QYViewConflictType_Intersection)},
  ],
          @(QYViewPriority_PauseAD):
    @[
      @{KEY_PRIORITY:@(QYViewPriority_RollAD),KEY_CONFLICT:@(QYViewConflictType_Exclusion)}
    ],
          };
        
        return _mainPlayerConflictConfiguration;
    }
}

//检验是否配置是否符合基本标准
+(BOOL)isValidConflictConfig:(NSDictionary*)conflicts{
    
    if(!conflicts || ![conflicts isKindOfClass:[NSDictionary class]])
        return NO;
    __block BOOL isValid = YES;
    [conflicts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray* value = obj;
        if ([value isKindOfClass:[NSArray class]]) {
            for (NSDictionary* cur_conflict in value) {
                if ([cur_conflict isKindOfClass:[NSDictionary class]] &&  cur_conflict[KEY_PRIORITY] && cur_conflict[KEY_CONFLICT]) {
                    QYView_ShowPriority cur_priority = [[cur_conflict objectForKey:KEY_PRIORITY] intValue];
                    if (cur_priority>=[key intValue]) {
                        isValid = NO;
                        *stop = YES;
                    }
                }else{
                    isValid = NO;
                    *stop = YES;
                }
            }
        }
        else{
            isValid = NO;
            *stop = YES;
        }
    }];
    
    return isValid;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation QYConflictReason


@end
