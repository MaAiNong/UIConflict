//
//  UIView+QYUIConflict.m
//  ViewConflict
//
//  Created by xukaitian on 2019/9/20.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "UIView+QYUIConflict.h"
#import <objc/runtime.h>

static void *QYView_ShowPriority_Context = &QYView_ShowPriority_Context;
static void *QYConfictHandler_Context = &QYConfictHandler_Context;

@implementation UIView (QYUIConflict)

-(QYView_ShowPriority)conflict_showPriority{
    
    return [objc_getAssociatedObject(self, QYView_ShowPriority_Context) intValue];
}

-(void)setConflict_showPriority:(QYView_ShowPriority)conflict_showPriority{
    objc_setAssociatedObject(self, QYView_ShowPriority_Context, @(conflict_showPriority), OBJC_ASSOCIATION_ASSIGN);
}

-(QYConfictHandler)confictHandler{
    
    return objc_getAssociatedObject(self, QYConfictHandler_Context);
}

-(void)setConfictHandler:(QYConfictHandler)confictHandler{
    objc_setAssociatedObject(self, QYConfictHandler_Context, confictHandler, OBJC_ASSOCIATION_COPY);
}
@end
