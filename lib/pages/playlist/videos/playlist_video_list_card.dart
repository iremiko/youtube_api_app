import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_app/models/playlist_item_model.dart';

class PlaylistVideoListCard extends StatelessWidget {
  final PlaylistVideoItem item;
  final Color color;
  final VoidCallback playVideo;
  static const EdgeInsets cardMargin = const EdgeInsets.all(0.0);
  static const EdgeInsets contentPadding = const EdgeInsets.all(16.0);

  const PlaylistVideoListCard(
      {Key key, this.item, this.color = Colors.white, this.playVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width / 2.5;
    double _height = _width * 3 / 4;

    return GestureDetector(
      onTap:  playVideo,
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(),
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                item.snippet.thumbnails?.highItem?.url != null
                    ? Image.network(
                        item.snippet.thumbnails.highItem.url,
                        height: _height,
                        width: _width,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: _height,
                        width: _width,
                        color: Colors.grey.withOpacity(0.25),
                        child: Center(
                          child: Icon(
                            FontAwesomeIcons.heartBroken,
                            size: 30,
                          ),
                        ),
                      ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          item.snippet?.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(fontSize: 16),
                        ),
                        if (item.contentDetails?.videoPublishedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                                timeAgoSinceDate(context,
                                    item.contentDetails.videoPublishedAt),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 14, color: Colors.black12)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String timeAgoSinceDate(BuildContext context, String dateString) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);
    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return 'Last year';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return 'Last month';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
