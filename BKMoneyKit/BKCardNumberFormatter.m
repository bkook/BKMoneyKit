//
//  BKCardNumberFormatter.m
//  BKMoneyKit
//
//  Created by Byungkook Jang on 2014. 8. 23..
//  Copyright (c) 2014년 Byungkook Jang. All rights reserved.
//

#import "BKCardNumberFormatter.h"
#import "BKCardPatternInfo.h"
#import "BKMoneyUtils.h"

@interface BKCardNumberFormatter ()

@property (nonatomic, strong) NSSet                 *cardPatterns;
@property (nonatomic, strong) NSRegularExpression   *nonNumericRegularExpression;

@property (nonatomic, strong) NSString              *cachedPrefix;
@property (nonatomic, strong) BKCardPatternInfo     *cardPatternInfo;

@end

@implementation BKCardNumberFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"BKMoneyKit.bundle/CardPatterns" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (NSDictionary *dictionary in array) {
            
            BKCardPatternInfo *pattern = [[BKCardPatternInfo alloc] initWithDictionary:dictionary];
            if (pattern) {
                [mutableArray addObject:pattern];
            }
        }
        
        self.cardPatterns = [NSSet setWithArray:mutableArray];
        self.nonNumericRegularExpression = [BKMoneyUtils nonNumericRegularExpression];
        self.groupSeparater = @" ";
    }
    return self;
}

- (NSString *)stringForObjectValue:(id)obj
{
    if (NO == [obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSString *numberString = [self.nonNumericRegularExpression stringByReplacingMatchesInString:obj
                                                                                      options:0
                                                                                        range:NSMakeRange(0, [obj length])
                                                                                 withTemplate:@""];
    
    BKCardPatternInfo *patternInfo = [self cardPatternInfoWithNumberString:numberString];
    
    if (patternInfo) {
        return [patternInfo groupedStringWithString:numberString groupSeparater:self.groupSeparater maskingCharacter:self.maskingCharacter maskingGroupIndexSet:self.maskingGroupIndexSet];
    } else {
        return numberString;
    }
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error
{
    if (obj) {
        *obj = [self.nonNumericRegularExpression stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
    }
    
    return YES;
}

- (NSString *)formattedStringFromRawString:(NSString *)rawString
{
    return [self stringForObjectValue:rawString];
}

- (NSString *)rawStringFromFormattedString:(NSString *)string
{
    NSString *result = nil;
    NSString *errorDescription = nil;
    if ([self getObjectValue:&result forString:string errorDescription:&errorDescription]) {
        return result;
    } else {
        return nil;
    }
}

- (BKCardPatternInfo *)cardPatternInfoWithNumberString:(NSString *)aNumberString
{
    if (self.cachedPrefix && [aNumberString hasPrefix:self.cachedPrefix] && self.cardPatternInfo) {
        return self.cardPatternInfo;
    }
    
    for (BKCardPatternInfo *patternInfo in self.cardPatterns) {
        
        if ([patternInfo patternMatchesWithNumberString:aNumberString]) {
            
            self.cardPatternInfo = patternInfo;
            self.cachedPrefix = aNumberString;
            
            return patternInfo;
        }
    }
    
    self.cachedPrefix = nil;
    self.cardPatternInfo = nil;
    
    return nil;
}

@end
