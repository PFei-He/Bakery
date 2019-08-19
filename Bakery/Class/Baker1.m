//
//  Copyright (c) 2019 faylib.top
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "Baker1.h"
#import "Customer.h"

@interface Baker1 () <Workshop>

@end

@implementation Baker1

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 等待订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makingBreadNotification:) name:@"kMakingBreadNotification" object:nil];
    
    Customer *customer = (Customer *)[UIApplication sharedApplication].delegate;
    
    // 面包师上班后等待顾客下单
    customer.bakery.baker = self;
    
    // 面包师上班后马上开始做面包
    __weak __typeof__(self) weakSelf = self;
    [customer.bakery bakerStartWork:self enterWorkshop:^(NSString * _Nonnull flour) {
        __typeof__(weakSelf) self = weakSelf;
        
        // 上班时做好的面包
        NSLog(@"%@ use %@ making bread1! -[ Block ]-", self.classForCoder, flour);
    }];
}

#pragma mark -

// 顾客已经下单，面包师开始做面包
- (void)makingBreadNotification:(NSNotification *)notification
{
    // 拿到面粉
    NSString *flour = notification.object;
    
    // 新鲜出炉的面包
    NSLog(@"%@ use %@ making bread1! -[ Notification ]-", self.classForCoder, flour);
}

#pragma mark -

// 顾客已经下单，面包师开始做面包
- (void)makingBread:(NSString *)flour
{
    // 新鲜出炉的面包
    NSLog(@"%@ use %@ making bread1! -[ Delegate ]-", self.classForCoder, flour);
}

@end
