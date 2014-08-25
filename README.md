QueueUploading
==============

This is class in Objective-C that let you upload several files to server with Queue operation and progress.
 
How To Use:

Import the Class :
#import "HTTPRequest.h"

Then include the HTTPRequestDelegate
@interface ViewController ()<HTTPRequestDelegate>

Create HTTPRequest’s Object type:
@property (nonatomic, strong)HTTPRequest *request;


Init the request Object:
request = [[HTTPRequest alloc]initWithDelegate:self];

Add file to upload:
[request addFileToUpload:@"test1" filePath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];

* first Var (@“test1”) is file’s Key, you can use in file’s name for this area *
** 2nd Var is file’s Path, just get your file full path and add it there **
*** you can use this Method to add more files to the Queue During uploading progress:

Example:
- (IBAction)addFile:(id)sender {
    
    [request addFileToUpload:@“fileName” filePath:fileFullPath];
}  


