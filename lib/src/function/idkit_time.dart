class IDKitTime {
  // 时间对象
  late DateTime _dateTime;

  /// 获取转换时间对象，否则为当前时间对象
  DateTime get date => _dateTime;

  /// Int 类型时间格式化
  String timeFormat({
    required int time,
    String format = 'yyyy-MM-dd hh:mm:ss',
    TimeType type = TimeType.millisecond,
    String defValue = 'Format fail !!!',
  }) {
    String _result;
    try {
      int _time = time;
      if (type == TimeType.second) {
        _time *= 1000000;
      } else if (type == TimeType.millisecond) {
        _time *= 1000;
      }
      _dateTime = DateTime.fromMicrosecondsSinceEpoch(_time);
      _result = _formatHandle(format);
    } catch (e) {
      return defValue;
    }
    return _result;
  }

  /// String 类型时间格式化
  String stampFormat({
    required String stamp,
    String format = 'yyyy-MM-dd hh:mm:ss',
    TimeType type = TimeType.millisecond,
    String defValue = 'Format fail !!!',
  }) {
    String _result;
    try {
      int? time = int.tryParse(stamp);
      if (time == null) {
        return defValue;
      }
      if (type == TimeType.second) {
        time *= 1000000;
      } else if (type == TimeType.millisecond) {
        time *= 1000;
      }
      _dateTime = DateTime.fromMicrosecondsSinceEpoch(time);
      _result = _formatHandle(format);
    } catch (e) {
      return defValue;
    }
    return _result;
  }

  /// 自定义时间格式化
  String customFarmat({
    int? time,
    String? stamp,
    String format = 'yyyy-MM-dd hh:mm:ss',
    TimeType type = TimeType.millisecond,
    String defValue = 'Format fail !!!',
  }) {
    if (time == null && stamp == null) {
      return defValue;
    } else {
      try {
        if (stamp != null) {
          final int? zipTime = int.tryParse(stamp);
          if (zipTime == null) {
            return defValue;
          }
          time ??= zipTime;
        }

        if (type == TimeType.second) {
          time = time! * 1000000;
        } else if (type == TimeType.millisecond) {
          time = time! * 1000;
        }
        _dateTime = DateTime.fromMicrosecondsSinceEpoch(time!);
        return _formatHandle(format);
      } catch (e) {
        return defValue;
      }
    }
  }

  // 格式处理
  String _formatHandle(String format) {
    final String _format = format
        .replaceAll('yyyy', _yearHandel())
        .replaceAll('yy', _yearHandel(handle: true))
        .replaceAll('MM', _mendZeroHandle(_dateTime.month, mend: true))
        .replaceAll('M', _mendZeroHandle(_dateTime.month))
        .replaceAll('dd', _mendZeroHandle(_dateTime.day, mend: true))
        .replaceAll('d', _mendZeroHandle(_dateTime.day))
        .replaceAll('hh', _mendZeroHandle(_dateTime.hour, mend: true))
        .replaceAll('h', _mendZeroHandle(_dateTime.hour))
        .replaceAll('mm', _mendZeroHandle(_dateTime.minute, mend: true))
        .replaceAll('m', _mendZeroHandle(_dateTime.minute))
        .replaceAll('ss', _mendZeroHandle(_dateTime.second, mend: true))
        .replaceAll('s', _mendZeroHandle(_dateTime.second));
    return _format.trim();
  }

  // 年份处理
  String _yearHandel({bool handle: false}) {
    int year;
    if (handle) {
      year = _dateTime.year % 100;
    } else {
      year = _dateTime.year;
    }
    return year.toString();
  }

  // 补零处理
  String _mendZeroHandle(int value, {bool mend: false}) {
    String mendValue = value.toString();
    if (mend) {
      if (value < 10) {
        mendValue = '0' + mendValue;
      }
    }
    return mendValue;
  }
}

/// 时间单位
///
/// 要转换时间的单位
enum TimeType {
  // 秒
  second,
  // 毫秒
  millisecond,
  // 微秒
  microsecond,
}
