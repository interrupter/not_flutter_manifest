//Authorization: Basic

class NotManifestCredatials {
  static final NotManifestCredatials _shared =
      NotManifestCredatials._sharedInstance();
  NotManifestCredatials._sharedInstance();
  factory NotManifestCredatials() => _shared;

  String _token = '';

  void byBearer(String token) {
    _token = token;
  }

  void invalidateBearer() {
    _token = '';
  }

  getHeaders() {
    Map<String, String> headers = {};
    if (_token.isNotEmpty) {
      headers.addEntries([MapEntry('Authorization', 'Bearer $_token')]);
    }
    return headers;
  }
}
