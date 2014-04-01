//
//  ENSDKAdvanced.h
//  evernote-sdk-ios
//
//  Created by Ben Zotto on 3/31/14.
//  Copyright (c) 2014 n/a. All rights reserved.
//

#ifndef evernote_sdk_ios_ENSDKAdvanced_h
#define evernote_sdk_ios_ENSDKAdvanced_h
#import "ENSDK.h"
#import "EDAM.h"

typedef enum {
    /** No service */
    EVERNOTE_SERVICE_NONE = 0,
    /** Evernote international only */
    EVERNOTE_SERVICE_INTERNATIONAL = 1,
    /** Evernote China only */
    EVERNOTE_SERVICE_YINXIANG = 2,
    /** Evernote international and China services */
    EVERNOTE_SERVICE_BOTH = 3
} EvernoteService;


#endif
