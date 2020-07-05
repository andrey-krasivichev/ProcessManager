//
//  Authorization.m
//  ProcessService
//
//  Created by Andrey Krasivichev on 04.07.2020.
//  Copyright © 2020 Andrey Krasivichev. All rights reserved.
//

#import "Authorization.h"
#import <ServiceManagement/ServiceManagement.h>
#import "PrivilegedHelperProtocol.h"

@interface Authorization ()
@property (atomic, strong, readwrite) NSXPCConnection *privilegedHelperConnection;
@end

@implementation Authorization {
    AuthorizationRef _authRef;
}

- (BOOL)installHelperTool {
    BOOL result = NO;

    AuthorizationItem authItem      = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
    AuthorizationRights authRights  = { 1, &authItem };
    AuthorizationFlags flags        =   kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;

    AuthorizationRef authRef = self->_authRef;
    CFErrorRef error;
    
    if (authRef == NULL) {
        /* Obtain the right to install privileged helper tools (kSMRightBlessPrivilegedHelper). */
        OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
        if (status != errAuthorizationSuccess) {
            return result;
        }
    }
    
    result = SMJobBless(kSMDomainSystemLaunchd, CFSTR("com.krasivichev.andrey.PrivilegedHelper"), authRef, &error);
    self->_authRef = authRef;
    return result;
}

- (void)killProcessWithId:(pid_t)pid reply:(void(^)(NSString *))reply {
    id <PrivilegedHelperProtocol> helper = [self.privilegedHelperConnection remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        
    }];
    
    if (!helper) {
        if (![self installHelperTool]) {
            reply(@"You must provide privileges for this operation.");
            return;
        }
    }
    
    [self setupHelperConnectionIfNeeded];
    
    helper = [self.privilegedHelperConnection remoteObjectProxyWithErrorHandler:^(NSError * _Nonnull error) {
        NSString *errorDescription = [NSString stringWithFormat:@"connect failed: %@ / %d", [error domain], (int) [error code]];
        reply(errorDescription);
    }];
    
    [helper killProcessWithId:pid reply:reply];
}

- (void)setupHelperConnectionIfNeeded {
    if (self.privilegedHelperConnection) {
        return;
    }
    
    self.privilegedHelperConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.krasivichev.andrey.PrivilegedHelper"
                                                                               options:NSXPCConnectionPrivileged];
    self.privilegedHelperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(PrivilegedHelperProtocol)];
    __weak typeof(self) weakSelf = self;
    self.privilegedHelperConnection.invalidationHandler = ^{
        weakSelf.privilegedHelperConnection.invalidationHandler = nil;
        weakSelf.privilegedHelperConnection = nil;
    };
    
    [self.privilegedHelperConnection resume];
}

@end
