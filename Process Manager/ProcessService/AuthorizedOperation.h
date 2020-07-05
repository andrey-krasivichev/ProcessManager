//
//  Authorization.h
//  ProcessService
//
//  Created by Andrey Krasivichev on 04.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizedOperation : NSObject
- (void)killProcessWithId:(pid_t)pid reply:(void(^)(NSString *))reply;
@end

NS_ASSUME_NONNULL_END
