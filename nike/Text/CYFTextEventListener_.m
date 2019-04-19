

#import <UIKit/UIKit.h>
#import "CYFTextEventListener_.h"
#import "CYFUtilities_.h"
#import "CYFTextEvent_.h"

@implementation CYFTextEventListener_

- (instancetype)init
{
    return [self initWithEventRecorder:0];
}

- (instancetype)initWithEventRecorder:(id)arg1 {
    
    if (self = [super init]) {
        
        self.textEventRecorder = arg1;
        self.totalTextEventCount = 0;
        self.textChangeEventAllowedLimit = 0;
        [self configureTextEventNotifications];
    }
    return self;
}

- (void)dealloc
{
    self.textEventRecorder = nil;
    self.textChangeEventAllowedLimit = 0;
    self.totalTextEventCount = 0;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTextEventNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWidgetTextDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
    
}

- (long long)getTotalTextEventCount {
    return self.totalTextEventCount;
}

- (long long)getTextChangeEventCount {
    return self.textChangeEventAllowedLimit;
}

- (void)textWidgetTextDidBeginEditing:(NSNotification *)arg1 {
    
    if (![arg1.object isEqual:self.currentField]) {
        
        self.textChangeEventAllowedLimit = 0;
        self.currentField = arg1.object;
        
    }
    
    [self enqueueTextDataOfField:arg1.object withEventType:1];
    
}

- (void)textWidgetTextDidChange:(NSNotification *)arg1 {
    
    self.textChangeEventAllowedLimit ++ ;
    
    [self enqueueTextDataOfField:arg1.object withEventType:2];
}

- (void)textWidgetTextDidEndEditing:(NSNotification *)arg1 {
    
    self.textChangeEventAllowedLimit = 0;
    self.currentField = nil;
    [self enqueueTextDataOfField:arg1.object withEventType:3];
    
}

- (void)enqueueTextDataOfField:(id)arg1 withEventType:(unsigned long long)arg2 {
    
    self.totalTextEventCount += 1;
    
    if ([self.textEventRecorder respondsToSelector:@selector(textEventListener:withTextData:)]) {
        
        if (self.totalTextEventCount > 50 || arg2 == 2 && self.textChangeEventAllowedLimit >= 10) {
            
            [self.textEventRecorder textEventListener:self withTextData:nil];
            
            return;
        }
        
        NSString * v47 = @"0";
        
        if (arg1) {
            NSString * v19 = [NSString stringWithFormat:@"%p", arg1];
            
            v47 = [NSString stringWithFormat:@"%ld", [CYFUtilities_ strToInt:v19]];
        }
        
        NSUInteger v25 = 0;
        
        if ([arg1 isKindOfClass:[UITextField class]]) {
            
            v25 = ((UITextField *)arg1).text.length;
            
        }else{
            
            if ([arg1 isKindOfClass:[UITextView class]]) {
                v25 = ((UITextView *)arg1).text.length;
            }
            
        }
        
        bool v43 = [self isCurrentEventCopyPaste:v47 noOfChar:v25 withEventType:arg2];
        
        CYFTextEvent_ * v46 = [[CYFTextEvent_ alloc] initWithEventType:arg2 eventCount:self.totalTextEventCount addressString:v47 andTimeStamp:[NSDate date] isCopy:v43];
        
        [self.textEventRecorder textEventListener:self withTextData:v46];
        
        if (arg2 == 1) {
            [self.textEventRecorder textEventListener:self withTextFieldAddressString:v47];
        }
    }
    
}

- (bool)isCurrentEventCopyPaste:(id)arg1 noOfChar:(long long)arg2 withEventType:(unsigned long long)arg3 {
    
    if (!self.prevAddress || self.prevAddress != arg1) {
        self.prevAddress = arg1;
        self.previousTextCount = arg2;
        return false;
    }
    
    if ((arg3 | 2) != 3) {
        
        long long v13 = self.previousTextCount;
        
        self.previousTextCount = arg2;
        
        if (arg3-v13 > 1) {
            return true;
        }
        
    }
    
    return false;
}

@end
