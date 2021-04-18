import 'package:flutter/material.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_item.dart';
typedef Widget CardBuilder(PlaylistListItem playlistListItem);
class PlaylistListItemView extends StatelessWidget {
  final ListItem listItem;
  final Function tryAgain;
  final CardBuilder buildCard;

  PlaylistListItemView(this.listItem, this.tryAgain, this.buildCard);

  @override
  Widget build(BuildContext context) {
    if (listItem is PlaylistListItem) {
      PlaylistListItem item = listItem;
      return buildCard(item);
    } else if (listItem is LoadingItem) {
      return LoadingView();
    } else if (listItem is LoadingFailed) {
      LoadingFailed item = listItem;
      return ErrorView(
        tryAgainFunction: tryAgain,
        error: item.error,
      );
    } else {
      throw Exception('listItem is unknown!');
    }
  }
}
