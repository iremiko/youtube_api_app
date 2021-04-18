import 'package:youtube_app/models/page_info_model.dart';
import 'package:youtube_app/models/playlist_item_model.dart';
import 'package:youtube_app/models/thumbnails_model.dart';

class Videos {
  String kind;
  String eTag;
  PlaylistVideoItem item;
  String prevPageToken;
  String nextPageToken;
  PageInfo pageInfo;


  Videos({this.kind, this.eTag, this.item, this.prevPageToken,
    this.nextPageToken, this.pageInfo});

  Videos.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    eTag = json['etag'];
    prevPageToken = json['prevPageToken'];
    nextPageToken = json['nextPageToken'];
    pageInfo =
    json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
    // if (json['items'] != null) {
    //   itemList = List<PlaylistItemsItem>();
    //   json['items'].forEach((m) => itemList.add(PlaylistItemsItem.fromJson(m)));
    // }
    item = json['items'][0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kind'] = this.kind;
    data['etag'] = this.eTag;
    data['prevPageToken'] = this.prevPageToken;
    data['nextPageToken'] = this.nextPageToken;
    if (this.pageInfo != null) {
      data['pageInfo'] = this.pageInfo.toJson();
    }
    // if (itemList != null) {
    //   data['items'] = itemList.map((v) => v.toJson()).toList();
    // }
    data['items'][0] = this.item;
    return data;
  }
}
class VideosSnippet {
  String channelId;
  String title;
  String description;
  String publishedAt;
  Thumbnails thumbnails;
  String channelTitle;
  String playlistId;

  VideosSnippet.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    channelTitle = json['channelTitle'];
    playlistId = json['playlistId'];
    title = json['title'];
    description = json['description'];
    publishedAt = json['publishedAt'];
    thumbnails = json['thumbnails'] != null
        ? Thumbnails.fromJson(json['thumbnails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['channelTitle'] = this.channelTitle;
    data['playlistId'] = this.playlistId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['publishedAt'] = this.publishedAt;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails.toJson();
    }
    return data;
  }
}