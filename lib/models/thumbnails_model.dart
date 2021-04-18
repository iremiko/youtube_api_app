class Thumbnails{
  PhotoItem defaultItem;
  PhotoItem mediumItem;
  PhotoItem highItem;

  Thumbnails.fromJson(Map<String, dynamic> json) {
    defaultItem = json['default'] != null ? PhotoItem.fromJson(json['default']) : null;
    mediumItem = json['medium'] != null ? PhotoItem.fromJson(json['medium']) : null;
    highItem = json['high'] != null ? PhotoItem.fromJson(json['high']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.defaultItem != null) {
      data['default'] = this.defaultItem.toJson();
    }
    if (this.mediumItem != null) {
      data['medium'] = this.mediumItem.toJson();
    }
    if (this.highItem != null) {
      data['high'] = this.highItem.toJson();
    }
    return data;
  }
}

class PhotoItem{
  String url;
  int width;
  int height;

  PhotoItem.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
