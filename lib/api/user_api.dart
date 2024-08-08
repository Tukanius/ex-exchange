import 'package:wx_exchange_flutter/models/receiver.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/utils/http_request.dart';

class UserApi extends HttpRequest {
  getReceiver(ResultArguments resultArguments) async {
    var res = await get('/receiver', data: resultArguments.toJson());
    return Result.fromJson(res, Receiver.fromJson);
  }

  dan(String id) async {
    var res = await put('/dan/$id');
    return res;
  }
}
