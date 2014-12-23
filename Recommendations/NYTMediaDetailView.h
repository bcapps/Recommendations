//
//  NYTMediaDetailView.h
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

@import UIKit;
@class NYTMediaDetailTableViewController;

@interface NYTMediaDetailView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

/** The view controller to which the child will be added. View must be a superview of this cell. Always set this before `childViewController` so it can be properly added. */
@property (nonatomic, weak) UIViewController *parentViewController;

/** The view controller whose view will fill this cell. Will be added as a child of `parentViewController`. A custom setter handles all of the appropriate child view controller addition and removal method calls. */
@property (nonatomic) NYTMediaDetailTableViewController *songDetailViewController;



@end
