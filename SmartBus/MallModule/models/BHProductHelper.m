//
//  BHProductHelper.m
//  SmartBus
//
//  Created by launching on 13-12-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHProductHelper.h"

@implementation BHProductHelper

@synthesize nodes = __nodes;

- (void)load
{
    __nodes = [[NSMutableArray alloc] initWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(__nodes);
    [super unload];
}

- (void)getProductsAtPage:(NSInteger)page
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [parameters setObject:[NSString stringWithFormat:@"%d", kPageSize] forKey:@"count"];
    [parameters setObject:[BHUtil encrypt:@"1" method:@"MallList"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"MallList" parameters:parameters] )
    .USER_INFO( @"getProducts" )
    .TIMEOUT( 10 );
}

- (void)getProductDescById:(NSInteger)proid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", proid] forKey:@"id"];
    [parameters setObject:str_mid forKey:@"mid"];
    [parameters setObject:[BHUtil encrypt:[NSString stringWithFormat:@"%d", proid] method:@"commodityDetail"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"commodityDetail" parameters:parameters] )
    .USER_INFO( @"getProdDesc" )
    .TIMEOUT( 10 );
}

- (void)exchangeProduct:(NSInteger)proid
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[NSString stringWithFormat:@"%d", proid] forKey:@"id"];
    [parameters setObject:str_mid forKey:@"mid"];
    [parameters setObject:[BHUtil encrypt:[NSString stringWithFormat:@"%d", proid] method:@"exchange"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"exchange" parameters:parameters] )
    .USER_INFO( @"exchange" )
    .TIMEOUT( 10 );
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
    if ( request.succeed )
	{
        NSDictionary *result = [request.responseString objectFromJSONString];
        if ( [result[@"message"][@"code"] integerValue] > 0 )
        {
            NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
            self.succeed = NO;
            return;
        }
        else
        {
            self.succeed = YES;
        }
        
		if ( [request.userInfo is:@"getProducts"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for ( NSDictionary *datainfo in datas )
            {
                BHProductModel *product = [[BHProductModel alloc] init];
                product.prodid = [[datainfo objectForKey:@"id"] integerValue];
                product.pname = [[datainfo objectForKey:@"title"] asNSString];
                product.pcover = [[datainfo objectForKey:@"images"] asNSString];
                product.coin = [[datainfo objectForKey:@"coin"] integerValue];
                [self.nodes addObject:product];
                [product release];
            }
        }
        else if ( [request.userInfo is:@"getProdDesc"] )
        {
            [self.nodes removeAllObjects];
            
            NSDictionary *datainfo = [result objectForKey:@"data"];
            BHProductModel *product = [[BHProductModel alloc] init];
            product.prodid = [[datainfo objectForKey:@"id"] integerValue];
            product.pname = [[datainfo objectForKey:@"title"] asNSString];
            product.coin = [[datainfo objectForKey:@"coin"] integerValue];
            product.pdesc = [[datainfo objectForKey:@"description"] asNSString];
            product.price = [[datainfo objectForKey:@"price"] floatValue];
            product.total = [[datainfo objectForKey:@"total"] integerValue];
            product.photos = [NSMutableArray arrayWithArray:(NSArray *)[datainfo objectForKey:@"images"]];
            [self.nodes addObject:product];
            [product release];
        }
        else if ( [request.userInfo is:@"exchange"] )
        {
            // TODO:
        }
	}
	else if ( request.failed )
	{
		NSLog(@"error :%@", request.error);
	}
}

@end
