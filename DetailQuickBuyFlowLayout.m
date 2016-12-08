//
//  DetailQuickBuyFlowLayout.m
//  PreciousMetal
//
//  Created by moxuyou on 2016/12/7.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "DetailQuickBuyFlowLayout.h"
#import "DetailQuickBuyCell.h"

@implementation DetailQuickBuyFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(self.sectionInset.top,
                                         inset,
                                         self.sectionInset.top,
                                         inset);
    self.itemSize = CGSizeMake(self.collectionView.LXHWidth * 0.3, self.collectionView.LXHHeight);
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

/** 返回值为rect范围内所有元素的布局属性, 即排布方式(frame) */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView的centerX
    CGFloat collectionViewConterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat delta = ABS(attributes.center.x - collectionViewConterX);
        CGFloat scale = 1.1f - delta / self.collectionView.frame.size.width * 1.1;
        
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
        
        [self changeCollectionViewCellColor:self.collectionView];
    }
    
    return array;
}

/** bounds改变, 实时刷新layout 默认NO */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (ABS(minDelta) > ABS(attributes.center.x - centerX)) {
            minDelta = attributes.center.x - centerX;
        }
    }
    
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

- (void)changeCollectionViewCellColor:(UIScrollView *)scrollView{
    
    CGFloat offSetCount = (scrollView.contentOffset.x + self.collectionView.LXHWidth * 0.1) / self.collectionView.LXHWidth;
    NSInteger curronNum = offSetCount / 0.3 + 1;
    //    NSLog(@"offSetCount = %lu", curronNum);
    for (int i = 0; i < self.cellCount; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        DetailQuickBuyCell *cell = (DetailQuickBuyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (i == curronNum - 1) {
            
            cell.titleLabel.textColor = [UIColor orangeColor];
        }else{
            
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        
    }
}

@end
