import './interface.dart';
import '../request/request.dart';
import '../response/response.dart';

class NotInterfaceWS implements NotInterface {
  @override
  static Future<NotResponse> request(NotRequest req) async {
    throw Exception('Method is not overriden');
  }

  static bool isUp(NotRequest req) {
    return false;
  }
}
