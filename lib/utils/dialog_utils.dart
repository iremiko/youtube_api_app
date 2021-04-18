import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:youtube_app/errors/status_error.dart';
import 'package:youtube_app/utils/error_utils.dart';

class DialogUtils {
  static final log = Logger('DialogUtils');

  static void showErrorDialog(BuildContext context, dynamic error,
      {Function onRetryTap}) {
    log.info(error.toString());
    String message;
     if (error is StatusError) {
      message = error.exception;
    } else {
      message = ErrorUtils.getFriendlyErrorMessage(context, error);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                Text(message, style: Theme.of(context).textTheme.subtitle1),
            actions: <Widget>[
              OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: Theme.of(context).textTheme.bodyText2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Colors.black87),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  onRetryTap();
                },
                child: Text(
                  'Try Again',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                color: Theme.of(context).backgroundColor,
              ),
            ],
          );
        });
  }

  static void showInfoDialog(BuildContext context, String message,
      {String title, bool barrierDismissible = true, onTapButtonAction}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null ? Text(title) : SizedBox(),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                  if (onTapButtonAction != null) onTapButtonAction();
                },
              ),
            ],
          );
        });
  }
}
