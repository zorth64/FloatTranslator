//
//  TranslationBridge.cpp
//  Float Translator
//
//  Created by zorth64 on 05/03/26.
//

#import "TranslationBridge.h"

@implementation TranslationBridge

+ (NSViewController *)makeTranslationController:(NSString *)text
{
    Class cls = NSClassFromString(@"LTUITranslationViewController");
    if (!cls)
        return [NSViewController new];

    id controller = [[cls alloc] init];

    NSAttributedString *attr =
        [[NSAttributedString alloc] initWithString:text];

    SEL selector = NSSelectorFromString(@"setText:");

    if ([controller respondsToSelector:selector]) {
        [controller performSelector:selector withObject:attr];
    }
    
    CGSize size = NSMakeSize(550, 350);
    NSValue *sizeValue = [NSValue valueWithSize:size];
    
    selector = NSSelectorFromString(@"setPreferredContentSize:");

    if ([controller respondsToSelector:selector]) {
        [controller performSelector:selector withObject:sizeValue];
    }
    
    selector = NSSelectorFromString(@"expandSheet:");
    
    if ([controller respondsToSelector:selector]) {
        [controller performSelector:selector];
    }

    return controller;
}

@end
