import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/models/playlist_model.dart';

class PlaylistListCard extends StatelessWidget {
  final PlaylistItem item;
  static const EdgeInsets cardMargin = const EdgeInsets.all(8.0);
  static const EdgeInsets contentPadding = const EdgeInsets.all(10.0);

  const PlaylistListCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width/2.5;
    double _height = _width*3/4;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (item.snippet?.thumbnails?.highItem?.url != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Image.network(
                    item.snippet.thumbnails.highItem.url ?? '',
                    height: _height,
                    width: _width,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: _width-(_width/3),
                    child: Container(
                      height: _height-32,
                      width: _width/3,
                      padding: contentPadding,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black26
                                .withOpacity(0.60),
                          ],
                          stops: [0.0, 1.0],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                        ),

                      ),
                      child:  Column(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children: [
                          Text(
                            '${item.contentDetails.itemCount}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 4,),
                          Icon(Icons.playlist_play_outlined, size: _height/5, color: Colors.white,),
                        ],),
                    ),
                  ),

                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                      item.snippet.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption

                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      '${item.snippet.channelTitle}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
