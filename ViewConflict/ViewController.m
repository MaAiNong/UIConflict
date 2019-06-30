//
//  ViewController.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "ViewController.h"
#import "QYPlayerViewConflictManager.h"

@interface ViewController ()

@end

@implementation ViewController{
    QYPlayerViewConflictManager* _conflictManager;
    UIView* vmglobal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _conflictManager = [[QYPlayerViewConflictManager alloc] init];
    
    UIView* vw = [[UIView alloc] initWithFrame:self.view.bounds];
    vmglobal = vw;
    QYPlayerConflictViewMessage* massage = [[QYPlayerConflictViewMessage alloc] init];
    massage.currentView = vw;
    
    [_conflictManager registView:massage];
    
    
    {
        UIView* vw = [[UIView alloc] initWithFrame:self.view.bounds];
        QYPlayerConflictViewMessage* massage = [[QYPlayerConflictViewMessage alloc] init];
        massage.currentView = vw;
        
        [_conflictManager registView:massage];
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewClick:)]];
 
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
}

-(void)longPress:(id)sender{
    vmglobal = nil;
}

-(void)handleViewClick:(id)sender{
    
    id value;
    NSEnumerator*  enumerator = [_conflictManager.conflictViews keyEnumerator];
    while ((value = [enumerator nextObject])) {
        /* code that acts on the hash table's values */
        NSLog(@"key %@",value);
    }
    
    {
        id value;
        NSEnumerator*  enumerator = [_conflictManager.conflictViews objectEnumerator];
        while ((value = [enumerator nextObject])) {
            /* code that acts on the hash table's values */
            NSLog(@"value %@",value);
        }
    }
}
@end
