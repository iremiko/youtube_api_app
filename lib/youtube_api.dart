import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:youtube_app/errors/api_error.dart';
import 'package:youtube_app/errors/status_error.dart';
import 'package:youtube_app/models/channel_model.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/models/playlist_model.dart';
import 'package:youtube_app/models/videos_model.dart';

class YoutubeApi {
  static String baseUrl = 'www.googleapis.com';
  static String basePath = 'youtube/v3';
  static http.Client client;
  final log = Logger('YoutubeApi');
  String channelsPath = 'channels';
  String playlistPath = 'playlists';
  String playlistItemPath = 'playlistItems';
  String videosPath = 'videos';

  //GET CHANNEL
  Future<Channel> getChannel(String channelId, String apiKey) async {
    Map<String, String> params = {
      'id': channelId,
      'part': 'snippet,statistics,contentDetails',
      'key': apiKey,
    };
    Uri uri = createUri('$channelsPath', params);
    final response = await get(uri);

    final jsonDecoded = json.decode(response.body);

    final result = Channel.fromJson(jsonDecoded);

    return result;
  }

  //GET PLAYLIST
  Future<Playlist> getPlaylistList(
      String channelId, String apiKey, String pageToken,
      {int perPage = 10}) async {
    Map<String, String> params = {
      'channelId': channelId,
      'part': 'snippet,contentDetails',
      'key': apiKey,
      'maxResults': perPage.toString(),
      'pageToken': pageToken ?? ''
    };
    Uri uri = createUri('$playlistPath', params);
    final response = await get(uri);

    final jsonDecoded = json.decode(response.body);
    final result = Playlist.fromJson(jsonDecoded);

    return result;
  }

  //GET PLAYLIST ITEMS
  Future<PlaylistVideos> getPlaylistItems(
      String playlistId, String apiKey, String pageToken,
      {int perPage = 10}) async {
    Map<String, String> params = {
      'playlistId': playlistId,
      'part': 'snippet,contentDetails',
      'key': apiKey,
      'maxResults': perPage.toString(),
      'pageToken': pageToken ?? ''
    };
    Uri uri = createUri('$playlistItemPath', params);
    final response = await get(uri);

    final jsonDecoded = json.decode(response.body);
    final result = PlaylistVideos.fromJson(jsonDecoded);
    if (jsonDecoded['error'] != null) {
      throw jsonDecoded['error']['message'];
    }
    return result;
  }

//GET VIDEOS
  Future<Videos> getVideos(String videoId, String apiKey) async {
    Map<String, String> params = {
      'id': videoId,
      'part': 'snippet,contentDetails',
      'key': apiKey,
    };
    Uri uri = createUri('$videosPath', params);
    final response = await get(uri);

    final jsonDecoded = json.decode(response.body);

    final result = Videos.fromJson(jsonDecoded);

    return result;
  }

  Uri createUri(String unEncodedPath, [Map<String, String> queryParameters]) {
    return Uri.https(baseUrl, '$basePath/$unEncodedPath', queryParameters);

  }

  Future<http.Response> get(Uri uri) async {
    final response = await http.get(uri, headers: {
      HttpHeaders.acceptHeader: 'application/json',
    }).timeout(Duration(seconds: 20));
    log.info(uri.toString());
    if (response.statusCode == 200) {
      return response;
    }
    else if(response.statusCode == 404){
      final Map<String, dynamic> responseMap = json.decode(response.body);
     throw APIError.fromJson(responseMap);
    }
    else {
      throw StatusError(response.statusCode, response.body);
    }

  }

}
