//
//  LCollectionViewFlowLayout.m
//  Example
//
//  Created by zhanglei on 19/04/2016.
//  Copyright © 2018 Loftor. All rights reserved.
//

#import "LCollectionViewFlowLayout.h"



@implementation LCollectionViewFlowLayout{
    CGFloat _l_sum;
    NSUInteger _l_sectionLineAlignType;
    CGFloat _l_sectionMinimumInteritemSpacing;
    CGFloat _l_sectionMinimumLineSpacing;
    UIEdgeInsets _l_sectionInset;
}

- (void)prepareLayout{
    [super prepareLayout];
}

- (id<LCollectionViewDelegateFlowLayout>)l_getDelegate{
    return self.collectionView.delegate;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

    NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    
    NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];

    NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
    
    for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
        

        UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index];
        
        if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            continue;
        }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]){
            continue;
        }
        
        UICollectionViewLayoutAttributes *previousAttr = [layoutAttributesTemp lastObject];
        
        BOOL bNextLine = NO;
        
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal:
                bNextLine = fabs(currentAttr.center.x - previousAttr.center.x)>1;
                break;
            case UICollectionViewScrollDirectionVertical:
                bNextLine = fabs(currentAttr.center.y - previousAttr.center.y)>1;
                break;
            default:
                break;
        }
        
        if (bNextLine) {
            if ([[self l_getDelegate] respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                 _l_sectionMinimumInteritemSpacing = [[self l_getDelegate] collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:previousAttr.indexPath.section];
            }
            else{
                _l_sectionMinimumInteritemSpacing = self.minimumInteritemSpacing;
            }
            if ([[self l_getDelegate] respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
                _l_sectionInset = [[self l_getDelegate] collectionView:self.collectionView layout:self insetForSectionAtIndex:previousAttr.indexPath.section];
            }
            else{
                _l_sectionInset = self.sectionInset;
            }
            if ([[self l_getDelegate] respondsToSelector:@selector(collectionView:layout:lineAlignTypeForSectionAtIndex:)]) {
                _l_sectionLineAlignType = [[self l_getDelegate] collectionView:self.collectionView layout:self lineAlignTypeForSectionAtIndex:previousAttr.indexPath.section];
            }
            else{
                _l_sectionLineAlignType = _lineAlignType;
            }
            if (_l_sectionLineAlignType != LCollectionViewLineAlignJustify) {
                [self l_setCellFrame:layoutAttributesTemp];
                _l_sum = 0;
            }

            
            [layoutAttributesTemp removeAllObjects];
        }
        [layoutAttributesTemp addObject:currentAttr];
        
        
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal:
                _l_sum += currentAttr.frame.size.height;
                break;
            case UICollectionViewScrollDirectionVertical:
                _l_sum += currentAttr.frame.size.width;
                break;
            default:
                break;
        }
        
    }

    return layoutAttributes;
}

-(void)l_setCellFrame:(NSMutableArray*)layoutAttributes{
    CGFloat now = 0.0;
    switch (_l_sectionLineAlignType) {
        case LCollectionViewLineAlignLeading:
            now = self.scrollDirection==UICollectionViewScrollDirectionVertical?_l_sectionInset.left:_l_sectionInset.top;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                attributes.frame = [self l_transfterFrame:nowFrame withNow:now];
                now += (self.scrollDirection==UICollectionViewScrollDirectionVertical?nowFrame.size.width:nowFrame.size.height) + _l_sectionMinimumInteritemSpacing;
            }
            break;
        case LCollectionViewLineAlignCenter:
            now = (self.scrollDirection==UICollectionViewScrollDirectionVertical)?_l_sectionInset.left:_l_sectionInset.top;
            now += ((self.scrollDirection==UICollectionViewScrollDirectionVertical?(self.collectionView.frame.size.width -_l_sectionInset.left-_l_sectionInset.right):(self.collectionView.frame.size.height -_l_sectionInset.top-_l_sectionInset.bottom)) - _l_sum - ((layoutAttributes.count-1) * self.minimumInteritemSpacing)) / 2;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                attributes.frame = [self l_transfterFrame:nowFrame withNow:now];
                now += (self.scrollDirection==UICollectionViewScrollDirectionVertical?nowFrame.size.width:nowFrame.size.height) + _l_sectionMinimumInteritemSpacing;
            }
            break;
            
        case LCollectionViewLineAlignTrailing:
            now = (self.scrollDirection==UICollectionViewScrollDirectionVertical)?(self.collectionView.frame.size.width - _l_sectionInset.right):(self.collectionView.frame.size.height - _l_sectionInset.bottom);
            for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
                UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
                CGRect nowFrame = attributes.frame;
                attributes.frame = [self l_transfterFrame:nowFrame withNow:now - nowFrame.size.width];
                now -=  (self.scrollDirection==UICollectionViewScrollDirectionVertical?nowFrame.size.width:nowFrame.size.height) + _l_sectionMinimumInteritemSpacing;
            }
            break;
        case LCollectionViewLineAlignBetween:
        {
            now = (self.scrollDirection==UICollectionViewScrollDirectionVertical)?_l_sectionInset.left:_l_sectionInset.top;
            CGFloat between = ((self.scrollDirection==UICollectionViewScrollDirectionVertical?(self.collectionView.frame.size.width -_l_sectionInset.left-_l_sectionInset.right):(self.collectionView.frame.size.height -self.sectionInset.top-_l_sectionInset.bottom))- _l_sum) / (layoutAttributes.count+1);
            now += between;
            for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
                CGRect nowFrame = attributes.frame;
                attributes.frame = [self l_transfterFrame:nowFrame withNow:now];
                now += (self.scrollDirection==UICollectionViewScrollDirectionVertical?nowFrame.size.width:nowFrame.size.height) + between;
            }
        }
            break;
            
    }
}

- (CGRect) l_transfterFrame:(CGRect)frame withNow:(CGFloat)now{
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            frame.origin.y = now;
            break;
        case UICollectionViewScrollDirectionVertical:
            frame.origin.x = now;
            break;
        default:
            break;
    }
    return frame;
}

@end
