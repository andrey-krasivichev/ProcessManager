//
//  NSString+ProcessName.h
//  Process Manager
//
//  Created by Andrey Krasivichev on 02.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ProcessName)
+ (nullable NSString *)nameForProcessWithPID:(pid_t) pid;
@end

NS_ASSUME_NONNULL_END
