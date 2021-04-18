import 'package:flutter/material.dart';
import 'package:youtube_app/errors/api_error.dart';
import 'package:youtube_app/errors/status_error.dart';
import 'package:youtube_app/utils/error_utils.dart';
class ErrorView extends StatelessWidget {
  final Function tryAgainFunction;
  final dynamic error;
  const ErrorView({Key key, this.tryAgainFunction, this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if(error is StatusError)
          Flexible(
              child:
              SingleChildScrollView(padding: EdgeInsets.all(16.0), child: Text(ErrorUtils.getFriendlyErrorMessage(context, error)))),
          if(error is APIError)
            Flexible(
                child:
                SingleChildScrollView( padding: EdgeInsets.all(16.0),child: Text(error.toString()))),
          SizedBox(height: 8.0),
          tryAgainFunction != null
              ? RaisedButton(
            child: Text('Try Again'),
            onPressed: tryAgainFunction,
          )
              : SizedBox(),
        ],
      ),
    );
  }

}

