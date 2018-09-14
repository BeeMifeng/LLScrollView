//
//  LLScrollView.h
//  NewsApp
//
//  Created by 王政 on 2018/9/12.
//  Copyright © 2018年 lijialun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSUInteger,PageAlignment) {
    PageAlignmentLeft = 0, //default
    PageAlignmentCenter,
    PageAlignmentRight
};


@interface LLScrollView : UIView
@property(nonatomic,strong)NSArray<UIImage*> * imageItemArr; //要显示的图片数组
@property(nonatomic,assign)PageAlignment pageAlign; //pageController 显示位置.(左中右)
@property(nonatomic,assign)NSInteger seletedIndex;  //控制默认图片位置.
@property(nonatomic,assign)BOOL shuffling;  //是否自动轮播
@end
