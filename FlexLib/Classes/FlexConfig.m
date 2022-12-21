//
//  FlexConfig.m
//  FlexLib
//
//  Created by dyw on 2022/12/21.
//

#import "FlexConfig.h"
#import "GDataXMLNode.h"
#import "FlexNode.h"
#import "FlexStyleMgr.h"

@implementation FlexStyleModel

@end

@implementation FlexConfig

/// 查找对应的本地类
+ (NSString *)findClass:(NSString *)clsName{
    NSString *name = [[self conversionDict] objectForKey: clsName];
    return (name.length > 0) ? name : clsName;
}


/// 获取StyleModel
+ (FlexStyleModel *)styleWithElm:(GDataXMLElement *)element{
    GDataXMLNode* style = [element attributeForName:@"style"];
    NSString* param = [style stringValue];
    NSArray<FlexAttr *> *allArray = [FlexNode parseStringParams:param];
    NSMutableArray<FlexAttr *> *layoutArray = [NSMutableArray array];
    NSMutableArray<FlexAttr *> *attrsArray = [NSMutableArray array];
    for (FlexAttr *flx in allArray) {
        if (FlexIsLayoutAttr(flx.name)) {
            [layoutArray addObject:flx];
        } else if ([@"@" isEqual: flx.name]) {
            NSArray *value = [flx.value componentsSeparatedByString:@"/"];
            if(value.count == 2){
                NSString *fileName = value.firstObject;
                NSString *style = value.lastObject;
                if([self isLayout:fileName style:style]) {
                    [layoutArray addObject:flx];
                } else {
                    [attrsArray addObject:flx];
                }
            }
        }else {
            [attrsArray addObject:flx];
        }
    }
    FlexStyleModel *model = [[FlexStyleModel alloc] init];
    model.layoutParams = layoutArray;
    model.viewAttrs = attrsArray;
    return model;
}

+ (BOOL)isLayout:(NSString *)fileName style:(NSString *)style {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"style"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    FlexNode *node = [FlexNode loadNodeData:data];
    FlexNode *fNode = [node.children filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", style]].firstObject;
    return FlexIsLayoutAttr(fNode.children.firstObject.name);
}


/// html标签映射字典
+ (NSDictionary<NSString *, NSString *> *)conversionDict{
    static dispatch_once_t onceToken;
    static NSDictionary * mapDict;
    dispatch_once(&onceToken, ^{
        mapDict = @{
            @"div": @"UIView",
            @"span": @"UILabel",
            @"img": @"UIImageView"
        };
    });
    return mapDict;
}

@end
