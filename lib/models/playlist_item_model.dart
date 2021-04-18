import 'package:youtube_app/models/page_info_model.dart';
import 'package:youtube_app/models/thumbnails_model.dart';

class PlaylistVideos {
  String kind;
  String eTag;
  List<PlaylistVideoItem> itemList;
  String prevPageToken;
  String nextPageToken;
  PageInfo pageInfo;

  PlaylistVideos.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    eTag = json['etag'];
    prevPageToken = json['prevPageToken'];
    nextPageToken = json['nextPageToken'];
    pageInfo =
        json['pageInfo'] != null ? PageInfo.fromJson(json['pageInfo']) : null;
    if (json['items'] != null) {
      itemList = List<PlaylistVideoItem>();
      json['items'].forEach((m) => itemList.add(PlaylistVideoItem.fromJson(m)));
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
class PlaylistVideoSnippet {
  String channelId;
  String title;
  String description;
  String publishedAt;
  Thumbnails thumbnails;
  String channelTitle;
  String playlistId;

  PlaylistVideoSnippet.fromJson(Map<String, dynamic> json) {
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

class PlaylistVideoItem {
  String kind;
  String eTag;
  String id;
  PlaylistVideoSnippet snippet;
  PlaylistVideoContentDetails contentDetails;

  PlaylistVideoItem.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    eTag = json['etag'];
    id = json['id'];
    snippet =
    json['snippet'] != null ? PlaylistVideoSnippet.fromJson(json['snippet']) : null;
    contentDetails = json['contentDetails'] != null
        ? PlaylistVideoContentDetails.fromJson(json['contentDetails'])
        : null;
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
  class PlaylistVideoContentDetails {
  String videoId;
  String videoPublishedAt;
  String duration;

  PlaylistVideoContentDetails.fromJson(Map<String, dynamic> json) {
  videoId = json['videoId'];
  videoPublishedAt = json['videoPublishedAt'];
  duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = Map<String, dynamic>();
  data['videoId'] = this.videoId;
  data['videoPublishedAt'] = this.videoPublishedAt;
  data['duration'] = this.duration;
  return data;
  }
  }


