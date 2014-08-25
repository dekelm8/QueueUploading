//
//  HTTPRequest.m
//  HTTPRequestProject
//
//  Created By Dekel Maman.
//

#import "HTTPRequest.h"


#define kUrlUploadFiles @"scriptgettingfiles.php"
#define K_BASE_URL @"http://www.yourdomain.com"


@interface HTTPRequest () <NSURLConnectionDataDelegate>
//store the request arguments
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *keysArray, *filesPathArray;

//get the data on a-sync request
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic) int uploadedCounter;

//store the block


@end

@implementation HTTPRequest
@synthesize params, requestDelegate, requestResult, mutableData, requestProgress, uploadFilePath;
@synthesize filePathAndKeysDictionary, uploadedCounter, keysArray, filesPathArray;
- (id)init
{
    self = [super init];
    if (self) {
        

        self.params = [[NSMutableDictionary alloc] init];
        self.uploadFilePath = @"";
        keysArray = [[NSMutableArray alloc]init];
        uploadedCounter = 0;
        filesPathArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

//Init Methods



- (id) initWithDelegate:(id <HTTPRequestDelegate>)delegate{
    if (self = [self init]){
        
        self.requestDelegate = delegate;
    }
    return self;
}

+ (id) requestWithType:(id <HTTPRequestDelegate>)delegate{
    
    return [[self alloc]initWithDelegate:delegate];
}

- (void)addFileToUpload:(NSString *)fileName filePath:(NSString *)filePath{
    [keysArray addObject:fileName];
    [filesPathArray addObject:filePath];
    
}

#pragma mark - Send Request Methods
// create NSURLRequest
// No gets, Return NSURLRequest Object
- (NSURLRequest *) createRequest{
    
    NSString *baseURL = K_BASE_URL;
    //Set the full url by requestType selected
    
    
    baseURL = [baseURL stringByAppendingPathComponent:kUrlUploadFiles];
    
    
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    NSMutableData *body= [NSMutableData data]; // Hold the Request's Body Data.
    
    [request setHTTPMethod:@"POST"];
    uploadFilePath = filesPathArray[uploadedCounter];
    
    
    if (![uploadFilePath isEqualToString:@""]) {
        
        // create body data for upload File.
        NSData *dataToUpload = nil;
        NSString *fileType = @"";
        
        
        
        dataToUpload = [NSData dataWithContentsOfFile:uploadFilePath];
            
        
        NSString *appendDataString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".%@\"\r\n", fileType];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[appendDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[appendDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[NSData dataWithData:dataToUpload]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [request setHTTPBody:body];
        
    }


    
    return request;
}

- (void)filesarray{
    
}

-(void)startSync{
    [self startSync:NO];
    
}
- (void) startSync:(BOOL)sync{
    
    if (keysArray.count > 0 && uploadedCounter < keysArray.count) {
        
        NSURLRequest *request = [self createRequest];
        
        
        if (sync){
            NSError *error = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            [self handleData:data error:error];
        } else {
            NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            [connection start];
        }
    }
    
}


- (void) handleData:(NSData *)data error:(NSError *)error{
    id resultData = nil;
    if (error == nil){
        resultData = data;
    }
    
    HTTPResult *result = [[HTTPResult alloc] init];
    result.data = resultData;
    result.error = error;
    
    self.requestResult = result;
    uploadedCounter++;
    NSLog(@"finish %i files", uploadedCounter);
    if (uploadedCounter <= keysArray.count) {
        [self startSync];
    }
    //respond to delegate
    
    else if ([requestDelegate respondsToSelector:@selector(request:finishedWithResult:)]){
        self.keysArray = [NSMutableArray array];
        self.filesPathArray = [NSMutableArray array];
        
        [requestDelegate request:self finishedWithResult:result];
    }
    
    
}

- (void)handleProgress:(float)prog{
    
    HTTPProgress *progress = [[HTTPProgress alloc]init];
    progress.progress = prog;
    self.requestProgress = progress;
    [requestDelegate request:self updateWithProgress:progress];
    
}


#pragma mark - NSURLConnection Data Delegate Methods
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self handleData:nil error:error];
    self.mutableData = nil;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (mutableData == nil){
        self.mutableData = [NSMutableData new];
    }
    [mutableData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [self handleData:mutableData error:nil];
    self.mutableData = nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    float sent = totalBytesWritten;
    float fileSize = totalBytesExpectedToWrite;
    float total = sent/fileSize *100;
    [self handleProgress:total];
    
}


@end
/*
 HTTP Result
 Empty implementation, without it, the project won't be compiled
 */
@implementation HTTPResult
@end

@implementation HTTPProgress
@end
