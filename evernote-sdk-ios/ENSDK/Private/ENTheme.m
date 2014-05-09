//
//  ENTheme.m
//  evernote-sdk-ios
//
//  Created by Eric Cheng on 4/16/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#import "ENTheme.h"

@implementation ENTheme

+(UIColor*)defaultTintColor {
    return [UIColor colorWithRed:45.0/255.0 green:190/255.0 blue:96/255.0 alpha:1.0];
}

+(UIColor*)defaultBackgroundColor {
    return [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
}

+(UIColor*)defaultBusinessColor {
    return [UIColor colorWithRed:77.0/255 green:129.0/255 blue:140.0/255 alpha:1];
}

+(UIColor*)defaultShareColor {
    return [UIColor colorWithWhite:0.302 alpha:0.800];
}

BOOL IsIPad() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

@end
