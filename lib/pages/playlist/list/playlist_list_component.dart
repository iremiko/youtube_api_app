
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_app/common/empty_view.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/models/playlist_model.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_bloc.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_page.dart';
import 'package:youtube_app/utils/dialog_utils.dart';

class PlaylistListComponent extends StatefulWidget {
  final String channelId;
  final String apiKey;

  const PlaylistListComponent({Key key, this.channelId, this.apiKey}) : super(key: key);
  @override
  _PlaylistListComponentState createState() => _PlaylistListComponentState();
}

class _PlaylistListComponentState extends State<PlaylistListComponent> {
  PlaylistListBloc _bloc;

  StreamSubscription _streamSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc =
          PlaylistListBloc(apiKey: widget.apiKey, channelId: widget.channelId);

      _streamSubscription = _bloc.data.listen((_) {}, onError: (error) {
        DialogUtils.showErrorDialog(context, error, onRetryTap: _tryAgain);
      });
      _bloc.firstPageSink.add(null);
    }
  }
@override
  void dispose() {
   _bloc.dispose();
   _streamSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: _bloc.data,
            builder: (BuildContext context,
                AsyncSnapshot<List<ListItem>> snapshot) {
              List<ListItem> list = snapshot.data;
              if (snapshot.hasData) {
                return PlaylistList(
                  bloc: _bloc,
                  items: list,
                  playVideo: playVideo,
                );
              } else if (snapshot.hasError) {
                return ErrorView(
                    tryAgainFunction: _tryAgain);
              } else {
                return const SizedBox();
              }
            }),
        StreamBuilder(
            initialData: false,
            stream: _bloc.isLoading,
            builder: (BuildContext context,
                AsyncSnapshot<bool> snapshot) {
              return snapshot.data
                  ? LoadingView()
                  : const SizedBox();
            }),
        StreamBuilder(
          initialData: false,
          stream: _bloc.isEmpty,
          builder: (BuildContext context,
              AsyncSnapshot<bool> snapshot) {
            return snapshot.data
                ?  EmptyView()

                : const SizedBox();
          },
        ),
      ],
    );
  }
  void _tryAgain() {
    _bloc.firstPageSink.add(null);
  }

  playVideo(PlaylistItem item) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return PlaylistVideoListPage(
            playlistItem: item,
            apiKey: widget.apiKey,
          );
        }));
  }
}
