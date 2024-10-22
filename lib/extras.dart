extension SafeAccessList on List<dynamic> {
  dynamic getValueAtIndex(int index) {
    return (index >= 0 && index < length) ? this[index] : null;
  }
}
