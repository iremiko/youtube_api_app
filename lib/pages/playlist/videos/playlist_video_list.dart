
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_bloc.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_card.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_item_view.dart';

///ListView which controls pagination

class PlaylistVideoList extends StatefulWidget {
  final PlaylistVideoListBloc bloc;
  final List<ListItem> items;
  final Function (int index) playVideo;

  const PlaylistVideoList({Key key, this.bloc, this.items, this.playVideo}) : super(key: key);


  @override
  _PlaylistVideoListState createState() {
    return _PlaylistVideoListState();
  }
}

class _PlaylistVideoListState extends State<PlaylistVideoList> {
  final ScrollController _scrollController = ScrollController();
  final log = Logger('_PlaylistVideoListState');

  @override
  void initState() {
    log.info("------initState: PlaylistVideoList");
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
  void didUpdateWidget(PlaylistVideoList oldWidget) {
    log.info("------didUpdateWidget: PlaylistItemList");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    log.info("------build: PlaylistItemList");
    return RefreshIndicator(
        onRefresh: widget.bloc.refresh,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 1.0),
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            return PlaylistVideoListItemView(
                _tryAgain, widget.items[index], _buildItem, index);
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

  void _tryAgain() {
    widget.bloc.nextPageRetrySink.add(null);
  }



  Widget _buildItem(PlaylistVideoItem item, int index) {
    return PlaylistVideoListCard(
      item: item,
      playVideo: (){
        widget.playVideo(index);
      },
    );
  }
}
