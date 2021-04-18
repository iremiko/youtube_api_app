import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.info,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Seems like no data here',
                textAlign: TextAlign.center,
              )
            ]),
      ),
    );
  }
}
