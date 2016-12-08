//
//  DetailQuickBuyFlowLayout.h
//  PreciousMetal
//
//  Created by moxuyou on 2016/12/7.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailQuickBuyFlowLayout : UICollectionViewFlowLayout

/** cell的个数 */
@property (assign, nonatomic) NSInteger cellCount;
/** 根据offset改变CollectionView当前选中按钮的状态 */
- (void)changeCollectionViewCellColor:(UIScrollView *)scrollView;

@end
