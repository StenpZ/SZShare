#SZShare

封装简易分享控件
一、使用
1.注册
在didFinishLaunchingWithOptions：中添加以下代码


```
[SZShare registerPlatforms:@[@(SZPlatformTypeQQ),
                                  @(SZPlatformTypeWeChat),
                                  @(SZPlatformTypeSinaWeibo)]
                onConfiguration:^(SZPlatformType platform) {
                    switch (platform) {
                        case SZPlatformTypeQQ:
                            [SZShare connectQQWithAppId:kAppIdQQ];
                            break;
                        case SZPlatformTypeSinaWeibo:
                            [SZShare connectWeiboWithAppKey:kAppKeyWeibo];
                            break;
                        case SZPlatformTypeWeChat:
                            [SZShare connectWeChatWithAppId:kAppIdWeChat];
                            break;
                        default:
                            break;
                    }
                }];
```
*注、需要在各分享平台注册自己的App拿到appKey
2.分享回调


```
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
     //第二步：添加回调
     if ([SZShare handleOpenURL:url]) {
         return YES;
     }
     //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
     return YES;
 }
```

3.分享相关信息

```
    SZShareMessage *message = [[SZShareMessage alloc] init];
     //单纯分享图片 则只需要这两个参数
    message.title = @"分享标题";
    message.image = @"分享图片,需要传入UIimage对象";
    //其他分享需要加上这两个
    message.desc = @"分享描述";
    message.link = @"分享链接";
    
    [SZShareSheet shareToPlatformsWithMessage:message onShareStateChanged:^(SZShareState state) {
        switch (state) {
            case SZShareStateWithOutSupportPlatform:
                NSLog(@"no platforms has exist!");
                break;
            case SZShareStateSuccess:
                break;
            case SZShareStateFailure:
                break;
            case SZShareStateCancel:
                break;
            default:
                break;
        }
    }];
```
***说明：目前只实现了QQ好友，QQ空间，微信好友，微信朋友圈，新浪微博（仅限这些平台）（仅限分享纯图片和链接文字两种类型）
