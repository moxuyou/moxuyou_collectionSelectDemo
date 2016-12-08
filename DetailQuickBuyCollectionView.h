//
//  DetailQuickBuyCollectionView.h
//  PreciousMetal
//
//  Created by moxuyou on 2016/12/8.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailQuickBuyCollectionViewDelegate <NSObject>

@optional
- (void)detailQuickBuyCollectionViewValueChange:(NSInteger)curronIndex;

@end
@interface DetailQuickBuyCollectionView : UIView

/** 当前被选中的值 */
@property (assign, nonatomic) NSInteger curronIndex;
/** 代理 */
@property (weak, nonatomic) id<DetailQuickBuyCollectionViewDelegate> delegate;
+ (instancetype)detailQuickBuyCollectionView;

@end
