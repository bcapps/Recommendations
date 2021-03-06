//
//  ViewController.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "ViewController.h"
#import "NYTMediaGridLayout.h"
#import "NYTMediaDetailView.h"
#import "NYTMediaDetailTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NYTMediaGridLayout *alignedLayout;

@property (nonatomic) BOOL cellWasSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NYTMediaDetailView" bundle:nil] forSupplementaryViewOfKind:@"detailView" withReuseIdentifier:@"detailView"];
    
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
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"albumCell" forIndexPath:indexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NYTMediaDetailView *view = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"detailView" forIndexPath:indexPath];
    
    view.arrowHorizontalCenterValue = CGRectGetMidX([[self.alignedLayout layoutAttributesForItemAtIndexPath:indexPath] frame]);
        
    NYTMediaDetailTableViewController *mediaViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mediaDetailTableViewController"];
    view.parentViewController = self;
    view.songDetailViewController = mediaViewController;

    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return CGSizeMake(300, 300);
    }
    
    return CGSizeMake(100, 100);
}

@end
