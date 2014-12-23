//
//  NYTMediaGridLayout.h
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

@import UIKit;

@protocol NYTMediaGridLayoutDelegate <UICollectionViewDelegateFlowLayout>

@end

@interface NYTMediaGridLayout : UICollectionViewLayout

@property (nonatomic) CGFloat verticalRowSpacing;

@property (nonatomic) CGSize itemSize;

@end
