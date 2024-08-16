import 'package:wx_exchange_flutter/models/account_transfer.dart';
import 'package:wx_exchange_flutter/models/exchange.dart';
import 'package:wx_exchange_flutter/models/history_model.dart';
import 'package:wx_exchange_flutter/models/result.dart';
import 'package:wx_exchange_flutter/utils/http_request.dart';

class ExchangeApi extends HttpRequest {
  tradeConvertor(Exchange data) async {
    var res =
        await post('/trade/converter', data: data.toJson(), handler: false);
    return Exchange.fromJson(res as Map<String, dynamic>);
  }

  onTrade(Exchange data) async {
    var res = await post('/trade', data: data.toJson(), handler: true);
    return AccountTransfer.fromJson(res as Map<String, dynamic>);
  }

  getHistory(ResultArguments resultArguments) async {
    var res = await get('/trade', data: resultArguments.toJson());
    return Result.fromJson(res, TradeHistory.fromJson);
  }

  getPay(String id) async {
    var res = await get('/trade/pay/$id');
    return AccountTransfer.fromJson(res);
  }
}
