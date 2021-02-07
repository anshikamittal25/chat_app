String getChatRoomID(String a, String b) {
  if (a.hashCode < b.hashCode) {
    return '$a-$b';
  } else {
    return '$b-$a';
  }
}
