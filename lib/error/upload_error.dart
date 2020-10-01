class UploadError extends Error {
  final Object message;

  UploadError({this.message});

  String toString() {
    if (message != null) {
      return "Upload failed: ${Error.safeToString(message)}";
    }
    return "Upload failed";
  }
}
