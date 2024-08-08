part '../parts/result.dart';

class Filter {
  String? merchant;
  String? search;
  String? query;
  String? account;
  bool? isReceived;
  String? type;
  String? orderConfirmTerm;
  bool? isParent;
  String? startDate;
  String? endDate;
  String? accumlationId;
  String? tradeStatus;

  Filter({
    this.isParent,
    this.search,
    this.merchant,
    this.type,
    this.query,
    this.isReceived,
    this.orderConfirmTerm,
    this.account,
    this.startDate,
    this.endDate,
    this.accumlationId,
    this.tradeStatus,
  });
}

class Offset {
  int? page;
  int? limit;

  Offset({this.page, this.limit});
}

class ResultArguments {
  Filter? filter = Filter();
  Offset? offset = Offset(page: 1, limit: 10);

  ResultArguments({this.filter, this.offset});

  Map<String, dynamic> toJson() => _$ResultArgumentToJson(this);
}

class Result {
  List<dynamic>? rows = [];
  int? count = 0;
  int? notSeen = 0;

  Result({this.rows, this.count, this.notSeen});

  factory Result.fromJson(dynamic json, Function fromJson) =>
      _$ResultFromJson(json, fromJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
