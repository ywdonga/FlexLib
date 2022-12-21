//
//  FlexConfig.h
//  FlexLib
//
//  Created by dyw on 2022/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FlexAttr;
@class GDataXMLElement;

@interface FlexStyleModel : NSObject

@property (nonatomic, strong) NSArray<FlexAttr*>* layoutParams;
@property (nonatomic, strong) NSArray<FlexAttr*>* viewAttrs;

@end

@interface FlexConfig : NSObject

/// 查找对应的本地类
+ (NSString *)findClass:(NSString *)clsName;

/// 获取StyleModel
+ (FlexStyleModel *)styleWithElm:(GDataXMLElement *)element;

@end

NS_ASSUME_NONNULL_END
