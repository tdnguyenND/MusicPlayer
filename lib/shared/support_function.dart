List<List<dynamic>> splitList(List list) {
  var chunks = <List<dynamic>>[];
  for (var i = 0; i < list.length; i += 10) {
    chunks.add(list.sublist(i, i + 10 > list.length ? list.length : i + 10));
  }
  print('chunks = $chunks');
  return chunks;
}
