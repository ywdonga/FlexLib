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

/// 查找对应的样式和布局key
+ (NSString *)findStyleKey:(NSString *)key{
    NSString *htmlKey = [[self htmlStyleDict] objectForKey:key];
    return (htmlKey.length > 0) ? htmlKey : key;
}

/// 查找对应的样式和布局Value
+ (NSString *)findStyleValue:(NSString *)value{
    if([self isPixelValue:value]) {
        return [value stringByReplacingOccurrencesOfString:@"px" withString:@""];
    }
    NSString *htmlValue = [[self htmlValueDict] objectForKey:value];
    return (htmlValue.length > 0) ? htmlValue : value;
}

/// 获取StyleModel
+ (FlexStyleModel *)styleWithElm:(GDataXMLElement *)element{
    GDataXMLNode* style = [element attributeForName:@"style"];
    NSString* param = [style stringValue];
    NSArray<FlexAttr *> *allArray = [FlexNode parseStringParams:param];
    NSMutableArray<FlexAttr *> *layoutArray = [NSMutableArray array];
    NSMutableArray<FlexAttr *> *attrsArray = [NSMutableArray array];
    if([@"span" isEqualToString:element.name] && element.stringValue.length > 0) {
        FlexAttr *textAttr = [[FlexAttr alloc] init];
        textAttr.name = @"text";
        textAttr.value = element.stringValue;
        [attrsArray addObject:textAttr];
    } else if([@"img" isEqualToString:element.name]) {
        GDataXMLNode* srcNode = [element attributeForName:@"src"];
        if(srcNode.stringValue.length > 0){
            FlexAttr *imgAttr = [[FlexAttr alloc] init];
            imgAttr.name = @"source";
            imgAttr.value = srcNode.stringValue;
            [attrsArray addObject:imgAttr];
        }
    }
    
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

/// html样式布局key映射字典
+ (NSDictionary<NSString *, NSString *> *)htmlStyleDict{
    static dispatch_once_t onceToken;
    static NSDictionary * mapDict;
    dispatch_once(&onceToken, ^{
        mapDict = @{
            @"flex-direction": @"flexDirection",//布局方向
            @"align-items": @"alignItems",
            
            @"margin-top": @"marginTop",//上外边距
            @"margin-left": @"marginLeft",//左外边距
            @"margin-bottom": @"marginBottom",//下外边距
            @"margin-right": @"marginRight",//右外边距
            
            @"border-top-left-radius": @"borderTopLeftRadius",//上左圆角
            @"border-top-right-radius": @"borderTopRightRadius",//上右圆角
            @"max-lines": @"linesNum",//文字行数
            @"text-overflow": @"lineBreakMode",//文字裁剪模式
            @"object-fit": @"contentMode",//填充模式
            @"background-color": @"bgColor",//背景颜色
            @"border-radius": @"borderRadius",//圆角
            @"font-size": @"fontSize",//字体大小
            @"font-weight": @"font",//字体
        };
    });
    return mapDict;
}

/// html样式布局Value映射字典
+ (NSDictionary<NSString *, NSString *> *)htmlValueDict{
    static dispatch_once_t onceToken;
    static NSDictionary * mapDict;
    dispatch_once(&onceToken, ^{
        mapDict = @{
            @"column": @"col",
        };
    });
    return mapDict;
}

/// 是否是像素
+ (BOOL)isPixelValue:(NSString *)textString {
    NSString* number=@"^[0-9]+(px)$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
