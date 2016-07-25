//
//  TouchIDManager.m
//  BCG
//
//  Created by Ryan Jake Castro on 2/29/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "TouchIDManager.h"
#import "EHFAuthenticator.h"

static TouchIDManager *_instance = nil;

@interface TouchIDManager ()

@end

@implementation TouchIDManager

+ (instancetype)sharedTouchIDManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[EHFAuthenticator sharedInstance] setReason:@"To sign you into the application"];
        [[EHFAuthenticator sharedInstance] setFallbackButtonTitle:@"Enter Password"];
        [[EHFAuthenticator sharedInstance] setUseDefaultFallbackTitle:YES];
    }
    return self;
}

- (NSString *)canAuthenticate
{
    NSError *error = nil;
    NSString * authErrorString = @"Check your Touch ID Settings.";
    if (![EHFAuthenticator canAuthenticateWithError:&error]) {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
    }
    return authErrorString;
}

- (void)authenticateWithSuccessHandler:(dispatch_block_t)successHandler error:(dispatch_block_t)errorHandler viewController:(UIViewController *)viewController
{
    [[EHFAuthenticator sharedInstance] authenticateWithSuccess:^(){
        
        [self presentAlertControllerWithMessage:@"Successfully Authenticated!" viewController:viewController];
        
        successHandler();
        
    } andFailure:^(LAError errorCode){
        
        NSString * authErrorString;
        switch (errorCode) {
            case LAErrorSystemCancel:
                authErrorString = @"System canceled auth request due to app coming to foreground or background.";
                break;
            case LAErrorAuthenticationFailed:
                authErrorString = @"User failed after a few attempts.";
                break;
            case LAErrorUserCancel:
                authErrorString = @"User cancelled.";
                break;
                
            case LAErrorUserFallback:
                authErrorString = @"Fallback auth method should be implemented here.";
                break;
            case LAErrorTouchIDNotEnrolled:
                authErrorString = @"No Touch ID fingers enrolled.";
                break;
            case LAErrorTouchIDNotAvailable:
                authErrorString = @"Touch ID not available on your device.";
                break;
            case LAErrorPasscodeNotSet:
                authErrorString = @"Need a passcode set to use Touch ID.";
                break;
            default:
                authErrorString = @"Check your Touch ID Settings.";
                break;
        }
        [self presentAlertControllerWithMessage:authErrorString viewController:viewController];

        errorHandler();
    }];

}

- (void)presentAlertControllerWithMessage:(NSString *)message viewController:(UIViewController *)viewController
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Touch ID" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


@end
