//
//  LLScrollView.m
//  NewsApp
//
//  Created by 王政 on 2018/9/12.
//  Copyright © 2018年 lijialun. All rights reserved.
//

#import "LLScrollView.h"
#import "NSMutableArray+Remove.h"



@interface LLScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView  *scrollView; //滑动视图
@property(nonatomic,strong)UIPageControl *pageCtl;    //分页圆点
@property(nonatomic,strong)UIImageView * leftImageView;
@property(nonatomic,strong)UIImageView * middleImageView;
@property(nonatomic,strong)UIImageView * rightImageView;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation LLScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.delegate = self;
        //创建3倍contentSize，避免浪费内存
        self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        self.scrollView.contentOffset = CGPointMake(frame.size.width, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        self.pageCtl.numberOfPages = 3;
        self.pageCtl.pageIndicatorTintColor = [UIColor redColor];
        [self addSubview:self.pageCtl];
        
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*2, 0, frame.size.width, frame.size.height)];
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.middleImageView];
        [self.scrollView addSubview:self.rightImageView];
        
        self.index = 0;
    }
    return self;
}


//imageItemArr set 方法
-(void)setImageItemArr:(NSMutableArray<UIImage *> *)imageItemArr{
    _imageArr = [imageItemArr mutableCopy];
    if (imageItemArr.count > 2) {
        [_imageArr rightRm];
        _leftImageView.image = imageItemArr[0];
        _middleImageView.image = imageItemArr[1];
        _rightImageView.image = imageItemArr[2];
        self.pageCtl.numberOfPages = imageItemArr.count;
    }else if (imageItemArr.count == 2) {
        _leftImageView.image = imageItemArr[1];
        _middleImageView.image = imageItemArr[0];
        _rightImageView.image = imageItemArr[1];
        self.pageCtl.numberOfPages = imageItemArr.count;
    }else
    {
        _middleImageView.image = imageItemArr[0];
        self.scrollView.scrollEnabled = false;
        self.pageCtl.numberOfPages = 0;
    }
}

-(void)setPageAlign:(PageAlignment)pageAlign {
    CGSize size = [self.pageCtl sizeForNumberOfPages:self.imageArr.count];
    switch (pageAlign) {
        case PageAlignmentLeft:
        {
            self.pageCtl.frame = CGRectMake(30, self.frame.size.height - size.height, size.width, size.height);
        }
        break;
        case PageAlignmentRight:
        {
            self.pageCtl.frame = CGRectMake(self.frame.size.width - size.width - 30, self.frame.size.height - size.height, size.width, size.height);
        }
        break;
        case PageAlignmentCenter:
        {
            self.pageCtl.frame = CGRectMake(0, self.scrollView.bounds.size.height - 30, self.scrollView.bounds.size.width, 30);
        }
        break;
        default:
        break;
    }
}

-(void)setSeletedIndex:(NSInteger)seletedIndex {
    
    if (seletedIndex >= self.imageArr.count) {
        [NSException raise:@"索引值超出范围" format:@"selectedIndex 数组太大"];
        return;
    }
    
    if (seletedIndex  > self.imageArr.count / 2) {        
        for (NSInteger i = 0; i < self.imageArr.count - seletedIndex ; i++) {
             [self removeImageArrItem:@"right"];
        }
    } else
    {
        for (NSInteger i = 0; i < seletedIndex ; i++) {
            [self removeImageArrItem:@"left"];
        }
    }
    self.index = seletedIndex;
    self.pageCtl.currentPage = seletedIndex;
    [self upDateImage];
}

-(void)setShuffling:(BOOL)shuffling {
    
    if (shuffling) {
      
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
        
    } else {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)timerRun {
    [UIView animateWithDuration:0.5 animations:^{
       self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * 2, 0);
    }];
    [self upDateImageAdjustScrollViewContentSize];
}

#pragma mark - scrollViewdelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
 
/*
    1、判断滑动方向，2 移动数组图片顺序，把数组做成一个环状
 */
    [self upDateImageAdjustScrollViewContentSize];
}


//scrollView 移动结束后，根据位置改变图片
-(void)upDateImageAdjustScrollViewContentSize {
    if (self.scrollView.contentOffset.x == 0) { //右滑(手势向右)
        [self removeImageArrItem:@"right"];
        if (-- self.index < 0) {
            self.index = self.imageArr.count - 1;
        }
    }else if(self.scrollView.contentOffset.x == self.scrollView.bounds.size.width * 2) { //左滑
        [self removeImageArrItem:@"left"];
        if (++ self.index >= self.imageArr.count) {
            self.index = 0;
        }
    }else
    {
        return;
    }
    [self upDateImage];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    self.pageCtl.currentPage = self.index;
    
}


//移动数组元素
-(void)removeImageArrItem:(NSString*)direction {
    
    if ([direction isEqualToString:@"left"]) {
        if (self.imageArr.count > 2) {
            [self.imageArr leftRm];
        }else if(self.imageArr.count == 2)
        {
           [self.imageArr exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
    }else
    {
        if (self.imageArr.count > 2) {
            [self.imageArr rightRm];
        }else if(self.imageArr.count == 2)
        {
           [self.imageArr exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
    }
}

-(void)upDateImage {
    if (self.imageArr.count > 2) {
        _leftImageView.image = _imageArr[0];
        _middleImageView.image = _imageArr[1];
        _rightImageView.image = _imageArr[2];
    }
    else if(self.imageArr.count == 2) {
        _leftImageView.image = _imageArr[1];
        _middleImageView.image = _imageArr[0];
        _rightImageView.image = _imageArr[1];
    }
}

-(void)dealloc {
    [self.timer timeInterval];
    self.timer = nil;
}

@end
