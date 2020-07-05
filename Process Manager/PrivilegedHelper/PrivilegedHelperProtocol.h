//
//  PrivilegedHelperProtocol.h
//  Process Manager
//
//  Created by Andrey Krasivichev on 04.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PrivilegedHelperProtocol <NSObject>
- (void)getVersionWithReply:(void(^)(NSString * version))reply;
- (void)killProcessWithId:(pid_t)pid reply:(void(^)(NSString * answer))reply;
@end

NS_ASSUME_NONNULL_END
