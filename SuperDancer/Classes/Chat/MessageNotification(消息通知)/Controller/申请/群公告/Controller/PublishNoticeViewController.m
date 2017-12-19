//
//  PublishNoticeViewController.m
//  SuperDancer
//
//  Created by yu on 2017/12/18.
//  Copyright © 2017年 yu. All rights reserved.
//  发布公告

#import "PublishNoticeViewController.h"
#import "SubmitImageCell.h"
#import "TZImagePickerController.h"

#define kSizeHeight (kAutoWidth(70))

@interface PublishNoticeViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *photos;


@end

static NSString *kImageCellIdentifier = @"kImageCellIdentifier";

@implementation PublishNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发布公告";
    self.titleBgView.layer.borderWidth = .5;
    self.titleBgView.layer.borderColor = kLineColor.CGColor;
    self.contentTextView.layer.borderWidth = .5;
    self.contentTextView.layer.borderColor = kLineColor.CGColor;
    self.imageBgView.layer.borderWidth = .5;
    self.imageBgView.layer.borderColor = kLineColor.CGColor;
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self setRightItemTitle:@"发布" action:@selector(publishGroupNoticeAction)];
    
//    self.photos = [NSMutableArray array];
    
    [self.collectionView registerNib:NIB_NAMED(@"SubmitImageCell") forCellWithReuseIdentifier:kImageCellIdentifier];
}

- (void)publishGroupNoticeAction
{
    PPLog(@"发布公告");
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    long long remainNum ;
    NSString *textContent;
    if (textView.text.length == 0) {
        _placeholderLabel.text = @"正文(必填)，15~500字";
    }else if(textView.text.length >= 500){
        textView.text = [textView.text substringToIndex:500];
        _placeholderLabel.text = @"";
    }else{
        _placeholderLabel.text = @"";
        textContent = textView.text;
        long long existNum = [textContent length];
        remainNum = 500 - existNum;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [textView scrollRangeToVisible:NSMakeRange(textView.text.length, 1)];
    if(range.location >= 500){
        return NO;
    }
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count] + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeHeight, kSizeHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SubmitImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == [self.photos count]) {
        cell.imageView.image = IMAGE_NAMED(@"wd_announcement_ico_add");
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = self.photos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)deleteAction:(UIButton *)btn {
    
    [self.photos removeObjectAtIndex:btn.tag];
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:btn.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photos.count) {
        @weakify(self);
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc]init];
        imagePicker.maxImagesCount = 1;
        imagePicker.showSelectBtn = NO;
        imagePicker.allowCrop = NO;
        imagePicker.needCircleCrop = NO;
        
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            @strongify(self);
            // 本期只允许上传一张
            self.photos = [NSMutableArray array];
            [self.photos addObject:photos[0]];

            [self.collectionView reloadData];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake((80-kSizeHeight)/2, 19, (80-kSizeHeight)/2, 19);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
