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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Workshop <NSObject>

/*!
 做面包
 @param flour 面粉
 */
- (void)makingBread:(NSString *)flour;

@end

@interface Bakery : NSObject

/*!
 面包师
 */
@property (nonatomic, weak) id<Workshop> baker;

#pragma mark -

/*!
 开门
 @return 面包店的实体
 */
+ (instancetype)open;

/*!
 下单
 */
- (void)order;

#pragma mark -

/*!
 面包师上班，进入作坊做面包
 @param baker 面包师
 @param makingBread 做面包的过程
 @see flour 面粉
 */
- (void)bakerStartWork:(id)baker enterWorkshop:(nonnull void (^)(NSString *flour))makingBread;

/*!
 面包师下班
 @discussion 面包师已经下班，扔掉他所做的面包，详见 Bakery.m 第 124 行
 @param baker 面包师
 */
//- (void)bakerOffWork:(id)baker;

@end

NS_ASSUME_NONNULL_END
