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
}

-(void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    
    NSString *artistName = searchResult.artistName;
    if(artistName == nil)
    {
        artistName = NSLocalizedString(@"Unknown",@"Localized kind:Unknown");
    }
    
    NSString *kind = [searchResult kindForDisplay];
    self.artistNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ARTIST_NAME_LABEL_FORMAT",@"Format for artist name label"),artistName,kind];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}




@end
