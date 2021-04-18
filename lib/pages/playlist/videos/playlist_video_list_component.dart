import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/errors/status_error.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_bloc.dart';
import 'package:youtube_app/pages/video/video_page.dart';
import 'package:youtube_app/utils/dialog_utils.dart';

class PlaylistVideoComponent extends StatefulWidget {
  final String playlistId;
  final String apiKey;

  const PlaylistVideoComponent({Key key, this.playlistId, this.apiKey,})
      : super(key: key);

  @override
  _PlaylistVideoComponentState createState() => _PlaylistVideoComponentState();
}

class _PlaylistVideoComponentState extends State<PlaylistVideoComponent> {
  PlaylistVideoListBloc _bloc;
  StreamSubscription _streamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = PlaylistVideoListBloc(apiKey: widget.apiKey, playlistId: widget.playlistId);

      _streamSubscription = _bloc.data.listen((_) {}, onError: (error) {
        if(error is StatusError && error.statusCode != 404)
          DialogUtils.showErrorDialog(context, error, onRetryTap: _tryAgain);

      });
      _bloc.firstPageSink.add(null);
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: _bloc.data,
            builder:
                (BuildContext context, AsyncSnapshot<List<ListItem>> snapshot) {
              List<ListItem> list = snapshot.data;
              if (snapshot.hasData) {
                return PlaylistVideoList(
                  bloc: _bloc,
                  items: list,
                  playVideo: playVideo,
                );
              } else if (snapshot.hasError) {
                return ErrorView(
                    error: snapshot.error, tryAgainFunction: _tryAgain);
              }
              else {
                return const SizedBox();
              }
            }),
        StreamBuilder(
            initialData: false,
            stream: _bloc.isLoading,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data ? LoadingView() : const SizedBox();
            }),
        StreamBuilder(
          initialData: false,
          stream: _bloc.isEmpty,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.data
                ? Center(
              child: Text('Seems like no data here'),
            )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  void _tryAgain() {
    _bloc.firstPageSink.add(null);
  }

  playVideo(int index){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return YoutubeVideoPage(
          index: index,
          apiKey: widget.apiKey,
          playListId: widget.playlistId,
        );
      }),
    );
  }
}
