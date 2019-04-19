


#import "CYFTextFormfieldDataFormatter_.h"


@implementation CYFTextFormfieldDataFormatter_

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textFormFieldsAddressArray = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [self.textFormFieldsAddressArray removeAllObjects];
    
    self.textFormFieldsAddressArray = nil;
}

- (id)formatTextFormFieldData:(id)arg1 {
    
    if ([self.textFormFieldsAddressArray containsObject:arg1]) {
        return @"";
    }else{
        [self.textFormFieldsAddressArray addObject:arg1];
        return [NSString stringWithFormat:@"%@;", arg1];
    }
    
}

@end
