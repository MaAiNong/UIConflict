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

@property(nonatomic,strong)NSMapTable* conflictViews;

-(id)init;

-(BOOL)canShowView:(QYPlayerConflictViewMessage*)view;

-(void)registView:(QYPlayerConflictViewMessage*)view;

-(void)handleViewShow:(QYPlayerConflictViewMessage*)view;

-(void)handleViewHide:(QYPlayerConflictViewMessage*)view;

@end

NS_ASSUME_NONNULL_END
