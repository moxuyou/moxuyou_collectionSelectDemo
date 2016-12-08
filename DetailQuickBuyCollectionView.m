//
//  DetailQuickBuyCollectionView.m
//  PreciousMetal
//
//  Created by moxuyou on 2016/12/8.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "DetailQuickBuyCollectionView.h"
#import "DetailQuickBuyCell.h"
#import "DetailQuickBuyFlowLayout.h"
#import "DetailQuickBuyPriceButton.h"
#import "DetailQuickBuyButton.h"

static NSString *cellId = @"DetailQuickBuyViewCell";
static NSInteger cellCount = 10;
#define defaultColor [UIColor blackColor]
#define curronColor [UIColor orangeColor]

@interface DetailQuickBuyCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 滚动中间橙色的View1 */
@property (weak, nonatomic) IBOutlet UIView *midleView1;
/** 滚动中间橙色的View2 */
@property (weak, nonatomic) IBOutlet UIView *midleView2;
/** 滚动选择的collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 交易数量标题 */
@property (weak, nonatomic) IBOutlet UILabel *exchangePriceTitleLabel;
/** 交易数量为1的按钮 */
@property (weak, nonatomic) IBOutlet DetailQuickBuyButton *exchangePriceMinButton;
/** 交易数量为10的按钮 */
@property (weak, nonatomic) IBOutlet DetailQuickBuyButton *exchangePriceMaxButton;
/** 流水布局 */
@property (strong, nonatomic) DetailQuickBuyFlowLayout *layout;

@end
@implementation DetailQuickBuyCollectionView

+ (instancetype)detailQuickBuyCollectionView{
    
    DetailQuickBuyCollectionView *view = [[NSBundle mainBundle] loadNibNamed:@"DetailQuickBuyCollection" owner:nil options:nil].lastObject;
    
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[DetailQuickBuyCell class] forCellWithReuseIdentifier:cellId];
    //创建流水布局
    DetailQuickBuyFlowLayout *layout = [[DetailQuickBuyFlowLayout alloc] init];
    self.layout = layout;
    layout.cellCount = cellCount;
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.backgroundColor = background_color;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.decelerationRate = 10;
    if (IS_IPHONE_6){
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - 1, self.collectionView.contentOffset.y);
    }
    
    self.exchangePriceTitleLabel.textColor = mine_cell_text_color;
    
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (IS_IPHONE_5) {
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - 1, self.collectionView.contentOffset.y);
        }
        if (IS_IPHONE_6P){
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x - 3, self.collectionView.contentOffset.y);
        }
        [weakSelf exchangePriceMinButtonClick];
    });
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailQuickBuyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row + 1];
    cell.titleLabel.textColor = defaultColor;
    //    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
//返回每个cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.LXHWidth * 0.3, self.LXHHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.curronIndex = indexPath.row + 1;
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - Action

/** 购买数量为1的按钮被点击 */
- (IBAction)exchangePriceMinButtonClick {
    
    NSLog(@"%s", __func__);
    self.curronIndex = 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
/** 购买数量为10的按钮被点击 */
- (IBAction)exchangePriceMaxButtonClick {
    
    NSLog(@"%s", __func__);
    self.curronIndex = 10;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//惯性滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    NSLog(@"%s", __func__);
    CGFloat offSetCount = (scrollView.contentOffset.x + self.collectionView.LXHWidth * 0.1) / self.collectionView.LXHWidth;
    self.curronIndex = offSetCount / 0.3 + 1;
    [self.layout changeCollectionViewCellColor:scrollView];
}

//瞬间停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate == NO) {
        //        NSLog(@"%s", __func__);
        CGFloat offSetCount = (scrollView.contentOffset.x + self.collectionView.LXHWidth * 0.1) / self.collectionView.LXHWidth;
        self.curronIndex = offSetCount / 0.3 + 1;
        [self.layout changeCollectionViewCellColor:scrollView];
    }
    
}

/** 修改当前被选中的值 */
- (void)setCurronIndex:(NSInteger)curronIndex{
    
    _curronIndex = curronIndex;
    if (curronIndex == [self.exchangePriceMinButton.titleLabel.text integerValue]) {
        self.exchangePriceMinButton.selected = YES;
    }else{
        self.exchangePriceMinButton.selected = NO;
    }
    
    if (curronIndex == [self.exchangePriceMaxButton.titleLabel.text integerValue]) {
        self.exchangePriceMaxButton.selected = YES;
    }else{
        self.exchangePriceMaxButton.selected = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(detailQuickBuyCollectionViewValueChange:)]) {
        [self.delegate detailQuickBuyCollectionViewValueChange:self.curronIndex];
    }
    
}

@end
