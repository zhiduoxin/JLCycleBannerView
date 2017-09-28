//
//  JLCycleBannerView.m
//  TextApp
//
//  Created by lx on 2017/9/27.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "JLCycleBannerView.h"
#import "JCCycleBannerCell.h"
//#import "JCCycleLayout.h"

static NSString * JCCycleBannerCellID = @"JCCycleBannerCellID";

@interface JLCycleBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSArray *imageArray;

@property (assign, nonatomic) BOOL isNetImageurl;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

/**
 滚动方向
 */
@property (assign, nonatomic) collectionViewScrollDirection collectionViewScrollDirection;

@end

@implementation JLCycleBannerView

-(NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray  = [[NSArray alloc] init];
    }
    return _imageArray;
}
+ (JLCycleBannerView *)initCreatBannerView:(CGRect)frame{
    
    return [[JLCycleBannerView alloc] initWithFrame:frame];
}
- (void)deallocOrCreatTimer:(BOOL)isCreat{
    if (isCreat) {
        [self addtimer];
    }else{
        [self deleteTimer];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        [self initAllPropertys];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout = [[JCCycleLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _layout = layout;
        if (self.collectionViewScrollDirection == 0) {
            layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        }else{
            layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        }
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        [collectionView registerClass:[JCCycleBannerCell class] forCellWithReuseIdentifier:JCCycleBannerCellID];
        collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        [self creatPageControl];
    }
    return self;
}
- (void)initAllPropertys{
    self.isNetImageurl = YES;
    self.timeInterval = 2.0;
    self.showPositionBegin = 0;
    self.pageControlPosition = 1;
    self.isCycleScroll = YES;
    self.collectionViewScrollDirection = collectionViewScrollDirectionH;
    self.backgroundColor = [UIColor greenColor];
}

- (void)creatPageControl{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
}
#pragma mark UICollectionDelegate  UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JCCycleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JCCycleBannerCellID forIndexPath:indexPath];
    if (_isNetImageurl) {
        cell.imageUrl = self.imageArray[indexPath.row];
    }else{
        cell.imageStr = self.imageArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didSelectImageOnBlcok) {
        self.didSelectImageOnBlcok(indexPath.row);
    }
}

- (void)setIsCycleScroll:(BOOL)isCycleScroll{
    _isCycleScroll = isCycleScroll;
    
    if (self.imageArray.count == 0) {
        return;
    }
    //重新加载开始位置
    [self beginViewScroll];
    if (_isCycleScroll) {
        return;
    }else{
        [self restoreImageArray];
        [self.collectionView reloadData];
    }
}
- (void)setBannerImageUrls:(NSArray *)bannerImageUrls{
    _bannerImageUrls = bannerImageUrls;
    if (!bannerImageUrls || bannerImageUrls.count == 0){
        return;
    }
    self.imageArray = bannerImageUrls;
    self.pageControl.numberOfPages = self.imageArray.count;
    [self handleImageArray];
    self.isNetImageurl = YES;
    [self.collectionView reloadData];
    [self addtimer];
    [self beginViewScroll];
    
}

- (void)setBannerLocalImages:(NSArray *)bannerLocalImages{
    _bannerLocalImages = bannerLocalImages;
    if (!bannerLocalImages || bannerLocalImages.count == 0){
        return;
    }
    self.imageArray = bannerLocalImages;
    self.pageControl.numberOfPages = self.imageArray.count;
    self.isNetImageurl = NO;
    [self handleImageArray];
    [self.collectionView reloadData];
    [self addtimer];
    [self beginViewScroll];
}

- (void)setTimeInterval:(NSInteger)timeInterval{
    _timeInterval = timeInterval;
    [self.timer invalidate];
    self.timer = nil;
    [self addtimer];
    
}

- (void)handleImageArray{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.imageArray];
    [arr insertObject:self.imageArray.lastObject atIndex:0];
    [arr addObject:self.imageArray.firstObject];
    self.imageArray = [arr copy];
}
- (void)restoreImageArray{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.imageArray];
    [arr removeObjectAtIndex:0];
    [arr removeLastObject];
    self.imageArray = [arr copy];
}
- (void)beginViewScroll{
    NSInteger index_show;
    switch (self.showPositionBegin) {
        case 0:
            index_show = _isCycleScroll ==YES?1:0;
            break;
        case 1:
            index_show = _isCycleScroll ==YES?self.imageArray.count/2-1:self.imageArray.count/2;
            break;
        case 2:
            index_show = _isCycleScroll ==YES?self.imageArray.count-2:self.imageArray.count-1;
            break;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index_show inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)setPageNormalColor:(UIColor *)pageNormalColor{
    _pageNormalColor = pageNormalColor;
    self.pageControl.pageIndicatorTintColor = _pageNormalColor;
}

- (void)setPageCurrentColor:(UIColor *)pageCurrentColor{
    _pageCurrentColor = pageCurrentColor;
    self.pageControl.currentPageIndicatorTintColor = _pageCurrentColor;
    
}

- (void)setCollectionViewScrollDirection:(collectionViewScrollDirection)collectionViewScrollDirection{
    
    _collectionViewScrollDirection = collectionViewScrollDirection;
    if (_collectionViewScrollDirection == 0) {
       _layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }else{
        _layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    }
    [self.collectionView reloadData];
}

/**
 添加时间定时器
 */
- (void)addtimer{
    if (self.timer) { return;}
    NSTimer *timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(nextScrollImage) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
  删除定时器
 */
- (void)deleteTimer{
    
    [self.timer invalidate];
    self.timer = nil;
}

/**
 往下翻页
 */
- (void)nextScrollImage{

    NSInteger index_show = 0;
    BOOL isHaveAnimation = YES;
    if (_isCycleScroll) {
        index_show = self.pageControl.currentPage+2;
    }else{
        index_show = self.pageControl.currentPage+1;
        if (self.pageControl.currentPage == self.pageControl.numberOfPages-1) {
            index_show = 0;
            isHaveAnimation = NO;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index_show inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:isHaveAnimation];

}

/**
   往上翻页
 */
- (void)lastScrollImage{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.pageControl.currentPage-2 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffsetXOrY = scrollView.contentOffset.x;
    CGFloat widthOrHeight = scrollView.bounds.size.width;
    if (_collectionViewScrollDirection == 1) {
        contentOffsetXOrY =scrollView.contentOffset.y;
        widthOrHeight = scrollView.bounds.size.height;
    }
    
    int page = 0;
    if (_isCycleScroll) {
        page =(int) ((contentOffsetXOrY-widthOrHeight)/widthOrHeight+0.5) % self.imageArray.count;
    }else{
        page =(int) (contentOffsetXOrY/widthOrHeight+0.5) % self.imageArray.count;
    }
    self.pageControl.currentPage = page;
    //判断是否是无线循环 不是的话直接返回
    if (_isCycleScroll == NO) {
        return;
    }
    if (contentOffsetXOrY <widthOrHeight/2) {
        self.pageControl.currentPage = self.imageArray.count - 2-1;
    }
    if (contentOffsetXOrY >widthOrHeight/2+(self.imageArray.count-2)*widthOrHeight) {
        self.pageControl.currentPage = 0;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self deleteTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addtimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_isCycleScroll == NO) {
        return;
    }
    CGFloat contentOffsetXOrY = scrollView.contentOffset.x;
    CGFloat widthOrHeight = scrollView.bounds.size.width;
    if (_collectionViewScrollDirection == 1) {
        contentOffsetXOrY =scrollView.contentOffset.y;
        widthOrHeight = scrollView.bounds.size.height;
    }
    if (contentOffsetXOrY == 0) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.imageArray.count-2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    if (contentOffsetXOrY == (self.imageArray.count-1)*widthOrHeight) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (_isCycleScroll == NO) {
        return;
    }
    CGFloat contentOffsetXOrY = scrollView.contentOffset.x;
    CGFloat widthOrHeight = scrollView.bounds.size.width;
    if (_collectionViewScrollDirection == 1) {
        contentOffsetXOrY =scrollView.contentOffset.y;
        widthOrHeight = scrollView.bounds.size.height;
    }
    if (contentOffsetXOrY == (self.imageArray.count-1)*widthOrHeight) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size =  [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    if (self.pageControlPosition == 0) {
        self.pageControl.frame = CGRectMake((self.bounds.size.width - size.width)/2, self.bounds.size.height - size.height, size.width, size.height);
    }else{
        self.pageControl.frame = CGRectMake(self.bounds.size.width - size.width-10, self.bounds.size.height - size.height, size.width, size.height);
    }
    
}

@end
