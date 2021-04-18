import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_app/common/empty_view.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/models/playlist_model.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_bloc.dart';
import 'package:youtube_app/pages/video/video_page.dart';
import 'package:youtube_app/utils/dialog_utils.dart';

class PlaylistVideoListPage extends StatefulWidget {
  final PlaylistItem playlistItem;
  final String apiKey;
  const PlaylistVideoListPage({Key key, this.apiKey, this.playlistItem})
      : super(key: key);

  @override
  _PlaylistVideoListPageState createState() => _PlaylistVideoListPageState();
}

class _PlaylistVideoListPageState extends State<PlaylistVideoListPage> {
  PlaylistVideoListBloc _bloc;
  StreamSubscription _streamSubscription;
List<ListItem> _list = [];
  EdgeInsets  _padding = EdgeInsets.all(16.0);



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = PlaylistVideoListBloc(
          playlistId: widget.playlistItem.id, apiKey: widget.apiKey);
      _streamSubscription = _bloc.data.listen((_) {}, onError: (error) {
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
 double   _imageHeight = widget.playlistItem.snippet.thumbnails.highItem.height/3 ;
  double  _imageWidth = widget.playlistItem.snippet.thumbnails.highItem.width/3;
   double _cardHeight = _imageHeight+ _padding.horizontal;
  double  _playIconSize = _imageWidth/3;
    return Scaffold(
      appBar: AppBar(title: Text(widget.playlistItem.snippet.title),),
      body: Column(
        children: [
          SizedBox(
            height: _playIconSize+_cardHeight,
            child: Stack(
              children: [
                Container(
                 height: _cardHeight,
                  color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.05),
                  child: Row(children: [
                    Padding(
                      padding: _padding,
                      child: Image.network(widget.playlistItem.snippet.thumbnails.highItem.url,width: _imageWidth,
                        height: _imageHeight,),
                    ),
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.only(top:_padding.horizontal, bottom: _padding.bottom, right: _padding.right),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${widget.playlistItem.snippet.title}', style: Theme.of(context).textTheme.headline6,),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0),
                              child: Text('${widget.playlistItem.snippet.channelTitle}', style: Theme.of(context).textTheme.bodyText2,),
                            ),
                            Text('${widget.playlistItem.contentDetails.itemCount}\tvideos', style: Theme.of(context).textTheme.bodyText2,),
                          ],
                        ),
                      ),
                    ),
                  ],),
                ),
                Positioned(
                  top: _cardHeight-(_playIconSize/2),
                  right: _playIconSize,
                  child: GestureDetector(
                    onTap:() {
                      if(_list != null)
                        playVideo(0);
                    },
                    child: Container(
                        height: _playIconSize,
                        width:  _playIconSize,
                        decoration:  BoxDecoration(
                          // Circle shape
                          shape: BoxShape.circle,
                          color: Theme.of(context).iconTheme.color,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Icon(FontAwesomeIcons.play,  size: _playIconSize/2,
                          color: Colors.white,),),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                    stream: _bloc.data,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ListItem>> snapshot) {
                      if (snapshot.hasData) {
                        _list = snapshot.data;
                        return PlaylistVideoList(
                          bloc: _bloc,
                          items: snapshot.data,
                        playVideo: playVideo,
                        );
                      } else if (snapshot.hasError) {
                        return ErrorView(tryAgainFunction: _tryAgain);
                      } else {
                        return const SizedBox();
                      }
                    }),
                StreamBuilder(
                    initialData: false,
                    stream: _bloc.isLoading,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return snapshot.data ? LoadingView() : const SizedBox();
                    }),
                StreamBuilder(
                  initialData: false,
                  stream: _bloc.isEmpty,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.data ? EmptyView() : const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
          playListId: widget.playlistItem.id,
        );
      }),
    );
  }
}

