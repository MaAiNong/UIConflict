//
//  QYPlayerViewConflictManager.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictManager.h"
#import "QYPlayerConflictViewMessage+internal.h"
@interface QYPlayerViewConflictManager()<QYPlayerConflictViewMessageDelegate>


@end

@implementation QYPlayerViewConflictManager

-(id)init{
    if (self = [super init]) {
        self.conflictViews = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

-(BOOL)canShowView:(QYPlayerConflictViewMessage*)view{
    
 
    return YES;
}

-(void)registView:(QYPlayerConflictViewMessage*)view{
    
    [self.conflictViews setObject:view forKey:view.currentView];
}

-(void)handleViewShow:(QYPlayerConflictViewMessage*)view{
    
}

-(void)handleViewHide:(QYPlayerConflictViewMessage*)view{
    
}

#pragma mark -- QYPlayerConflictViewMessageDelegate
-(void)viewDidReleased:(QYPlayerConflictViewMessage *)message{
    
}

@end
