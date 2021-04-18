
import 'package:flutter/material.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_item.dart';

typedef Widget CardBuilder(PlaylistVideoItem playlistVideoItem, int index);
class PlaylistVideoListItemView extends StatelessWidget {
  final Function tryAgain;
  final ListItem listItem;
  final CardBuilder buildCard;
  final int index;

  PlaylistVideoListItemView(this.tryAgain, this.listItem,  this.buildCard, this.index);

  @override
  Widget build(BuildContext context) {
    if (listItem is PlaylistVideoListItem) {
      PlaylistVideoListItem item = listItem;
      return buildCard(item.playlistVideoItem, index);
    } else if (listItem is LoadingItem) {
      return LoadingView();
    } else if (listItem is LoadingFailed) {
      LoadingFailed item = listItem;
      return ErrorView(
        error: item.error,
        tryAgainFunction: tryAgain,
      );
    } else {
      throw Exception('listItem is unknown!');
    }
  }
}
