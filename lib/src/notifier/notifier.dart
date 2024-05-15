class _ListenerWithFilter {
  final Function(dynamic) listener;

  _ListenerWithFilter(this.listener);
}

class EventsNotifier<T> {
  int _listenerIDCounter = 0;
  final int _maxListenerID = -1 >>> 1;
  final Map<int, _ListenerWithFilter> _listeners = {};

  int newListenerID() {
    _listenerIDCounter++;
    if (_listenerIDCounter >= _maxListenerID) {
      _listenerIDCounter = 0;
    }
    return _listenerIDCounter;
  }

  int addListener(Function(dynamic data) listener) {
    final listenerID = newListenerID();
    _listeners[listenerID] = _ListenerWithFilter(listener);
    // debugPrint('Added listener with ID: $listenerID');
    return listenerID;
  }

  void removeListener(int listenerID) {
    _listeners.remove(listenerID);
    // debugPrint('Removed listener with ID: $listenerID');
  }

  void removeAllListeners() {
    _listeners.clear();
    // debugPrint('Removed all listeners');
  }

  void emit(data) {
    _listeners.values.forEach((listener) => listener.listener(data));
  }
}
