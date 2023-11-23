import 'package:uuid/uuid.dart';

class UniqueHelper {
  static createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static createUniqueV4Id() {
    var id = const Uuid();
    return id.v4();
  }
}
