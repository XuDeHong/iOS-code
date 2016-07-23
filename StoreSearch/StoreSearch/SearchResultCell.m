//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by 许德鸿 on 16/7/21.
//  Copyright © 2016年 XuDeHong. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5f];
    self.selectedBackgroundView = selectedView;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.artworkImageView cancelImageRequestOperation];
    self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
    NSLog(@"Reuse");
}

-(void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    
    NSString *artistName = searchResult.artistName;
    if(artistName == nil)
    {
        artistName = @"Unknown";
    }
    
    NSString *kind = [self kindForDisplay:searchResult.kind];
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)",artistName,kind];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

-(NSString *)kindForDisplay:(NSString *)kind
{
    if([kind isEqualToString:@"album"])
    {
        return @"Album";
    }
    else if([kind isEqualToString:@"audiobook"])
    {
        return @"Audio Book";
    }
    else if([kind isEqualToString:@"book"])
    {
        return @"Book";
    }
    else if([kind isEqualToString:@"ebook"])
    {
        return @"E-Book";
    }
    else if([kind isEqualToString:@"feature-movie"])
    {
        return @"Movie";
    }
    else if([kind isEqualToString:@"music-video"])
    {
        return @"Music Video";
    }
    else if([kind isEqualToString:@"podcast"])
    {
        return @"Podcast";
    }
    else if([kind isEqualToString:@"software"])
    {
        return @"App";
    }
    else if([kind isEqualToString:@"song"])
    {
        return @"Song";
    }
    else if([kind isEqualToString:@"tv-episode"])
    {
        return @"TV Episode";
    }
    else
    {
        return kind;
    }
    
}


@end
