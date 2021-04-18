import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_bloc.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_card.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_item.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_item_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

///ListView which controls pagination

class YoutubeVideoList extends StatefulWidget {
  final PlaylistVideoListBloc bloc;
  final List<ListItem> items;
  final int currentIndex;

  YoutubeVideoList({
    this.bloc,
    this.items,
    Key key,
    this.currentIndex,
  }) : super(key: key);

  @override
  _YoutubeVideoListState createState() {
    return _YoutubeVideoListState();
  }
}

class _YoutubeVideoListState extends State<YoutubeVideoList> {
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();
  YoutubePlayerController _controller;
  List<PlaylistVideoItem> _videoList = [];
  bool _showList = true;
  int _currentIndex;
  bool _isPlayerReady = false;
  YoutubeMetaData _videoMetaData;
  final log = Logger('_VideosListState');

  @override
  void initState() {
    log.info("------initState: VideosList");
    if (widget.currentIndex != null) _currentIndex = widget.currentIndex;
    getVideoList();
    setUpData();
    itemPositionsListener.itemPositions.addListener(_handleNextPageLoading);
    super.initState();
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_handleNextPageLoading);
    super.dispose();
  }

  @override
  void didUpdateWidget(YoutubeVideoList oldWidget) {
    log.info("------didUpdateWidget: YoutubeVideoList");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    log.info("------build: YoutubeVideoList");

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _videoMetaData.title ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (_) {
          playVideo(_currentIndex+1);
        },
      ),
      builder: (context, player) => Column(
        children: [
          player,
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(_videoList[_currentIndex].snippet.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white)),
                          Text('${_currentIndex + 1}/${widget.items.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(color: Colors.white))
                        ],
                      ),
                    ),
                    IconButton(
                        alignment: Alignment.centerRight,
                        icon: Icon(_showList
                            ? FontAwesomeIcons.chevronUp
                            : FontAwesomeIcons.chevronDown),
                        onPressed: () {
                          setState(() {
                            _showList = !_showList;
                          });
                        })
                  ],
                ),
                if (_showList)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if(_isPlayerReady)
                          playVideo(_currentIndex--);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if(_isPlayerReady)
                          playVideo(_currentIndex++);
                        },
                      ),
                    ],
                  )
              ],
            ),
          ),
          if(!_showList)
            Expanded(
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(_videoList[_currentIndex].snippet.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6),
                    SizedBox(height: 4.0,),
                    Text(_videoList[_currentIndex].snippet.description)
                  ]),
            ),
          if (_showList)
            Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                initialScrollIndex: _currentIndex,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return PlaylistVideoListItemView(
                      _onRetry, widget.items[index], _buildItem, index);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _handleNextPageLoading() {
    //Start loading next page when visible content 500 pixels close
    //to end of the scroll.
    if (itemPositionsListener.itemPositions.value.last.index <
        widget.items.length) {
      widget.bloc.nextPageSink.add(null);
    }
  }

  void _onRetry() {
    widget.bloc.nextPageRetrySink.add(null);
  }

  Widget _buildItem(PlaylistVideoItem item, int index) {
    return PlaylistVideoListCard(
        playVideo: (){
          playVideo(index);
        },
        item: item,
        color: _currentIndex == index
            ? Colors.red.withOpacity(0.05)
            : Colors.transparent);
  }
  List<PlaylistVideoItem>  getVideoList() {
    for (var videosItem in widget.items)
      if (videosItem is PlaylistVideoListItem) {
        PlaylistVideoListItem item = videosItem;
        _videoList.add(item.playlistVideoItem);
      }
    return _videoList;
  }
  setUpData() {
    _controller = YoutubePlayerController(
      initialVideoId: _videoList[_currentIndex].contentDetails.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: true,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
      });
    }
  }


   playVideo(int index) {
    setState(() {
      _currentIndex = index;
    });
    _controller.load(_videoList[_currentIndex].contentDetails.videoId);
    if (_isPlayerReady) {
      _controller.play();
    }
    itemScrollController.scrollTo(
      duration: Duration(microseconds: 5000),
      index: _currentIndex,
      curve: Curves.linear,
    );
  }



  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller?.pause();
    super.deactivate();
  }
}
