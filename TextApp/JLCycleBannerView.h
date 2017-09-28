//
//  JLCycleBannerView.h
//  TextApp
//
//  Created by lx on 2017/9/27.
//  Copyright © 2017年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, showPositionBegin) {
    showPositionBeginLeft = 0,
    showPositionBeginCenter,
    showPositionBeginRight,
};
typedef NS_ENUM(NSUInteger, pageControlPosition) {
    pageControlPositionCenter = 0,
    pageControlPositionRight,
};
typedef NS_ENUM(NSUInteger, collectionViewScrollDirection) {
    collectionViewScrollDirectionH  = 0,
    collectionViewScrollDirectionV,
};


typedef void(^didSelectImageOnBlcok)(NSInteger index);

@interface JLCycleBannerView : UIView
@property (copy, nonatomic) didSelectImageOnBlcok didSelectImageOnBlcok;
/**
 网络图片集合
 */
@property (copy, nonatomic) NSArray *bannerImageUrls;
/**
 本地图片集合
 */
@property (copy, nonatomic) NSArray *bannerLocalImages;

/**
 其他UIpageControl的颜色
 */
@property (strong, nonatomic) UIColor *pageNormalColor;
/**
 当前UipageControl的颜色
 */
@property (strong, nonatomic) UIColor *pageCurrentColor;

/**
 默认从 最左边开始
 */
@property (assign, nonatomic) showPositionBegin showPositionBegin;

/**
 pageControl的位置
 */
@property (assign, nonatomic) pageControlPosition pageControlPosition;


/**
 是否开启无线循环  默认YES
 */
@property (assign, nonatomic) BOOL isCycleScroll;

/**
 定时器的执行的间隔
 */
@property (assign, nonatomic) NSInteger timeInterval;


/**
 初始化方法

 @param frame frame
 @return JLCycleBannerView
 */
+ (JLCycleBannerView *)initCreatBannerView:(CGRect)frame;


/**
  释放timer还是创建timer
 一般都是在控制器的viewwillappear  viewwillDisappear调用

 @param isCreat Yes NO
 */
- (void)deallocOrCreatTimer:(BOOL)isCreat;

@end
