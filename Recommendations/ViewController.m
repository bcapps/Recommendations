//
//  ViewController.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "ViewController.h"
#import <FSQCollectionViewAlignedLayout/FSQCollectionViewAlignedLayout.h>

@interface ViewController () <FSQCollectionViewDelegateAlignedLayout>
@property (weak, nonatomic) IBOutlet FSQCollectionViewAlignedLayout *alignedLayout;

@property (weak, nonatomic) IBOutlet FSQCollectionViewAlignedLayout *flowLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alignedLayout.defaultSectionAttributes = [FSQCollectionViewAlignedLayoutSectionAttributes topLeftAlignment];
    self.alignedLayout.defaultCellSize = CGSizeMake(150, 150);
    self.alignedLayout.defaultCellAttributes = [FSQCollectionViewAlignedLayoutCellAttributes defaultCellAttributes];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(200, 200);
}

@end
