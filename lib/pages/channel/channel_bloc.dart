
import 'package:rxdart/rxdart.dart';
import 'package:youtube_app/models/channel_model.dart';
import 'package:youtube_app/youtube_api.dart';

class ChannelBloc {
  final YoutubeApi _youtubeApi;
  ChannelBloc({
    YoutubeApi youtubeApi,
  })  : _youtubeApi = youtubeApi ?? YoutubeApi();


  final channelSubject = BehaviorSubject<Channel>();

  final loadingSubject = BehaviorSubject<bool>(seedValue: false);



  getChannel(String channelId, String apiKey) async {
    loadingSubject.add(true);
    try {

      Channel channel = await _youtubeApi.getChannel(channelId, apiKey);
      channelSubject.add(channel);
    } catch (e) {
      channelSubject.addError(e);
    } finally {
      loadingSubject.add(false);
    }
  }

  void dispose() {
    channelSubject.close();
    loadingSubject.close();
  }
}
