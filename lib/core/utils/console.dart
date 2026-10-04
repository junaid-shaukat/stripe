import 'dart:developer' as developer;

enum LogMode { debug, live }

class Console {
  final LogMode _logMode;

  Console(this._logMode);

  final String _reset = '\x1B[0m';
  final String _red = '\x1B[31m';
  final String _green = '\x1B[32m';
  final String _yellow = '\x1B[33m';
  final String _blue = '\x1B[34m';
  final String _magenta = '\x1B[35m';
  final String _cyan = '\x1B[36m';
  final String _white = '\x1B[37m';

  void _print(
    dynamic message,
    String name,
    String color,
    StackTrace? stackTrace,
  ) {
    developer.log(
      "$message",
      name: _applyColor(name, color),
      stackTrace: stackTrace,
    );
  }

  void force(
    dynamic message, {
    String name = '',
    String color = 'green',
    StackTrace? stackTrace,
  }) {
    _print(_applyColor(message, color), name, color, stackTrace);
  }

  void log(
    dynamic message, {
    String name = '',
    String color = 'green',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void logPrint(
    Object message, {
    String name = '',
    String color = 'magenta',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void internet(
    dynamic message, {
    String name = '',
    String color = 'magenta',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void intent(
    dynamic message, {
    String name = '',
    String color = 'cyan',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void stripe(
    dynamic message, {
    String name = '',
    String color = 'red',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void authentication(
    dynamic message, {
    String name = '',
    String color = 'red',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void custom(
    dynamic message, {
    String name = '',
    String color = 'blue',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void error(
    dynamic message, {
    String name = '',
    String color = 'red',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
      _print(_applyColor(trace, color), name, color, stackTrace);
    }
  }

  void trace(
    dynamic message, {
    String name = '',
    String color = 'blue',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void debug(
    dynamic message, {
    String name = '',
    String color = 'magenta',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void info(
    dynamic message, {
    String name = '',
    String color = 'green',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  void warn(
    dynamic message, {
    String name = '',
    String color = 'yellow',
    StackTrace? stackTrace,
  }) {
    if (_logMode == LogMode.debug) {
      _print(_applyColor(message, color), name, color, stackTrace);
    }
  }

  String _applyColor(dynamic message, String color) {
    switch (color) {
      case 'red':
        return '$_red$message$_reset';
      case 'green':
        return '$_green$message$_reset';
      case 'yellow':
        return '$_yellow$message$_reset';
      case 'blue':
        return '$_blue$message$_reset';
      case 'magenta':
        return '$_magenta$message$_reset';
      case 'cyan':
        return '$_cyan$message$_reset';
      case 'white':
      default:
        return '$_white$message$_reset';
    }
  }
}

Console console = Console(LogMode.debug);
