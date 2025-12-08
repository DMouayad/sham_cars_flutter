bool isValidPhoneNo(String? text) {
  if (text == null) {
    return false;
  }
  final withoutWhiteSpace = text.replaceAll(" ", "");
  final regex = RegExp(r"^[^\+]?\d{10,15}$");
  return regex.hasMatch(withoutWhiteSpace);
  // return RegExp(r'^[^\+]?\d{10,15}$').hasMatch(replaceAll(RegExp(" "), "")) ||
  //     RegExp(r'^\+?\d{12,15}$').hasMatch(replaceAll(RegExp(" "), ""));
}

bool isValidEmail(String? text) {
  if (text == null) {
    return false;
  }
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(text);
}
