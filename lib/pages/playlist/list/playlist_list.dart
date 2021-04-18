
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/models/playlist_model.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_bloc.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_card.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_item.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_item_view.dart';

///ListView which controls pagination

class PlaylistList extends StatefulWidget {
  final PlaylistListBloc bloc;
  final List<ListItem> items;
  final Function(PlaylistItem item) playVideo;

  PlaylistList({this.bloc, this.items, Key key, this.playVideo}) : super(key: key);

  @override
  _PlaylistListState createState() {
    return _PlaylistListState();
  }
}

class _PlaylistListState extends State<PlaylistList> {
  final ScrollController _scrollController = ScrollController();
  final log = Logger('_PlaylistListState');

  @override
  void initState() {
    log.info("------initState: PlaylistList");
    _scrollController.addListener(_handleNextPageLoading);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleNextPageLoading);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlaylistList oldWidget) {
    log.info("------didUpdateWidget: PlaylistList");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    log.info("------build: PlaylistList");
    return RefreshIndicator(
        onRefresh: widget.bloc.refresh,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 1.0),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context , int index) {
            return PlaylistListItemView(widget.items[index], _tryAgain, _buildItem);
          },
          controller: _scrollController,
        ));
  }

  void _handleNextPageLoading() {
    //Start loading next page when visible content 500 pixels close
    //to end of the scroll.
    if (_scrollController.position.extentAfter < 500) {
      widget.bloc.nextPageSink.add(null);
    }
  }

  Widget _buildItem(PlaylistListItem item) {
    return GestureDetector(onTap: () => widget.playVideo(item.playlist),
        child: PlaylistListCard(item: item.playlist));
  }

  void _tryAgain() {
    widget.bloc.nextPageRetrySink.add(null);
  }
}
