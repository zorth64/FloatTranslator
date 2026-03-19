//
//  TranslationBridge.h
//  Float Translator
//
//  Created by zorth64 on 05/03/26.
//

#import <Cocoa/Cocoa.h>

@interface TranslationBridge : NSObject

+ (NSViewController *)makeTranslationController:(NSString *)text;

@end

