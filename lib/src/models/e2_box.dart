class E2Box {
  E2Box({
    required this.name,
    required this.isOnline,
    required this.lastHbReceived,
  });

  String name;
  bool isOnline;
  DateTime lastHbReceived;
}
