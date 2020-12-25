List<List<dynamic>> splitList(List list) {
  var chunks = <List<dynamic>>[];
  for (var i = 0; i < list.length; i += 10) {
    chunks.add(list.sublist(i, i + 10 > list.length ? list.length : i + 10));
  }
  return chunks;
}

bool matchWithoutCaseSensitive(String lookFor, String lookIn){
  if(lookIn == null) return false;
  return RegExp(lookFor.toLowerCase()).hasMatch(lookIn.toLowerCase());
}