//
//  AppDelegate.m
//  ServerApp
//
//  Created by Ishaan Gulrajani on 2/2/13.
//  Copyright (c) 2013 Ishaan Gulrajani. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    NSError *err = nil;
    [socket bindToPort:8888 error:&err];
    if(err)
        NSLog(@"Error binding socket! %@ : %@",err,err.userInfo);
    [socket receiveWithTimeout:-1 tag:0];
    
    deviceData = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(refreshPointer)
                                   userInfo:nil
                                    repeats:YES];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port {
    
    NSError *err = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    if(err) {
        NSLog(@"Error decoding JSON: %@ : %@",err,err.userInfo);
        [socket receiveWithTimeout:-1 tag:0];
        return true;
    }
    
//    NSLog(@"Data received from host %@: %@", host, json);
    
    deviceData[host] = json;

    [socket receiveWithTimeout:-1 tag:0];
    return true;
}

-(void)refreshPointer {

    CGFloat x1, y1, x2, y2;
    NSArray *keys = [deviceData allKeys];
    NSRect frame;
    
    if(keys.count >= 1) {
        x1 = [deviceData[keys[0]][@"x"] doubleValue];
        y1 = [deviceData[keys[0]][@"y"] doubleValue];
        
        Point3D p1;
        p1.x = x1;
        p1.y = y1;
        p1.z = 20;
        
        frame.size.width = p1.z;
        frame.size.height = p1.z;
        frame.origin.x = p1.x - (frame.size.width/2);
        frame.origin.y = p1.y - (frame.size.width/2);
        self.pointer1.frame = frame;
    }
    
    if(keys.count >= 2) {
        x2 = [deviceData[keys[0]][@"x"] doubleValue];
        y2 = [deviceData[keys[0]][@"y"] doubleValue];

        Point3D p2;
        p2.x = x2;
        p2.y = y2;
        p2.z = 20;
        
        frame.size.width = p2.z;
        frame.size.height = p2.z;
        frame.origin.x = p2.x - (frame.size.width/2);
        frame.origin.y = p2.y - (frame.size.width/2);
        self.pointer2.frame = frame;
        
        Point3D parallax;
        parallax.x = (x1 + x2)/2;
        parallax.y = ABS(x1 - x2);
        parallax.z = (y1 + y2)/2;
        
        frame.size.width = parallax.z;
        frame.size.height = parallax.z;
        frame.origin.x = parallax.x - (frame.size.width/2);
        frame.origin.y = parallax.y - (frame.size.width/2);
        self.pointer3.frame = frame;
    }
    
}

@end
