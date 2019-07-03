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
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleViewClick:)]];
 
    [self.view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
}

-(void)longPress:(id)sender{
    vmglobal = nil;
}

-(void)handleViewClick:(id)sender{
    
}
@end
