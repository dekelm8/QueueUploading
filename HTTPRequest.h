//
//  HTTPRequest.h
//  HTTPRequestProject
//
//  Created by Hackeru Hackeru on 5/21/14.
//  Copyright (c) 2014 HackerU. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPResult;
@class HTTPRequest;
@class HTTPProgress;

@protocol HTTPRequestDelegate <NSObject>
/*!
 On HTTPRequest Finish.
 @param The request itself.
 @param The request result.
 */
- (void) request:(HTTPRequest *)request finishedWithResult:(HTTPResult *)result;
- (void) request:(HTTPRequest *)request updateWithProgress:(HTTPProgress *)progress;

@end

@interface HTTPRequest : NSObject


@property (nonatomic, strong) HTTPResult *requestResult;
@property (nonatomic, strong) HTTPProgress *requestProgress;
@property (nonatomic, strong) NSString *uploadFilePath;
@property (nonatomic, strong) NSMutableDictionary *filePathAndKeysDictionary;

@property (nonatomic, strong) id <HTTPRequestDelegate> requestDelegate;


//Init Methods

- (id) initWithDelegate:(id <HTTPRequestDelegate>)delegate;

+ (id) requestWithDelegate:(id <HTTPRequestDelegate>)delegate;

//Start Methods
- (void) startSync:(BOOL)sync;


//Request Arguments Methods

- (void) addFileToUpload:(NSString *)fileName filePath:(NSString *)filePath;



@end

@interface HTTPResult : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSError *error;

@end


@interface HTTPProgress : NSObject
@property (nonatomic) float progress;
@end
