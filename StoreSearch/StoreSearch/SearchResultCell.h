//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/21.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResult;

@interface SearchResultCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic,weak) IBOutlet UIImageView *artworkImageView;

-(void)configureForSearchResult:(SearchResult *)searchResult;

@end
