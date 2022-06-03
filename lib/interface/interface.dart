import '../request/request.dart';
import '../response/response.dart';

abstract class NotInterface {
  static Future<NotResponse> request(NotRequest req) async {
    throw Exception(
        'NotInterface.request should be overriden by not abstract class');
  }

  //if interface is usable
  static bool isUp(NotRequest req) {
    return false;
  }

  static String getModelName(NotRequest req) {
    return req.getModelName();
  }
}
