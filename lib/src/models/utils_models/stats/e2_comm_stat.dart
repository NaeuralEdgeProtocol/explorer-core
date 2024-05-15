class E2CommStat {
  E2CommStat({
    required this.svr,
    required this.rcv,
    required this.snd,
    required this.act,
    required this.address,
    required this.fails,
    this.error,
    this.errorTime,
  });

  final bool? svr;
  final bool? rcv;
  final bool? snd;
  final double? act;
  final String? address;
  final int? fails;

  /// ???
  final List<String>? error;

  /// ???
  ///
  /// error time?
  final String? errorTime;

  Map<String, dynamic> toMap() {
    return {
      'SVR': svr,
      'RCV': rcv,
      'SND': snd,
      'ACT': act,
      'ADDR': address,
      'FAILS': fails,
      'ERROR': error,
      'ERRTM': errorTime,
    };
  }

  factory E2CommStat.fromMap(Map<String, dynamic> map) {
    List<String>? errorField;
    final errorBody = map['ERROR'];
    if (errorBody != null) {
      if (errorBody.runtimeType == String) {
        /// redundant
        if (errorBody == 'None') {
          errorField = null;
        }
      } else {
        errorField = (errorBody as List).map((e) => e as String).toList();
      }
    }

    String? errorTimeField;
    final errorTimeBody = map['ERRTM'];
    if (errorTimeBody != null) {
      if (errorTimeBody != 'None') {
        errorTimeField = errorTimeBody;
      }
    }

    return E2CommStat(
      svr: map['svr'] as bool?,
      rcv: map['rcv'] as bool?,
      snd: map['snd'] as bool?,
      act: map['act'] as double?,
      address: map['address'] as String?,
      fails: map['fails'] as int?,
      error: errorField,
      errorTime: errorTimeField,
    );
  }
}
