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
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NYTMediaDetailView" bundle:nil] forSupplementaryViewOfKind:@"detailView" withReuseIdentifier:@"detailView"];
    //[self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:@"detailView" withReuseIdentifier:@"detailView"];
    
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (CGSizeEqualToSize(self.view.frame.size, size)) {
        return;
    }
    
    [self.collectionViewLayout invalidateLayout];    
}

#pragma mark - UICollectionViewDelegate

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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"detailView" forIndexPath:indexPath];
    [view setNeedsUpdateConstraints];
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return CGSizeMake(300, 300);
    }
    
    return CGSizeMake(100, 100);
}

@end
