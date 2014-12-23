//
//  NYTMediaDetailView.m
//  Recommendations
//
//  Created by Brian Capps on 12/22/14.
//  Copyright (c) 2014 NYTimes. All rights reserved.
//

#import "NYTMediaDetailView.h"
#import "NYTMediaDetailTableViewController.h"

#define ARROW_HEIGHT    13.0f
#define ARROW_BASE      30.0f

// convert degrees to radians
#define DEG_TO_RAD(angle) ((angle)/180.0f * M_PI)

@implementation NYTMediaDetailView

- (void)awakeFromNib {
    _arrowHorizontalCenterValue = CGFLOAT_MAX;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.songDetailViewController = nil;
    self.parentViewController = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer *shapeMask = [[CAShapeLayer alloc] init];
    shapeMask.frame = self.layer.bounds;
    shapeMask.path = [self popoverPathWithRect:self.bounds direction:UIPopoverArrowDirectionUp].CGPath;
    self.layer.mask = shapeMask;
    
    [self layoutChildViewControllerView];
}

- (void)layoutChildViewControllerView {
    self.songDetailViewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setSongDetailViewController:(NYTMediaDetailTableViewController *)childViewController {
    if (_songDetailViewController != childViewController) {
        [self.songDetailViewController willMoveToParentViewController:nil];
        [self.songDetailViewController.view removeFromSuperview];
        [self.songDetailViewController removeFromParentViewController];
        
        _songDetailViewController = childViewController;
        
        if (childViewController) {
            [self.parentViewController addChildViewController:childViewController];
            [self addSubview:childViewController.view];
            [childViewController didMoveToParentViewController:self.parentViewController];
            
            [self layoutChildViewControllerView];
        }
    }
}

- (UIEdgeInsets)edgeInsetsForArrowDirection:(UIPopoverArrowDirection)direction {
    if (direction == UIPopoverArrowDirectionUp) {
        return UIEdgeInsetsMake(ARROW_HEIGHT, 0.0f, 0.0f, 0.0f);
    } else if (direction == UIPopoverArrowDirectionDown) {
        return UIEdgeInsetsMake(0.0f, 0.0f, ARROW_HEIGHT, 0.0f);
    } else if (direction == UIPopoverArrowDirectionLeft) {
        return UIEdgeInsetsMake(0.0f, ARROW_HEIGHT, 0.0f, 0.0f);
    } else if (direction == UIPopoverArrowDirectionRight) {
        return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, ARROW_HEIGHT);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (CGFloat)arrowOffset {
    return 0;
}

- (UIBezierPath *)popoverPathWithRect:(CGRect)rect direction:(UIPopoverArrowDirection)direction {
    if (CGRectIsEmpty(rect)) {
        return nil;
    }
    
    const CGFloat topOfArrowToContentMargin = 1.0;
    
    // corner radius of popover
    CGFloat radius = 0.0;
    
    // edge insets adjusted for arrow direction
    UIEdgeInsets edgeInsets = [self edgeInsetsForArrowDirection:direction];
    
    // setup two rectangles for popover
    CGRect outerRect = UIEdgeInsetsInsetRect(rect, edgeInsets);
    CGRect innerRect = CGRectInset(outerRect, radius, radius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (direction == UIPopoverArrowDirectionUp) {
        CGFloat arrowCenterX = self.arrowHorizontalCenterValue;
        
        if (arrowCenterX == CGFLOAT_MAX) {
            arrowCenterX = CGRectGetMidX(innerRect);
        }
        
        CGFloat arrowEdge = arrowCenterX - (ARROW_BASE / 2.0);
        CGRect arrowRect = CGRectMake(CGRectGetMinX(outerRect) + arrowEdge, CGRectGetMinY(rect) + topOfArrowToContentMargin, ARROW_BASE, ARROW_HEIGHT);
        
        [path moveToPoint:CGPointMake(CGRectGetMinX(innerRect), CGRectGetMinY(outerRect))];
        
        CGPoint arrowLeftEdgePoint = CGPointMake(CGRectGetMinX(arrowRect), CGRectGetMinY(outerRect));
        CGPoint arrowTopPoint = CGPointMake(CGRectGetMidX(arrowRect), CGRectGetMinY(arrowRect));
        CGPoint arrowRightEdgePoint = CGPointMake(CGRectGetMaxX(arrowRect), CGRectGetMinY(outerRect));
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(innerRect), CGRectGetMinY(innerRect))
                        radius:radius startAngle:DEG_TO_RAD(270.0f) endAngle:DEG_TO_RAD(0.0f) clockwise:YES];
        [path addArcWithCenter:CGPointMake(CGRectGetMaxX(innerRect), CGRectGetMaxY(innerRect))
                        radius:radius startAngle:DEG_TO_RAD(0.0f) endAngle:DEG_TO_RAD(90.0f) clockwise:YES];
        [path addArcWithCenter:CGPointMake(CGRectGetMinX(innerRect), CGRectGetMaxY(innerRect))
                        radius:radius startAngle:DEG_TO_RAD(90.0f) endAngle:DEG_TO_RAD(180.0f) clockwise:YES];
        [path addArcWithCenter:CGPointMake(CGRectGetMinX(innerRect), CGRectGetMinY(innerRect))
                        radius:radius startAngle:DEG_TO_RAD(180.0f) endAngle:DEG_TO_RAD(270.0f) clockwise:YES];
        
        
        CGFloat cpLowerOffset = 7;
        CGFloat cpUpperOffset = 5;
        
        UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
        [arrowPath moveToPoint:arrowLeftEdgePoint];
        [arrowPath addCurveToPoint:arrowTopPoint controlPoint1:CGPointMake(arrowLeftEdgePoint.x + cpLowerOffset, arrowLeftEdgePoint.y) controlPoint2:CGPointMake(arrowTopPoint.x - cpUpperOffset, arrowTopPoint.y)];
        [arrowPath addCurveToPoint:arrowRightEdgePoint controlPoint1:CGPointMake(arrowTopPoint.x + cpUpperOffset, arrowTopPoint.y) controlPoint2:CGPointMake(arrowRightEdgePoint.x - cpLowerOffset, arrowRightEdgePoint.y)];
        [arrowPath closePath];
        
        [path appendPath:arrowPath];
    }
    
    return path;
}

@end
