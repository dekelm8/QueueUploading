QueueUploading
==============

Objective-C class for uploading files to server with Queue Operation and uploading progress 

HOW TO USE:

First go into HTTPRequest.m File and insert your Domain in BASEURL #typedef and the php file name (the php file that include the server code for handling with the received files)

    #define kUrlUploadFiles @"scriptgettingfiles.php"
    #define K_BASE_URL @"http://www.yourdomain.com"

Import the class:

    #import "HTTPRequest.h"


Then include the HTTPRequestDelegate<br>

    @interface ViewController ()<HTTPRequestDelegate>

Create HTTPRequest’s Object type:

    @property (nonatomic, strong)HTTPRequest *request;

Init the request Object:<br>

    request = [[HTTPRequest alloc]initWithDelegate:self];

Add file to upload:

    [request addFileToUpload:@"test1" filePath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];

* first Var (@“test1”) is file’s Key, you can use in file’s name for this area *<br>
** 2nd Var is file’s Path, just get your file full path and add it there **<br>
*** you can use this Method to add more files to the Queue During uploading progress:

Example:
  
    - (IBAction)addFile:(id)sender {
    
      [request addFileToUpload:@“fileName” filePath:fileFullPath];
    }  



