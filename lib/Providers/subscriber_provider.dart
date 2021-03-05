import 'package:flutter/cupertino.dart';

import '../models/subscriber.dart';

class SubscriberProvider with ChangeNotifier {

  Subscriber _subscriber;

  Subscriber get subscriber{
    return _subscriber;
  }

  void setSubscriber(Subscriber newSubscriber){
    _subscriber = newSubscriber;
    notifyListeners();
  }
}