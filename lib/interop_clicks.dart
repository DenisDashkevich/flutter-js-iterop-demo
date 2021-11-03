@JS('ClicksNamespace')
library clicks;

import 'dart:async';
import 'package:js/js.dart';

@JS('DartClickManagerEvent')
class _ClicksManagerEvent {
  external String type;
}

@JS('DartClickManagerCoordinatesChangedEvent')
class _ClicksManagerCoordinatesChangedEvent extends _ClicksManagerEvent {
  external double get x;
  external double get y;
}

@JS('DartClickManagerEventType')
class EventType {
  // ignore: non_constant_identifier_names
  external static String get CoordinatesChanged;
}

typedef _ClicksManagerEventListener = void Function(_ClicksManagerEvent event);

@JS('DartClickManager')
class _ClicksManagerInterop {
  external void addEventListener(
    String event,
    _ClicksManagerEventListener listener,
  );

  external void removeEventListener(
    String event,
    _ClicksManagerEventListener listener,
  );
}

class _EventStreamProvider {
  final _ClicksManagerInterop _eventTarget;
  final List<StreamController<dynamic>> _controllers = [];

  _EventStreamProvider.forTarget(this._eventTarget);

  Stream<T> forEvent<T extends _ClicksManagerEvent>(String eventType) {
    late StreamController<T> controller;
    void _onEventReceived(event) {
      controller.add(event as T);
    }

    final _interropted = allowInterop(_onEventReceived);

    controller = StreamController.broadcast(
      onCancel: () => _eventTarget.removeEventListener(
        eventType,
        _interropted,
      ),
      onListen: () => _eventTarget.addEventListener(
        eventType,
        _interropted,
      ),
    );

    _controllers.add(controller);

    return controller.stream;
  }

  void dispose() {
    _controllers.forEach((controller) => controller.close());
  }
}

class ClickCoordinates {
  final double x;
  final double y;

  ClickCoordinates(this.x, this.y);
}

class ClicksManager {
  late Stream<ClickCoordinates> _clickCoordinates;

  ClicksManager() {
    final interop = _ClicksManagerInterop();
    final _streamProvider = _EventStreamProvider.forTarget(interop);

    _clickCoordinates = _streamProvider
        .forEvent<_ClicksManagerCoordinatesChangedEvent>(
          EventType.CoordinatesChanged,
        )
        .map((event) => ClickCoordinates(event.x, event.y));
  }

  Stream<ClickCoordinates> get clicksCoordinates => _clickCoordinates;
}
