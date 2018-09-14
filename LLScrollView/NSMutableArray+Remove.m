//
//  NSMutableArray+Remove.m
//  NewsApp
//
//  Created by 王政 on 2018/9/13.
//  Copyright © 2018年 lijialun. All rights reserved.
//

#import "NSMutableArray+Remove.h"

@implementation NSMutableArray (Remove)
-(NSMutableArray*)leftRm {
    [self addObject:[self objectAtIndex:0]];
    
    [self removeObjectAtIndex:0];
    return self;
}

-(NSMutableArray*)rightRm {
    
 
    [self insertObject:[self objectAtIndex:(self.count - 1)] atIndex:0];
    
    [self removeObjectAtIndex:(self.count - 1)];
    
    return self;
}
@end
