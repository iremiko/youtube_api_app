import 'package:youtube_app/models/thumbnails_model.dart';

class Channel{
  String kind;
  String eTag;
  List<ChannelItem> itemList;

  Channel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    eTag = json['etag'];
    if (json['items'] != null) {
      itemList = List<ChannelItem>();
      json['items']
          .forEach((m) => itemList.add(ChannelItem.fromJson(m)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['kind'] = this.kind;
    data['etag'] = this.eTag;
    if (itemList != null) {
      data['items'] = itemList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChannelItem{
String kind;
String etag;
String id;
ChannelSnippet snippet;
ChannelContentDetails contentDetails;
Statistics statistics;

ChannelItem.fromJson(Map<String, dynamic> json) {
  kind = json['kind'];
  etag = json['etag'];
  id = json['id'];
  snippet = json['snippet'] != null ? ChannelSnippet.fromJson(json['snippet']) : null;
  contentDetails = json['contentDetails'] != null ? ChannelContentDetails.fromJson(json['contentDetails']) : null;
  statistics = json['statistics'] != null ? Statistics.fromJson(json['statistics']) : null;

}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = Map<String, dynamic>();
  data['kind'] = this.kind;
  data['etag'] = this.etag;
  data['id'] = this.id;
  if (this.snippet != null) {
    data['snippet'] = this.snippet.toJson();
  }
  if (this.contentDetails != null) {
    data['contentDetails'] = this.contentDetails.toJson();
  }
  if (this.statistics != null) {
    data['statistics'] = this.statistics.toJson();
  }
  return data;
}
}

class ChannelSnippet{
  String title;
  String description;
  String publishedAt;
  Thumbnails thumbnails;

  ChannelSnippet.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    publishedAt = json['publishedAt'];
    thumbnails = json['thumbnails'] != null ? Thumbnails.fromJson(json['thumbnails']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['publishedAt'] = this.publishedAt;
    if (this.thumbnails != null) {
      data['thumbnails'] = this.thumbnails.toJson();
    }
    return data;
  }
}
class ChannelContentDetails {
  String uploads;
  ChannelContentDetails.fromJson(Map<String, dynamic> json) {
    uploads = json['relatedPlaylists']['uploads'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['relatedPlaylists']['uploads'] = this.uploads;
    return data;
  }
}

class Statistics {
  String viewCount;
  String subscriberCount;
  String videoCount;
  Statistics.fromJson(Map<String, dynamic> json) {
    viewCount = json['viewCount'];
    subscriberCount = json['subscriberCount'];
    videoCount = json['videoCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['viewCount'] = this.viewCount;
    data['subscriberCount'] = this.subscriberCount;
    data['videoCount'] = this.videoCount;
    return data;
  }
}

