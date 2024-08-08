import 'package:wx_exchange_flutter/models/general.dart';
import 'package:wx_exchange_flutter/utils/http_request.dart';

class GeneralApi extends HttpRequest {
  init(bool hander) async {
    var res = await get('/general/init', handler: hander);
    return General.fromJson(res as Map<String, dynamic>);
  }
}
