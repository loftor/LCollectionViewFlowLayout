//
//  LCollectionViewFlowLayout.h
//  Example
//
//  Created by zhanglei on 10/04/2016.
//  Copyright © 2018 Loftor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LCollectionViewLineAlignType){
    LCollectionViewLineAlignJustify,
    LCollectionViewLineAlignLeading,
    LCollectionViewLineAlignCenter,
    LCollectionViewLineAlignTrailing,
    LCollectionViewLineAlignBetween,
};

@protocol LCollectionViewDelegateFlowLayout<UICollectionViewDelegateFlowLayout>
@optional

- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineAlignTypeForSectionAtIndex:(NSInteger)section;

@end

@interface LCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) IBInspectable NSUInteger lineAlignType;

@end
