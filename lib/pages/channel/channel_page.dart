import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_app/common/error_view.dart';
import 'package:youtube_app/common/loading_view.dart';
import 'package:youtube_app/models/channel_model.dart';
import 'package:youtube_app/pages/channel/channel_bloc.dart';
import 'package:youtube_app/pages/playlist/list/playlist_list_component.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_component.dart';
import 'package:youtube_app/utils/dialog_utils.dart';

class ChannelPage extends StatefulWidget {
  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage>
    with SingleTickerProviderStateMixin {
  static String _channelId = 'your channel id';

  static String _apiKey = 'your api key';

  static Color _selectedTabColor = Colors.black.withOpacity(0.75);
  static Color _unSelectedTabColor = Colors.black.withOpacity(0.50);

  ChannelBloc _bloc;
  StreamSubscription _streamSubscription;
  TabController _tabController;
  int _selectedTab = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = ChannelBloc();
      _bloc.getChannel(_channelId, _apiKey);
      _tabController = TabController(vsync: this, length: 2);

      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {
            _selectedTab = _tabController.index;
          });
        }
      });
      _streamSubscription =
          _bloc.channelSubject.listen((_) {}, onError: (error) {
        DialogUtils.showErrorDialog(context, error, onRetryTap: _tryAgain);
      });
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
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _bloc.channelSubject,
              builder: (BuildContext context, AsyncSnapshot<Channel> snapshot) {
                Channel item = snapshot.data;
                if (snapshot.hasData) {
                  if (snapshot.data.itemList != null) {
                    ChannelItem channelItem = item.itemList.first;
                    return DefaultTabController(
                        length: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 48.0),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.redAccent
                                              .withOpacity(0.50),
                                          radius: 45.0,
                                          backgroundImage: channelItem
                                                      .snippet
                                                      ?.thumbnails
                                                      ?.highItem
                                                      ?.url !=
                                                  null
                                              ? NetworkImage(channelItem.snippet
                                                  .thumbnails.highItem.url)
                                              : null,
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                channelItem.snippet.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (channelItem.statistics
                                                      .subscriberCount !=
                                                  '0')
                                                Text(
                                                  '${int.parse(channelItem.statistics.subscriberCount)} Subscribers',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.withOpacity(0.05),
                                    child: TabBar(
                                      tabs: [
                                        Text(
                                          'Videos',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: _selectedTab == 0
                                                      ? _selectedTabColor
                                                      : _unSelectedTabColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Playlists',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: _selectedTab == 1
                                                      ? _selectedTabColor
                                                      : _unSelectedTabColor),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      indicatorColor: Colors.redAccent,
                                      controller: _tabController,
                                      labelPadding: const EdgeInsets.all(16.0),
                                      indicatorWeight: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _tabController,
                                  children: <Widget>[
                                    PlaylistVideoComponent(
                                      apiKey: _apiKey,
                                      playlistId:
                                          channelItem.contentDetails.uploads,
                                    ),
                                    PlaylistListComponent(
                                        apiKey: _apiKey, channelId: _channelId),
                                  ]),
                            )
                          ],
                        ));
                  } else {
                    return SizedBox();
                  }
                } else if (snapshot.hasError) {
                  return ErrorView(
                      error: snapshot.data, tryAgainFunction: _tryAgain);
                } else {
                  return const SizedBox();
                }
              }),
          StreamBuilder(
              initialData: false,
              stream: _bloc.loadingSubject,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return snapshot.data ? LoadingView() : const SizedBox();
              }),
        ],
      ),
    );
  }

  void _tryAgain() {
    _bloc.getChannel(_channelId, _apiKey);
  }
}
