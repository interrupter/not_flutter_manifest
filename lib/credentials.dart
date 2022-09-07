//Authorization: Basic

class NotManifestCredentials {
  static final NotManifestCredentials _shared =
      NotManifestCredentials._sharedInstance();
  NotManifestCredentials._sharedInstance();
  factory NotManifestCredentials() => _shared;

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
