//
//  ProcessNameRetriever.m
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <unistd.h>
#import <string.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <sys/types.h>
#import <pwd.h>

@implementation NSString (ProcessName)

+ (NSString *)nameForProcessWithPID:(pid_t) pidNum {
    NSString *returnString = nil;
    int mib[4], maxarg = 0, numArgs = 0;
    size_t size = 0;
    char *args = NULL, *namePtr = NULL, *stringPtr = NULL;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_ARGMAX;
    
    size = sizeof(maxarg);
    if ( sysctl(mib, 2, &maxarg, &size, NULL, 0) == -1 ) {
    return nil;
    }
    
    args = (char *)malloc( maxarg );
    if ( args == NULL ) {
    return nil;
    }
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROCARGS2;
    mib[2] = pidNum;
    
    size = (size_t)maxarg;
    if ( sysctl(mib, 3, args, &size, NULL, 0) == -1 ) {
    free( args );
    return nil;
    }
    
    memcpy( &numArgs, args, sizeof(numArgs) );
    stringPtr = args + sizeof(numArgs);
    
    if ( (namePtr = strrchr(stringPtr, '/')) != NULL ) {
    *namePtr++;
    returnString = [[NSString alloc] initWithUTF8String:namePtr];
    } else {
    returnString = [[NSString alloc] initWithUTF8String:stringPtr];
    }
    
    return returnString;
}

@end
