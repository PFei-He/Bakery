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

#import "Bakery.h"

// 店里的面包
typedef void(^Bread)(NSString *);

@interface Bakery ()

// 面包店所有上班的面包师
@property (nonatomic, strong) NSPointerArray *allBakers;

// 已经做了面包的面包师
@property (nonatomic, strong) NSMapTable *bakers;

// 已经做好的面包
@property (nonatomic, strong) NSMutableDictionary *breads;

@end

@implementation Bakery

#pragma mark - Getter / Setter Methods

// -
- (NSPointerArray *)allBakers
{
    if (!_allBakers) {
        _allBakers = [NSPointerArray weakObjectsPointerArray];
    }
    return _allBakers;
}

// -
- (NSMapTable *)bakers
{
    if (!_bakers) {
        _bakers = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    return _bakers;
}

// -
- (NSMutableDictionary *)breads
{
    if (!_breads) {
        _breads = [NSMutableDictionary dictionary];
    }
    return _breads;
}

// 招聘面包师
- (void)setBaker:(id<Workshop>)baker
{
    // 加入面包店的阵容
    [self.allBakers addPointer:(__bridge void*)baker];
}

#pragma mark - Public Methods

// 开门
+ (instancetype)open
{
    return [[self alloc] init];
}

// 面包师上班，进入作坊
- (void)bakerStartWork:(id)baker enterWorkshop:(void (^)(NSString * _Nonnull))makingBread
{
    // 已经做过面包的面包师
    [self.bakers setObject:baker forKey:NSStringFromClass([baker classForCoder])];
    
    // 已经做好的面包
    [self.breads setObject:makingBread forKey:NSStringFromClass([baker classForCoder])];
}

/* 详见第 124 行 */
// 面包师下班
//- (void)bakerOffWork:(id)baker
//{
//    // 面包师离开了，对应的面包就不售卖了
//    [self.breads removeObjectForKey:NSStringFromClass([baker classForCoder])];
//}

// 下单
- (void)order
{
    /* --- Notification --- */
    
    // 通知面包师接单
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kMakingBreadNotification" object:@"flour"];
    
    
    /* --- Delegate --- */
    
    // 分派面包师开始做面包
    for (id<Workshop> baker in self.allBakers) {
        [baker makingBread:@"flour"];
    }
    
    
    /* --- Block --- */
    
    /* 按照现实情况，即使面包师下班了，它之前做的面包任然可以售卖，理应使用方法一来执行方法，但在程序中执行时，只要调用者不存在了，就不需要再继续执行对应的方法，所以需要释放掉该回调，故使用方法二 */
    
    /* 方法一 */
    // 已经做好的面包，面包师上班时已经做好，即使面包师下班，仍然可以售卖
//    for (Bread bread in self.breads.allValues) {
//        bread(@"flour");
//    }
    
    /* 方法二 */
    // 如果面包师在上班，提供他所做的面包，如果已经下班，则扔掉他的面包
    __weak __typeof__(self) weakSelf = self;
    [self.breads enumerateKeysAndObjectsUsingBlock:^(id _Nonnull bakers, id _Nonnull breads, BOOL * _Nonnull stop) {
        __typeof__(weakSelf) self = weakSelf;
        if ([[[self.bakers keyEnumerator] allObjects] containsObject:bakers]) {
            // 已经做好的面包
            Bread bread = breads;

            // 提供给客户
            bread(@"flour");
        } else {
            // 扔掉面包
            [self.breads removeObjectForKey:bakers];
        }
    }];
}

@end
