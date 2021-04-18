import 'package:youtube_app/models/page_info_model.dart';
import 'package:youtube_app/models/thumbnails_model.dart';

class Playlist{
  String kind;
  String eTag;
  List<PlaylistItem> itemList;
  String prevPageToken;
  String nextPageToken;
  PageInfo pageInfo;

  Playlist.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    eTag = json['etag'];
    prevPageToken = json['prevPageToken'];
    nextPageToken = json['nextPageToken'];
    pageInfo = json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
    if (json['items'] != null) {
      itemList = List<PlaylistItem>();
      json['items']
          .forEach((m) => itemList.add(PlaylistItem.fromJson(m)));
    }
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
    if (itemList != null) {
      data['items'] = itemList.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PlaylistItem{
String kind;
String eTag;
String id;
PlaylistSnippet snippet;
PlaylistContentDetails contentDetails;
PlaylistItem.fromJson(Map<String, dynamic> json) {
  kind = json['kind'];
  eTag = json['etag'];
  id = json['id'];
  snippet = json['snippet'] != null ? PlaylistSnippet.fromJson(json['snippet']) : null;
  contentDetails = json['contentDetails'] != null ? PlaylistContentDetails.fromJson(json['contentDetails']) : null;
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = Map<String, dynamic>();
  data['kind'] = this.kind;
  data['etag'] = this.eTag;
  data['id'] = this.id;
  if (this.snippet != null) {
    data['snippet'] = this.snippet.toJson();
  }
  if (this.contentDetails != null) {
    data['contentDetails'] = this.contentDetails.toJson();
  }
  return data;
}
}

class PlaylistSnippet{
  String channelId;
  String title;
  String description;
  String publishedAt;
  String channelTitle;
  Thumbnails thumbnails;

  PlaylistSnippet.fromJson(Map<String, dynamic> json) {
    channelId = json['channelId'];
    title = json['title'];
    description = json['description'];
    publishedAt = json['publishedAt'];
    channelTitle = json['channelTitle'];
    thumbnails = json['thumbnails'] != null ? Thumbnails.fromJson(json['thumbnails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['channelId'] = this.channelId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['publishedAt'] = this.publishedAt;
    data['channelTitle'] = this.channelTitle;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails.toJson();
    }
    return data;
  }

}
class PlaylistContentDetails {
  int itemCount;
  PlaylistContentDetails.fromJson(Map<String, dynamic> json) {
    itemCount = json['itemCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['itemCount'] = this.itemCount;
    return data;
  }
}