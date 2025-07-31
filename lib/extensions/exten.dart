import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension AdaptiveSizes on double {
  get ht => SizedBox(height: toDouble());
  get wt => SizedBox(width: toDouble());
}

extension Alerts on BuildContext {
  ScaffoldMessengerState get msg => ScaffoldMessenger.of(this);
  showAlert(String message) {
    return msg.showSnackBar(SnackBar(content: Text(message)));
  }
}
