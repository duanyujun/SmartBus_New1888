//
//  BHOfflineBoard.m
//  SmartBus
//
//  Created by 王 正星 on 14-1-26.
//  Copyright (c) 2014年 launching. All rights reserved.
//

#import "BHOfflineBoard.h"
#import <MAMapKit/MAMapKit.h>

NSString const *DownloadStageIsRunningKey = @"DownloadStageIsRunningKey";
NSString const *DownloadStageStatusKey    = @"DownloadStageStatusKey";
NSString const *DownloadStageInfoKey      = @"DownloadStageInfoKey";

@interface BHOfflineBoard ()
{
    NSMutableArray *cities;
    NSMutableDictionary *downloadStages;
    
    NSPredicate *predicate;
    
    MAOfflineCity *m_city;
    
//  UI
    UILabel *versionLbl;
    UILabel *sizeLbl;
    BeeUIButton *downloadBtn;
}
@end

@implementation BHOfflineBoard

- (void)load
{
    [super load];
    cities = [[NSMutableArray alloc]initWithCapacity:0];
    downloadStages = [[NSMutableDictionary alloc]init];
    predicate = [NSPredicate predicateWithFormat:@"cityName CONTAINS[cd] $KEY OR cityCode CONTAINS[cd] $KEY OR urlString CONTAINS[cd] $KEY"];
}

- (void)unload
{
    [super unload];
    SAFE_RELEASE(cities);
    SAFE_RELEASE(downloadStages);
    SAFE_RELEASE_SUBVIEW(versionLbl);
    SAFE_RELEASE_SUBVIEW(sizeLbl);
    SAFE_RELEASE_SUBVIEW(downloadBtn);
}


ON_SIGNAL2( BeeUIBoard, signal )
{ 
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self indicateIsFirstBoard:NO image:[UIImage imageNamed:@"nav_setting.png"] title:@"离线地图"];
        
        versionLbl = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, 300.f, 20.f)];
        [versionLbl setBackgroundColor:[UIColor clearColor]];
        [versionLbl setText:[NSString stringWithFormat:@"版本：%@",[MAOfflineMap sharedOfflineMap].version]];
        [self.beeView addSubview:versionLbl];
        
        sizeLbl = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 30.f, 300.f, 20.f)];
        [sizeLbl setBackgroundColor:[UIColor clearColor]];
        [sizeLbl setText:[NSString stringWithFormat:@"大小：%.2fM",m_city.size/1024000.f]];
        [self.beeView addSubview:sizeLbl];
        
        downloadBtn = [[BeeUIButton alloc]initWithFrame:CGRectMake(10.f, 60.f, 300.f, 40.f)];
        [downloadBtn setSignal:@"download"];
        [downloadBtn setBackgroundColor:[UIColor flatDarkRedColor]];
        [downloadBtn.layer setCornerRadius:3.f];
        [self.beeView addSubview:downloadBtn];
        
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self setupCities];
        NSLog(@"%@",m_city);
        [self updateView];
    }
}


ON_SIGNAL2(BeeUIButton, signal)
{
    if ([signal is:@"download"]) {
        if (m_city.status == MAOfflineCityStatusInstalled) {
            return;
        }
        if ([[MAOfflineMap sharedOfflineMap] isDownloadingForCity:m_city])
        {
            [self pause];
        }
        else
        {
            [self download];
        }
    }
}


- (void)updateView
{
    [sizeLbl setText:[NSString stringWithFormat:@"大小：%.2fM",m_city.size/1024000.f]];
    switch (m_city.status) {
        case MAOfflineCityStatusExpired:
        {
            [downloadBtn setTitle:@"更新" forState:UIControlStateNormal];
        }
            break;
        case MAOfflineCityStatusNone:
        {
            [downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        }
            break;
        case MAOfflineCityStatusCached:
        {
            [downloadBtn setTitle:@"继续" forState:UIControlStateNormal];
        }
            break;
        case MAOfflineCityStatusInstalled:
        {
            [downloadBtn setTitle:@"已安装" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (NSString *)cellDetailTextForCity:(MAOfflineCity *)city downloadStage:(NSDictionary *)downloadStage
{
    NSString *detailText = nil;
    
    if (![[downloadStage objectForKey:DownloadStageIsRunningKey] boolValue])
    {
        if (city.status == MAOfflineCityStatusCached)
        {
            detailText = [NSString stringWithFormat:@"%lld/%lld", city.downloadedSize, city.size];
        }
        else
        {
            detailText = [NSString stringWithFormat:@"大小：%lld", city.size];
        }
    }
    else
    {
        MAOfflineMapDownloadStatus status = [[downloadStage objectForKey:DownloadStageStatusKey] intValue];
        
        switch (status)
        {
            case MAOfflineMapDownloadStatusWaiting:
            {
                detailText = @"等待";
                
                break;
            }
            case MAOfflineMapDownloadStatusStart:
            {
                detailText = @"开始";
                
                break;
            }
            case MAOfflineMapDownloadStatusProgress:
            {
                NSDictionary *progressDict = [downloadStage objectForKey:DownloadStageInfoKey];
                
                long long recieved = [[progressDict objectForKey:MAOfflineMapDownloadReceivedSizeKey] longLongValue];
                long long expected = [[progressDict objectForKey:MAOfflineMapDownloadExpectedSizeKey] longLongValue];
                
                detailText = [NSString stringWithFormat:@"%lld/%lld(%.1f%%)", recieved, expected, recieved/(float)expected*100];
                break;
            }
            case MAOfflineMapDownloadStatusCompleted:
            {
                detailText = @"下载完成";
                break;
            }
            case MAOfflineMapDownloadStatusCancelled:
            {
                detailText = @"取消";
                break;
            }
            case MAOfflineMapDownloadStatusUnzip:
            {
                detailText = @"解压中";
                break;
            }
            case MAOfflineMapDownloadStatusFinished:
            {
                detailText = @"结束";
                
                break;
            }
            default:
            {
                detailText = @"错误";
                
                break;
            }
        }
    }
    
    return detailText;
}


- (void)download
{
    
    
    [[MAOfflineMap sharedOfflineMap] downloadCity:m_city downloadBlock:^(MAOfflineMapDownloadStatus downloadStatus, id info) {
        
        /* Manipulations to your application’s user interface must occur on the main thread. */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (downloadStatus == MAOfflineMapDownloadStatusWaiting)
            {
                [downloadStages setObject:[NSNumber numberWithBool:YES] forKey:DownloadStageIsRunningKey];
            }
            else if(downloadStatus == MAOfflineMapDownloadStatusProgress)
            {
                [downloadStages setObject:info forKey:DownloadStageInfoKey];
            }
            else if(downloadStatus == MAOfflineMapDownloadStatusCancelled
                    || downloadStatus == MAOfflineMapDownloadStatusError
                    || downloadStatus == MAOfflineMapDownloadStatusFinished)
            {
                [downloadStages setObject:[NSNumber numberWithBool:NO] forKey:DownloadStageIsRunningKey];
            }
            
            [downloadStages setObject:[NSNumber numberWithInt:downloadStatus] forKey:DownloadStageStatusKey];
            
            /* Update UI. */
            
            
            [sizeLbl setText:[self cellDetailTextForCity:m_city downloadStage:downloadStages]];
            
            if (m_city.status == MAOfflineCityStatusInstalled)
            {
                downloadBtn.hidden = YES;
            }
            else
            {
                downloadBtn.hidden = NO;
                
                [downloadBtn setTitle:[[downloadStages objectForKey:DownloadStageIsRunningKey] boolValue] ? @"暂停" : @"下载"
                     forState:UIControlStateNormal];
            }
//            if (cell != nil)
//            {
//                [self updateCell:cell city:city downloadStage:stage];
//            }
//            
//            if (downloadStatus == MAOfflineMapDownloadStatusFinished)
//            {
//                [self.mapView reloadMap];
//            }
        });
    }];
}

- (void)pause
{
    [[MAOfflineMap sharedOfflineMap] pause:m_city];
//    [self setupCities];
    [self updateView];
}




- (NSArray *)citiesFilterWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return nil;
    }
    
    NSPredicate *keyPredicate = [predicate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:key forKey:@"KEY"]];
    
    return [cities filteredArrayUsingPredicate:keyPredicate];
}

- (void)setupCities
{
    [cities removeAllObjects];
    [cities addObjectsFromArray:[MAOfflineMap sharedOfflineMap].offlineCities];
    
    m_city = [[self citiesFilterWithKey:@"南京"] lastObject];

}
@end
