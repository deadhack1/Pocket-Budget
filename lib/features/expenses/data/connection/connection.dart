// Export the right implementation for the current platform:
export 'native.dart' if (dart.library.html) 'web.dart';
