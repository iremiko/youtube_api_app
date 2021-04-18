import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/common/empty_view.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_bloc.dart';
import 'package:youtube_app/pages/video/video_list.dart';
import 'package:youtube_app/utils/dialog_utils.dart';

class YoutubeVideoPage extends StatefulWidget {
  final int index;
  final String playListId;
  final String apiKey;


  YoutubeVideoPage({this.index, this.playListId, this.apiKey});

  @override
  _YoutubeVideoPageState createState() => _YoutubeVideoPageState();
}

class _YoutubeVideoPageState extends State<YoutubeVideoPage> {
  PlaylistVideoListBloc _bloc;
  StreamSubscription _streamSubscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = PlaylistVideoListBloc(
          playlistId: widget.playListId, apiKey: widget.apiKey);
      _streamSubscription = _bloc.data.listen((_) {
      }, onError: (error) {
        DialogUtils.showInfoDialog(context, error);
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
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _bloc.data,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ListItem>> snapshot) {
                if (snapshot.hasData && snapshot.data.isNotEmpty) {

                  return YoutubeVideoList(items: snapshot.data, currentIndex: widget.index,
                      bloc: _bloc);
                } else if (snapshot.hasError) {
                  return ErrorView(
                      error: snapshot.error, tryAgainFunction: _onRetry);
                } else {
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
              return snapshot.data ? EmptyView() : const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  void _onRetry() {
    _bloc.firstPageSink.add(null);
  }

}
