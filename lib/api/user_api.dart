import 'package:wx_exchange_flutter/models/contract.dart';
import 'package:wx_exchange_flutter/models/notify.dart';
import 'package:wx_exchange_flutter/models/receiver.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/models/user.dart';
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

  getContract() async {
    var res = await get('/condition', handler: false);
    return Contract.fromJson(res as Map<String, dynamic>);
  }

  accountDelete(User data) async {
    var res = await put('/user/del', handler: false, data: data.toJson());
    return res;
  }

  updateDeviceToken(String data) async {
    var res = await put('/user/token$data', handler: false);
    return res;
  }
}
