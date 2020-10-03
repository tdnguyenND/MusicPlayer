class SongExistedInPlaylistError extends Error {
  final Object message;

  SongExistedInPlaylistError({this.message});

  @override
  String toString() {
    if (message != null) {
      return "Song Existed Exception: ${Error.safeToString(message)}";
    }
    return "Song Existed Exception";
  }
}
