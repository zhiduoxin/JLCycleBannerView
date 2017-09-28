//
//  JCCycleBannerCell.h
//  TextApp
//
//  Created by lx on 2017/9/27.
//  Copyright © 2017年 lx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCycleBannerCell : UICollectionViewCell

/**
网络图片的url
 */
@property (copy, nonatomic) NSString *imageUrl;
/**
 本地图片
 */
@property (copy, nonatomic) NSString *imageStr;

/**
 占位图片
 */
@property (copy, nonatomic) NSString *placeholderImageStr;


@end
