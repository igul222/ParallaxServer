//
//  AppDelegate.h
//  ServerApp
//
//  Created by Ishaan Gulrajani on 2/2/13.
//  Copyright (c) 2013 Ishaan Gulrajani. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncUdpSocket.h"

typedef struct _Point3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
} Point3D;

@interface AppDelegate : NSObject <NSApplicationDelegate, AsyncUdpSocketDelegate> {
    AsyncUdpSocket *socket;
    NSMutableDictionary *deviceData;
}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *pointer3;
@property (weak) IBOutlet NSImageView *pointer2;
@property (weak) IBOutlet NSImageView *pointer1;

-(void)refreshPointer;

@end
