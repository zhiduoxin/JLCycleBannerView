//
//  JCCycleLayout.m
//  TextApp
//
//  Created by lx on 2017/9/28.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "JCCycleLayout.h"

@implementation JCCycleLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    // 获得super已经计算好的布局属性（在super已经算好的基础上，再去做一些改进）
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
     // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x+self.collectionView.frame.size.width/2;
    
    // 在原有布局属性的基础上进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x和collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值计算cell的缩放比例
         CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    
    return array;
}

//默认return NO
//当collectionView的显示范围发生改变的时候，判断是否需要重新刷新布局
//一旦重新刷新布局，就会重新调用下面的方法：
//1.prepareLayout
//2.layoutAttributesForElementsInRect:方法

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
    
}

- (void)prepareLayout{
    
    [super prepareLayout];
    
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
}

@end
