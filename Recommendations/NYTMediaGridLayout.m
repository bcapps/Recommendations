//
//  NYTMediaGridLayout.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "NYTMediaGridLayout.h"
#import "NYTMediaGridLayoutSection.h"

const CGFloat NYTMediaGridLayoutSelectedSupplementaryViewHeight = 300;

@interface NYTMediaGridLayout ()

@property (nonatomic) NSArray *layoutSections;

@property (nonatomic) NSIndexPath *selectedItemIndexPath;
@property (nonatomic) UICollectionViewLayoutAttributes *selectedItemAttributes;

@property (nonatomic) CGFloat contentHeight;

@end

@implementation NYTMediaGridLayout

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}

- (void)commonInitialization {
    _itemSize = CGSizeMake(100, 100);
    _verticalRowSpacing = 10;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
        return NO;
    }
    
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.selectedItemIndexPath = nil;
    self.selectedItemAttributes = nil;
    
    const CGFloat minimumItemWidth = 100;
    
    CGFloat currentOverallYValue = 0;
    
    NSMutableArray *layoutSections = [NSMutableArray array];
    
    NSUInteger numberOfColumns = CGRectGetWidth(self.collectionView.bounds) / minimumItemWidth;
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    
    for (NSUInteger section = 0; section < numberOfSections; section++) {
        NYTMediaGridLayoutSection *layoutSection = [[NYTMediaGridLayoutSection alloc] init];
        NSUInteger currentColumn = 0;
        CGFloat maximumHeightForLine = 0;
        
        CGFloat currentSectionYValue = 0;
        
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *cellsLayoutAttributes = [NSMutableArray array];
        
        BOOL shouldIncreaseNextColumnHeightForSelection = NO;
        
        for (NSUInteger item = 0; item < numberOfItems; item++) {
            if (currentColumn == numberOfColumns) {
                currentSectionYValue += maximumHeightForLine;
                
                if (shouldIncreaseNextColumnHeightForSelection) {
                    UICollectionViewLayoutAttributes *selectedAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"detailView" withIndexPath:self.selectedItemIndexPath];
                    selectedAttributes.frame = CGRectMake(0, currentSectionYValue, CGRectGetWidth(self.collectionView.bounds), NYTMediaGridLayoutSelectedSupplementaryViewHeight);
                    self.selectedItemAttributes = selectedAttributes;
                    
                    currentSectionYValue += NYTMediaGridLayoutSelectedSupplementaryViewHeight;
                    
                    shouldIncreaseNextColumnHeightForSelection = NO;
                }
                
                currentSectionYValue += self.verticalRowSpacing;
                
                maximumHeightForLine = 0;
                currentColumn = 0;
            }
            
            CGFloat columnWidth = CGRectGetWidth(self.collectionView.bounds) / numberOfColumns;
            
            CGSize itemSize = self.itemSize;
            
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];

            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                itemSize = [(id<NYTMediaGridLayoutDelegate>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:itemIndexPath];
            }
            
            itemSize.width = MIN(columnWidth, itemSize.width);
            
            if ([self.collectionView cellForItemAtIndexPath:itemIndexPath].isSelected) {
#warning Do supplementary view layout here.
                self.selectedItemIndexPath = itemIndexPath;
                shouldIncreaseNextColumnHeightForSelection = YES;
            }
            
            CGFloat columnStartingX = currentColumn * columnWidth;
            CGFloat itemXValue = columnStartingX + (columnWidth / 2.0 - itemSize.width / 2.0);
            
            UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:item inSection:section]];
            layoutAttributes.frame = CGRectMake(itemXValue, currentSectionYValue, itemSize.width, itemSize.height);
            [cellsLayoutAttributes addObject:layoutAttributes];
            
            if (itemSize.height > maximumHeightForLine) {
                maximumHeightForLine = itemSize.height;
            }
            
            currentColumn++;
        }
        
        currentSectionYValue += maximumHeightForLine;
        
        layoutSection.sectionRect = CGRectMake(0, currentOverallYValue, CGRectGetWidth(self.collectionView.bounds), currentSectionYValue);
        layoutSection.cellsLayoutAttributes = cellsLayoutAttributes;
        [layoutSections addObject:layoutSection];
        
        currentOverallYValue += currentSectionYValue;
    }

    self.layoutSections = layoutSections;
    self.contentHeight = currentOverallYValue;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.layoutSections[indexPath.section] cellsLayoutAttributes][indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    return self.selectedItemAttributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)targetRect {
    NSMutableArray *matchingLayoutAttributes = [NSMutableArray array];
    
    CGRect contentRect = CGRectMake(0, 0, self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    
    if (!CGRectIntersectsRect(targetRect, contentRect)) {
        // Outside our bounds, so return nil!
        return nil;
    }
    else if (CGRectContainsRect(targetRect, contentRect)) {
        // Just return everything!
        for (NYTMediaGridLayoutSection *layoutSection in self.layoutSections) {
            [matchingLayoutAttributes addObjectsFromArray:layoutSection.cellsLayoutAttributes];
        }
    }
    else if (CGRectGetMinY(targetRect) <= 0) {
        // Just start at the beginning and go up until it doesn't intersect
        for (NYTMediaGridLayoutSection *layoutSection in self.layoutSections) {
            if (!CGRectIntersectsRect(targetRect, layoutSection.sectionRect)) {
                break;
            }
            
            [matchingLayoutAttributes addObjectsFromArray:layoutSection.cellsLayoutAttributes];
        }
    }
    else if (CGRectGetMaxY(targetRect) >= self.collectionViewContentSize.height) {
        // Just start at the end and go down until it doesn't intersect
        for (NYTMediaGridLayoutSection *layoutSection in [self.layoutSections reverseObjectEnumerator]) {
            if (!CGRectIntersectsRect(targetRect, layoutSection.sectionRect)) {
                break;
            }
            
            [matchingLayoutAttributes addObjectsFromArray:layoutSection.cellsLayoutAttributes];
        }
    }
    else {
        // Do a double binary search to figure out the range of sections that intersect the rect
        NSRange sectionRange = [self sectionRangeForRect:targetRect minSearchIndex:0 maxSearchIndex:(self.layoutSections.count - 1)];
        
        [self.layoutSections enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:sectionRange] options:0 usingBlock:^(NYTMediaGridLayoutSection *layoutSection, NSUInteger idx, BOOL *stop) {
            
            for (UICollectionViewLayoutAttributes *cellAttributes in layoutSection.cellsLayoutAttributes) {
                if (CGRectIntersectsRect(cellAttributes.frame, targetRect)) {
                    [matchingLayoutAttributes addObject:[cellAttributes copy]];
                }
            }
        }];
    }
    
    if (self.selectedItemAttributes) {
        if (CGRectIntersectsRect(self.selectedItemAttributes.frame, targetRect)) {
            [matchingLayoutAttributes addObject:self.selectedItemAttributes];
        }
    }
    
    return matchingLayoutAttributes;
}

#pragma mark - Stolen methods from Foursquare

NSComparisonResult compareCGRectMinYIntersection(CGRect targetRect, CGRect comparisonRect) {
    // Target rect minY is either above, inside, or below us.
    if (CGRectGetMinY(targetRect) < CGRectGetMinY(comparisonRect)) {
        // Lower bound is above our rect
        return NSOrderedAscending;
    }
    else if (CGRectGetMinY(targetRect) > CGRectGetMaxY(comparisonRect)) {
        // Lower bound is below our rect
        return NSOrderedDescending;
    }
    else {
        // Lower bound is inside our rect
        return NSOrderedSame;
    }
}

NSComparisonResult compareCGRectMaxYIntersection(CGRect targetRect, CGRect comparisonRect) {
    // Target rect maxY is either above, inside, or below us.
    if (CGRectGetMaxY(targetRect) < CGRectGetMinY(comparisonRect)) {
        // Upper bound is above our rect
        return NSOrderedAscending;
    }
    else if (CGRectGetMaxY(targetRect) > CGRectGetMaxY(comparisonRect)) {
        // Upper bound is below our rect
        return NSOrderedDescending;
    }
    else {
        // Upper bound is inside our rect
        return NSOrderedSame;
    }
}

typedef NSComparisonResult (^SearchComparisonBlock)(NSUInteger currentSearchIndex);

NSUInteger boundIndexWithComparisonBlock(SearchComparisonBlock comparisonBlock, NSUInteger minSearchIndex, NSUInteger maxSearchIndex) {
    if (minSearchIndex == maxSearchIndex) {
        return minSearchIndex;
    }
    NSUInteger currentSearchSectionIndex = minSearchIndex + ((maxSearchIndex - minSearchIndex) / 2);
    NSComparisonResult comparisonResult = comparisonBlock(currentSearchSectionIndex);
    switch (comparisonResult) {
        case NSOrderedAscending:
            if (currentSearchSectionIndex == minSearchIndex) {
                return currentSearchSectionIndex;
            }
            else {
                return boundIndexWithComparisonBlock(comparisonBlock, minSearchIndex, (currentSearchSectionIndex - 1));
            }
        case NSOrderedDescending:
            if (currentSearchSectionIndex == maxSearchIndex) {
                return currentSearchSectionIndex;
            }
            else {
                return boundIndexWithComparisonBlock(comparisonBlock, (currentSearchSectionIndex + 1), maxSearchIndex);
            }
        case NSOrderedSame:
            // Inside this section
            return currentSearchSectionIndex;
        default:
            NSCAssert(0, @"FSQCollectionViewAlignedLayout: Unexpected value (%ld) in boundIndexWithComparisonBlock comparison result", (long)comparisonResult);
            return 0;
    }
}

- (NSRange)sectionRangeForRect:(CGRect)targetRect minSearchIndex:(NSUInteger)minSearchIndex maxSearchIndex:(NSUInteger)maxSearchIndex {
    if (minSearchIndex == maxSearchIndex) {
        return NSMakeRange(minSearchIndex, 1);
    }
    
    // Concurrently seach for upper and lower bound!
    __block NSUInteger lowerBoundIndex = 0;
    __block NSUInteger upperBoundIndex = 0;
    
    dispatch_group_t searchGroup = dispatch_group_create();
    dispatch_queue_t searchQueue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(searchGroup, searchQueue, ^{
        lowerBoundIndex = boundIndexWithComparisonBlock(^NSComparisonResult(NSUInteger currentSearchIndex) {
            return compareCGRectMinYIntersection(targetRect, [self.layoutSections[currentSearchIndex] sectionRect]);
        }, minSearchIndex, maxSearchIndex);
    });
    dispatch_group_async(searchGroup, searchQueue, ^{
        upperBoundIndex = boundIndexWithComparisonBlock(^NSComparisonResult(NSUInteger currentSearchIndex) {
            return compareCGRectMaxYIntersection(targetRect, [self.layoutSections[currentSearchIndex] sectionRect]);
        }, minSearchIndex, maxSearchIndex);
    });
    dispatch_group_wait(searchGroup, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1));
    
    lowerBoundIndex = MAX(minSearchIndex, lowerBoundIndex);
    upperBoundIndex = MIN(maxSearchIndex, upperBoundIndex);
    
    return NSMakeRange(lowerBoundIndex, (upperBoundIndex - lowerBoundIndex) + 1);
}

@end

