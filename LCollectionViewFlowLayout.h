//
//  LCollectionViewFlowLayout.h
//  Example
//
//  Created by zhanglei on 10/04/2016.
//  Copyright © 2016 Loftor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LCollectionViewLineAlignType){
    LCollectionViewLineAlignJustify,
    LCollectionViewLineAlignLeading,
    LCollectionViewLineAlignCenter,
    LCollectionViewLineAlignTrailing,
    LCollectionViewLineAlignBetween,
};

typedef NS_ENUM(NSUInteger,LCollectionViewItemAlignType){
    LCollectionViewItemAlignCenter,
    LCollectionViewItemAlignLeading,
    LCollectionViewItemAlignTrailing,
};

@protocol LCollectionViewDelegateFlowLayout<UICollectionViewDelegateFlowLayout>

@optional

- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout lineAlignTypeForSectionAtIndex:(NSInteger)section;

- (NSUInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout itemAlignTypeForSectionAtIndex:(NSInteger)section;

@end

@interface LCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) IBInspectable NSUInteger lineAlignType;

@property (assign, nonatomic) IBInspectable NSUInteger itemAlignType;

@end
