@JS('ConnectionNamespace')
library connection;

import 'package:js/js.dart';

@JS('DartConnectionManager')
class ConnectionManager {
  external ConnectionManager(ConnectionManagerOptions connectionManagerOptions);

  external String get currentEffectiveType;

  external double get currentDownlink;
}

typedef ConnectionChangedHandler = void Function();

@JS()
@anonymous
class ConnectionManagerOptions {
  external ConnectionChangedHandler get connectionChangeHandler;

  external factory ConnectionManagerOptions({
    ConnectionChangedHandler connectionChangeHandler,
  });
}
