//
//  JCCycleBannerCell.m
//  TextApp
//
//  Created by lx on 2017/9/27.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "JCCycleBannerCell.h"
#import "UIImageView+WebCache.h"

@interface JCCycleBannerCell ()

@property (strong, nonatomic) UIImageView *image_view;

@property (copy, nonatomic) NSString *placeholder;

@end

@implementation JCCycleBannerCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        self.image_view = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:self.image_view];
        self.placeholder = @"2";
    }
    return self;
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    [self.image_view sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:_placeholder]];
    [self layoutIfNeeded];
}


- (void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    self.image_view.image = [UIImage imageNamed:@"1"];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.image_view.frame = self.bounds;
}

@end
