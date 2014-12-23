//
//  ViewController.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "ViewController.h"
#import "NYTMediaGridLayout.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NYTMediaGridLayout *alignedLayout;

@property (nonatomic) BOOL cellWasSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.alignedLayout.defaultSectionAttributes = [FSQCollectionViewAlignedLayoutSectionAttributes topLeftAlignment];
//    self.alignedLayout.defaultCellSize = CGSizeMake(150, 150);
//    self.alignedLayout.defaultCellAttributes = [FSQCollectionViewAlignedLayoutCellAttributes defaultCellAttributes];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (CGSizeEqualToSize(self.view.frame.size, size)) {
        return;
    }
    
    [self.collectionViewLayout invalidateLayout];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    self.cellWasSelected = cell.isSelected;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellWasSelected) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }

    [self.collectionView setCollectionViewLayout:[[NYTMediaGridLayout alloc] init] animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView setCollectionViewLayout:[[NYTMediaGridLayout alloc] init] animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return CGSizeMake(300, 300);
    }
    
    return CGSizeMake(100, 100);
}

@end
