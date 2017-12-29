//
//  ImageScroll.m
//  NEKA
//
//  Created by ma c on 16/4/27.
//  Copyright © 2016年 ma c. All rights reserved.
/// 图片缩放控件

#import "ImageScroll.h"


@interface ImageScroll ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, assign)BOOL isDoubleTap;
@end

@implementation ImageScroll

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)url {
    if (self = [super initWithFrame:frame]) {
        self.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.minimumZoomScale = 0.6;
        self.maximumZoomScale = 2.0;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];

        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_imageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@""]];
        [self addSubview:_imageView];
        [self addGest];
    }
    return self;
}

- (void)addGest {
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
    [self addGestureRecognizer:oneTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
}

- (void)oneTap {
    NSLog(@"one");
    _isDoubleTap = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_isDoubleTap == YES) return;
        //单击事件的相关操作
        if (_dismissBlock) {
            _dismissBlock();
        }
    });
    
}

- (void)doubleTap {
    NSLog(@"double");
    _isDoubleTap = YES;
    if (_imageView.frame.size.width != kScreenSize.width) {
        _imageView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        self.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
        
    }else {
        _imageView.frame = CGRectMake(0, 0, kScreenSize.width * 1.5, kScreenSize.height *1.5);
        self.contentSize = CGSizeMake(kScreenSize.width * 1.5, kScreenSize.height * 1.5);
        self.contentOffset = CGPointMake(kScreenSize.width * 0.25, kScreenSize.height * 0.25);
        
    }
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.zoomScale;
    _imageView.frame = CGRectMake(0, 0, kScreenSize.width * scale, kScreenSize.height * scale);
    self.contentSize = CGSizeMake(kScreenSize.width * scale, kScreenSize.height*scale);
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)goBackToInitial {
    _imageView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    self.contentSize = CGSizeMake(kScreenSize.width, kScreenSize.height);
}








@end
