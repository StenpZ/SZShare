//
//  SZShareSheet.m
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZShareSheet.h"
#import "SZShareHeader.h"

@implementation SZSharePlatformItem

- (instancetype)init {
    if (self = [super init]) {
        _type = SZPlatformTypeNone;
        _subType = SZPlatformSubTypeNone;
        _itemLogo = @"";
        _itemTitle = @"";
    }
    return self;
}

+ (NSArray *)defaultPlatformItems {
    SZSharePlatformItem *qqFriend = [[SZSharePlatformItem alloc] init];
    qqFriend.type = SZPlatformTypeQQ;
    qqFriend.subType = SZPlatformSubTypeQQFriend;
    qqFriend.itemLogo = @"share_qq";
    qqFriend.itemTitle = @"QQ";
    
    SZSharePlatformItem *qqZone = [[SZSharePlatformItem alloc] init];
    qqZone.type = SZPlatformTypeQQ;
    qqZone.subType = SZPlatformSubTypeQQZone;
    qqZone.itemLogo = @"share_qqzone";
    qqZone.itemTitle = @"QQ空间";
    
    SZSharePlatformItem *weibo = [[SZSharePlatformItem alloc] init];
    weibo.type = SZPlatformTypeSinaWeibo;
    weibo.subType = SZPlatformSubTypeNone;
    weibo.itemLogo = @"share_weibo";
    weibo.itemTitle = @"微博";
    
    SZSharePlatformItem *weChat = [[SZSharePlatformItem alloc] init];
    weChat.type = SZPlatformTypeWeChat;
    weChat.subType = SZPlatformSubTypeWeChatSession;
    weChat.itemLogo = @"share_wechat";
    weChat.itemTitle = @"微信好友";
    
    SZSharePlatformItem *weChatTimeLine = [[SZSharePlatformItem alloc] init];
    weChatTimeLine.type = SZPlatformTypeWeChat;
    weChatTimeLine.subType = SZPlatformSubTypeWeChatTimeline;
    weChatTimeLine.itemLogo = @"share_wechatTimeLine";
    weChatTimeLine.itemTitle = @"微信朋友圈";
    
    NSArray *platforms = @[qqFriend, qqZone, weChat, weChatTimeLine, weibo];
    return platforms;
}

@end


@interface SZShareSheetCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation SZShareSheetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-15-[_imageView]-15-|"
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|"
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-10-[_imageView(50)][_titleLabel(20)]"
                          options:0
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(_imageView, _titleLabel)]];
    
    [super updateConstraints];
}

- (void)configUI:(SZSharePlatformItem *)item {
    self.imageView.image = [UIImage imageNamed:item.itemLogo];
    self.titleLabel.text = item.itemTitle;
}

@end


@interface SZShareSheet ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) SZShareStateChangedBlock block;
@property(nonatomic, weak) SZShareMessage *message;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, copy, readonly) NSString *cellIdentifier;

@property(nonatomic, readonly) CGFloat fullHeight;
@property(nonatomic, readonly) CGFloat fullWidth;

@end

static NSArray *platformItems; //!< 平台选项列表
static CGFloat realHeight = 0.f;

@implementation SZShareSheet

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        [self addSubview:self.maskView];
        
        UITapGestureRecognizer *emptyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnEmptyView)];
        [self.maskView addGestureRecognizer:emptyTap];
        
        [self addSubview:self.collectionView];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[SZShareSheetCell class] forCellWithReuseIdentifier:self.cellIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return platformItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZShareSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    SZSharePlatformItem *item = platformItems[indexPath.row];
    [cell configUI:item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SZSharePlatformItem *item = platformItems[indexPath.row];
    [self didClickPlatformItem:item];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.f, 90.f);
}

#pragma mark - getter & setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSString *)cellIdentifier {
    return @"cellIdentifier";
}

- (CGFloat)fullWidth {
    return self.bounds.size.width;
}

- (CGFloat)fullHeight {
    return self.bounds.size.height;
}

#pragma mark - Method
- (void)didClickPlatformItem:(SZSharePlatformItem *)item {
    switch (item.type) {
        case SZPlatformTypeQQ:
            self.message.thumbnail = self.message.thumbnail ? self.message.thumbnail : self.message.image;
            self.message.desc = self.message.desc ? self.message.desc: self.message.title;
            if (item.subType == SZPlatformSubTypeQQFriend) {
                [SZShare shareToQQFriends:self.message Success:^(SZShareMessage *message) {
                    if (self.block) {
                        self.block(SZShareStateSuccess);
                        self.block = nil;
                    }
                } Fail:^(SZShareMessage *message, NSError *error) {
                    if (self.block) {
                        self.block(SZShareStateFailure);
                        self.block = nil;
                    }
                }];
            } else if (item.subType == SZPlatformSubTypeQQZone) {
                [SZShare shareToQQZone:self.message Success:^(SZShareMessage *message) {
                    if (self.block) {
                        self.block(SZShareStateSuccess);
                        self.block = nil;
                    }
                } Fail:^(SZShareMessage *message, NSError *error) {
                    if (self.block) {
                        self.block(SZShareStateFailure);
                        self.block = nil;
                    }
                }];
            } else {
                if (self.block) {
                    self.block(SZShareStateFailure);
                    self.block = nil;
                }
            }
            break;
            
        case SZPlatformTypeWeChat:
            if (item.subType == SZPlatformSubTypeWeChatSession) {
                [SZShare shareToWeixinSession:self.message Success:^(SZShareMessage *message) {
                    if (self.block) {
                        self.block(SZShareStateSuccess);
                        self.block = nil;
                    }
                } Fail:^(SZShareMessage *message, NSError *error) {
                    if (self.block) {
                        self.block(SZShareStateFailure);
                        self.block = nil;
                    }
                }];
            } else if (item.subType == SZPlatformSubTypeWeChatTimeline) {
                [SZShare shareToWeixinTimeline:self.message Success:^(SZShareMessage *message) {
                    if (self.block) {
                        self.block(SZShareStateSuccess);
                        self.block = nil;
                    }
                } Fail:^(SZShareMessage *message, NSError *error) {
                    if (self.block) {
                        self.block(SZShareStateFailure);
                        self.block = nil;
                    }
                }];
            } else {
                if (self.block) {
                    self.block(SZShareStateFailure);
                    self.block = nil;
                }
            }
            break;
            
        case SZPlatformTypeSinaWeibo:
        {
            [SZShare shareToWeibo:self.message Success:^(SZShareMessage *message) {
                if (self.block) {
                    self.block(SZShareStateSuccess);
                    self.block = nil;
                }
            } Fail:^(SZShareMessage *message, NSError *error) {
                if (self.block) {
                    self.block(SZShareStateFailure);
                    self.block = nil;
                }
            }];
        }
            break;
            
        default:
            if (self.block) {
                self.block(SZShareStateWithOutSupportPlatform);
                self.block = nil;
            }
            break;
    }
    [self dismiss];
}

- (void)didTapOnEmptyView {
    if (self.block) {
        self.block(SZShareStateCancel);
        self.block = nil;
    }
    [self dismiss];
}

- (void)show {
    realHeight = 216;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.collectionView.frame = CGRectMake(0, self.fullHeight, self.fullWidth, 0);
    self.maskView.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5f;
        self.collectionView.frame = CGRectMake(0, self.fullHeight - realHeight, self.fullWidth, realHeight);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.f;
        self.collectionView.frame = CGRectMake(0, self.fullHeight, self.fullWidth, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Class Method
+ (NSArray *)platformItems {
    return platformItems;
}

+ (void)setPlatformItems:(NSArray *)platforms {
    NSMutableArray *array = [NSMutableArray array];
    for (SZSharePlatformItem *item in platforms) {
        switch (item.type) {
            case SZPlatformTypeQQ:
                if ([SZShare isQQInstalled]) {
                    [array addObject:item];
                }
                break;
            case SZPlatformTypeWeChat:
                if ([SZShare isWeixinInstalled]) {
                    [array addObject:item];
                }
                break;
            case SZPlatformTypeSinaWeibo:
                if ([SZShare isWeiboInstalled]) {
                    [array addObject:item];
                }
                break;
            default:
                break;
        }
    }
    
    platformItems = [array copy];
//    platformItems = [platforms copy];
}

+ (instancetype)shareToPlatformsWithMessage:(SZShareMessage *)message onShareStateChanged:(SZShareStateChangedBlock)block {
    if (![SZShareSheet platformItems].count) {
        if (block) {
            block(SZShareStateWithOutSupportPlatform);
        }
        return nil;
    }
    SZShareSheet *sheet = [[SZShareSheet alloc] init];
    sheet.message = message;
    sheet.block = block;
    [sheet show];
    return sheet;
}

@end

