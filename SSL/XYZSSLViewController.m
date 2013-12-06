//
//  DebugViewController.m
//  iBBVA
//
//  Created by Paul Von Schrottky on 12/6/13.
//  Copyright (c) 2013 Francisco Santa Cruz. All rights reserved.
//

#import "XYZSSLViewController.h"

@interface XYZSSLViewController ()

@property (retain, nonatomic) NSMutableData *resultData;
@property (retain, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XYZSSLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.resultData = [[NSMutableData alloc] init];
    
    //Create a URL object.
    NSString *fullURL = @"https://www.roshka.com/ItauGW/";
//    NSString *fullURL = @"www.google.com";
    self.url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:requestObj];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:requestObj delegate:self];
    [connection start];
    
//    NSString *fullURL = @"http://conecode.com";
//    NSURL *url = [NSURL URLWithString:fullURL];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:requestObj];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    else
    {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *htmlString = [[NSString alloc] initWithBytes:[self.resultData bytes] length:[self.resultData length] encoding:NSUTF8StringEncoding];
    [self.webView loadHTMLString:htmlString baseURL:self.url];
}
@end
