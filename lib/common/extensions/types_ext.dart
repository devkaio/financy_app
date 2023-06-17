extension BoolExt on bool {
  int toInt() => this ? 1 : 0;
}

extension StringExt on String {
  bool toBool() => this == 'true' ? true : false;
}
