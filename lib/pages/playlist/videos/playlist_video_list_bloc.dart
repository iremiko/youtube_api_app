import 'dart:async';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_app/common/list_item.dart';
import 'package:youtube_app/common/stream_subscriber_mixin.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/pages/playlist/videos/playlist_video_list_item.dart';
import 'package:youtube_app/youtube_api.dart';

class PlaylistVideoListBloc with StreamSubscriberMixin {
  PlaylistVideoListBloc({
    YoutubeApi youtubeApi,
    String playlistId,
    String apiKey,
  }) {
    _youtubeApi = youtubeApi ?? YoutubeApi();
    _playlistId = playlistId;
    _apiKey = apiKey;

    listen(_firstPageController.stream, (_) {
      _getFirstPage();
    });

    listen(_nextPageController.stream, (_) {
      _getNextPage();
    });

    listen(_nextPageRetryController.stream, (_) {
      _retryLoadingNextPage();
    });

    listen(_refreshController.stream, (completer) {
      _getFirstPage(refreshCompleter: completer);
    });
  }

  YoutubeApi _youtubeApi;
  String _playlistId;
  String _apiKey;
  final log = Logger('PlaylistVideoListBloc');

//Output Streams
  Stream<List<ListItem>> get data => _dataSubject.stream;


  Stream<bool> get isLoading => _isLoadingSubject.stream;

  Stream<bool> get isEmpty => _isEmptySubject.stream;

//Input Streams
  Sink<void> get firstPageSink => _firstPageController.sink;

  Sink<void> get nextPageSink => _nextPageController.sink;

  Sink<void> get nextPageRetrySink => _nextPageRetryController.sink;

  Sink<Completer<Null>> get refreshSink => _refreshController.sink;

//Stream Controllers
  final _firstPageController = StreamController<void>();

  final _nextPageController = StreamController<void>();

  final _nextPageRetryController = StreamController<void>();

  final _refreshController = StreamController<Completer<Null>>();

  final _dataSubject = BehaviorSubject<List<ListItem>>();

  final _isLoadingSubject = BehaviorSubject<bool>();

  final _isEmptySubject = BehaviorSubject<bool>(seedValue: false);

  List<ListItem> _listItems = <ListItem>[];
  String _nextPage = '';
  bool _isNextLoading = false;

// If refreshCompleter is provided, that means user trigger RefreshIndicator
// In that case RefreshIndicator's progress is displayed, no need to display
// our first page loading progress indicator.

// The cache is also cleared when refreshed.

// The refreshCompleter should call complete method to let RefreshIndicator
// know that we're done with our background work.

  void _getFirstPage({Completer<Null> refreshCompleter}) async {
    _isEmptySubject.add(false);
    log.info('getFirstPage is called---------');
    if (refreshCompleter != null) {
/*log.info("Clearing cache doesnt work");
      _homeRepository.clearCache();
      imageCache.clear();*/
    } else {
      _isLoadingSubject.add(true);
    }
    _nextPage='';
//to stop next page loading when first page is being loaded
//only make it false if first page is fetched successfully
    _isNextLoading = true;
    _listItems.clear();
    _dataSubject.add(_listItems);

    try {
      PlaylistVideos playlistVideos = await _youtubeApi.getPlaylistItems(_playlistId, _apiKey, _nextPage);
      List<PlaylistVideoItem> list = playlistVideos.itemList;

      if (list.isEmpty) {
        _isEmptySubject.add(true);
      } else {
        _isEmptySubject.add(false);
      }

      _listItems.addAll(list.map((items) => PlaylistVideoListItem(items)));
      _nextPage = playlistVideos.nextPageToken;
      _dataSubject.add(_listItems);
      _isNextLoading = false;
    } catch (error) {
      log.info("ERROR: ${error.toString()}");
      _dataSubject.addError(error);
    } finally {
      if (refreshCompleter != null) {
        refreshCompleter.complete();
      } else {
        _isLoadingSubject.add(false);
      }
    }
  }

// If retry request coming from LoadingFailed item which is the last item
// in the _listItems, this method is called.
// First, LoadingFailed item is removed from the list.
// Then _isNextLoading is set to false to retry again.

  void _retryLoadingNextPage() {
    _listItems.removeLast();
    _isNextLoading = false;
    _getNextPage();
  }

// Check the status of next page loading with _isNextLoading bool
// To avoid making new requests before this one finishes.
  void _getNextPage() async {
    log.info('getNextPage is called---------');
    if (!_isNextLoading) {
      _isNextLoading = true;
      if (_nextPage != null && _nextPage.isNotEmpty) {
        _listItems.add(LoadingItem());
        _dataSubject.add(_listItems);
        try {
          PlaylistVideos playlistVideos = await _youtubeApi.getPlaylistItems(_playlistId, _apiKey, _nextPage);
          List<PlaylistVideoItem> list  = playlistVideos.itemList;
          _listItems.removeLast();

          _listItems.addAll(list.map((items) => PlaylistVideoListItem(items)));

          _nextPage = playlistVideos.nextPageToken;
          _dataSubject.add(_listItems);
          _isNextLoading = false;
        } catch (error) {
          log.info("ERROR: ${error.toString()}");
          if (_listItems.last is LoadingItem) _listItems.removeLast();
          _listItems.add(LoadingFailed(error));
          _dataSubject.add(_listItems);
        }
      }
    }
  }

  /// RefreshIndicator should pass this function to its onRefresh property
  /// To know about the completion status
  Future<Null> refresh() {
    log.info('Refresh is called');
    final completer = Completer<Null>();
    refreshSink.add(completer);
    return completer.future;
  }

  bool isListEmpty() {
    return _listItems.isEmpty;
  }


//bloc user should call this method when widget is disposed
  void dispose() {
    cancelSubscriptions();
    _firstPageController.close();
    _nextPageController.close();
    _nextPageRetryController.close();
    _refreshController.close();
    _isLoadingSubject.close();
    _isEmptySubject.close();
    _dataSubject.close();
  }
}

