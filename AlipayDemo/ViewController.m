//
//  ViewController.m
//  AlipayDemo
//
//  Created by 郭文魁 on 15/5/24.
//  Copyright (c) 2015年 郭文魁. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "Order.h"

#import <AlipaySDK/AlipaySDK.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Alipay:(id)sender {
    
    
    NSString *appScheme = @"AlipayDemo";
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSDictionary *parameters = @{@"merdate":@"20141209",
                                 @"orderno":@"1234567890987654321",
                                 @"amount":@"1",
                                 @"goodsname":@"医保",
                                 @"goodsinf":@"医保支付",
                                 @"paytype":@"2",
                                 @"userid":@"1",
                                 @"jzbh":@"jzbh",
                                 @"recordno":@"100001"};
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET: @"http://218.80.250.95:97/ybpay/upay/yunorderinfos" parameters:parameters success:^(AFHTTPRequestOperation *operation,id responseObject){
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSString *mysigncod = result[@"mysigncod"];
            NSString *orderInfo = result[@"orderInfo"];
            
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderInfo, mysigncod, @"RSA"];
            
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"AlipayDemo" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
        
        NSLog(@"res%@",result);
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"fail");
    }];

    
    
}

@end
