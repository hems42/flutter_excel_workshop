extension MyStringExtension on String {
  bool containNumber() => this.contains(new RegExp(r'[0-9]'));
    
}
