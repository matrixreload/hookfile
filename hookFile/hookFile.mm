//
//  HookFile.mm
//  HookFile
//
//  Created by matrixreload on 2016/11/30.
//  Copyright (c) 2016年 matrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import "UIControl+BlocksKit.h"
#import "MatrixHookKit.h"

#define IsDelay [[[NSUserDefaults standardUserDefaults] objectForKey:@"isDelay"] intValue]
#define HBTYPE [[[NSUserDefaults standardUserDefaults] objectForKey:@"HBTYPE"] intValue]

CHDeclareClass(CMessageMgr);
CHDeclareClass(MicroMessengerAppDelegate);
CHDeclareClass(NewMainFrameViewController);

CHMethod(0, UIViewController*, NewMainFrameViewController, init)
{
    UIViewController *mainVC=CHSuper(0, NewMainFrameViewController, init);
    mainVC.view.backgroundColor=[UIColor redColor];
    UIButton *btn = [MatrixHookKit entryBtn];
    [mainVC.view addSubview:btn];
    [btn bk_addEventHandler:^(id sender) {
        [mainVC.navigationController pushViewController:[MatrixHookKit HongBaoSettingVC]
                                                  animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    return mainVC;
}

CHMethod(1, void, CMessageMgr, AsyncOnPushMsg, id, arg1)
{
    CHSuper(1, CMessageMgr, AsyncOnPushMsg, arg1);
}

CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
{
    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
    
    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
    Ivar nsToUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsToUsr");
    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
    
    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
    id m_nsToUsr = object_getIvar(arg2, nsToUsrIvar);
    id m_nsContent = object_getIvar(arg2, nsContentIvar);
    
    if(m_uiMessageType == 49) {
        Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
        IMP impMMSC = method_getImplementation(methodMMServiceCenter);
        id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
        id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
        id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
        Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
        IMP impGS = method_getImplementation(methodGetSelfContact);
        id selfContact = impGS(contactManager, @selector(getSelfContact));
        Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
        id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
        BOOL isMesasgeFromMe = NO;
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",m_nsToUsr]
                                                  forKey:@"m_nsToUsr"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)m_uiMessageType]
                                                  forKey:@"m_uiMessageType"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",m_nsFromUsr]
                                                  forKey:@"m_nsFromUsr"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",m_nsUsrName]
                                                  forKey:@"m_nsUsrName"];
        
        
        if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
            isMesasgeFromMe = YES;
        }
        else if(isMesasgeFromMe && kCloseForMyself == HBTYPE){
            
        }
        else if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound){
            
            NSString *nativeUrl = m_nsContent;
            NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
            if (rangeStart.location != NSNotFound)
            {
                NSUInteger locationStart = rangeStart.location;
                nativeUrl = [nativeUrl substringFromIndex:locationStart];
            }
            NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
            if (rangeEnd.location != NSNotFound)
            {
                NSUInteger locationEnd = rangeEnd.location;
                nativeUrl = [nativeUrl substringToIndex:locationEnd];
            }
            NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
            NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
            for (NSString *currentPair in parameterPairs) {
                NSRange range = [currentPair rangeOfString:@"="];
                if(range.location == NSNotFound)
                    continue;
                NSString *key = [currentPair substringToIndex:range.location];
                NSString *value =[currentPair substringFromIndex:range.location + 1];
                [parameters setObject:value forKey:key];
            }
            
            NSMutableDictionary *params = [@{} mutableCopy];
            
            [params setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];
            [params setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];
            [params setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];
            
            id getContactDisplayName = objc_msgSend(selfContact, @selector(getContactDisplayName));
            id m_nsHeadImgUrl = objc_msgSend(selfContact, @selector(m_nsHeadImgUrl));
            
            [params setObject:getContactDisplayName forKey:@"nickName"];
            [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
            [params setObject:[NSString stringWithFormat:@"%@", nativeUrl]?:@"null" forKey:@"nativeUrl"];
            [params setObject:m_nsFromUsr?:@"null" forKey:@"sessionUserName"];
            if (kOpen <= HBTYPE) {
                float delay = 0;
                if (IsDelay == 1) {
                    delay = (rand() % 6) * 1.0 / 10.0;
                }
                dispatch_time_t delayTimeDispatch = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
                dispatch_after(delayTimeDispatch, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
                });
                
            }
        }
    }
}

CHMethod(2, BOOL, MicroMessengerAppDelegate, application, id, arg1, didFinishLaunchingWithOptions, id, arg2)
{
    BOOL supBool = CHSuper(2, MicroMessengerAppDelegate, application, arg1, didFinishLaunchingWithOptions, arg2);
    
    NSString *type=[[NSUserDefaults standardUserDefaults] objectForKey:@"HBTYPE"];
    if(type==nil||[type length]==0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1]
                                                  forKey:@"HBTYPE"];
    }
    
    return supBool;
}

__attribute__((constructor)) static void entry()
{
    CHLoadLateClass(CMessageMgr);
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
    CHLoadLateClass(MicroMessengerAppDelegate);
    CHHook(2, MicroMessengerAppDelegate, application, didFinishLaunchingWithOptions);
    CHLoadLateClass(NewMainFrameViewController);
    CHClassHook(0,NewMainFrameViewController,init);
}

