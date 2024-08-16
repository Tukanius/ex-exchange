import 'package:wx_exchange_flutter/models/notify.dart';
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

  updateReceiver(Receiver data, String id) async {
    var res = await put('/receiver/$id', data: data.toJson());
    return res;
  }

  deleteReceiver(String id) async {
    var res = await put('/receiver/del/$id');
    return res;
  }

  getNotification(ResultArguments resultArguments) async {
    var res = await get('/notification',
        handler: true, data: resultArguments.toJson());
    return Result.fromJson(res, Notify.fromJson);
  }

  seenNot(String id) async {
    var res = await get('/notification/$id', handler: false);
    return res;
  }
}
