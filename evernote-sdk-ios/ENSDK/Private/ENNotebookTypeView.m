//
//  ENNotebookTypeView.m
//  evernote-sdk-ios
//
//  Created by Eric Cheng on 5/9/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENNotebookTypeView.h"
#import "ENTheme.h"

static CGFloat const kCircleRadius = 13;

@implementation ENNotebookTypeView {
    UIImageView *_imageView;
    UIColor *_circleColor;
    UIColor *_circleBorderColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setIsBusiness:(BOOL)isBusiness {
    _isBusiness = isBusiness;
    UIImage* notebookTypeIcon = isBusiness? [UIImage imageNamed:@"ENSDKResources.bundle/ENBusinessIcon"] : [UIImage imageNamed:@"ENSDKResources.bundle/ENMultiplePeopleIcon"];
    _imageView.image = [notebookTypeIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_imageView sizeToFit];
    [self updateNotebookTypeIconColor];
    [self setNeedsLayout];
    [self setNeedsDisplay];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.center = CGPointMake(floorf(CGRectGetMidX(self.bounds)), floorf(CGRectGetMidY(self.bounds)));
}

- (void)drawRect:(CGRect)rect
{
    CGPoint imageCenter = _imageView.center;
    CGFloat radius = kCircleRadius;
    
    CGPoint circleOrigin = CGPointMake(imageCenter.x - radius, imageCenter.y - radius);
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectIntegral(CGRectMake(circleOrigin.x, circleOrigin.y, radius*2, radius*2))];
    
    UIColor* circleColor = _circleColor;
    UIColor* circleBorderColor = _circleBorderColor;
    
    if([self tintAdjustmentMode] == UIViewTintAdjustmentModeDimmed){
        circleBorderColor = [self tintColor];
        circleColor = [circleColor colorWithAlphaComponent:0.6];
    }
    
    [circleBorderColor setStroke];
    [path setLineWidth:1];
    [path stroke];
    
    if(circleColor != nil){
        [circleColor setFill];
        [path fill];
    }
}

- (void)updateNotebookTypeIconColor {
    _imageView.tintColor = _isBusiness? [ENTheme defaultBusinessColor] : [ENTheme defaultShareColor];
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    [self updateThemeColors];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self updateThemeColors];
}

- (void)updateThemeColors{
    _circleBorderColor = [[ENTheme defaultShareColor] colorWithAlphaComponent:0.08];
    _circleColor = [_circleBorderColor colorWithAlphaComponent:0.03];
}

@end
