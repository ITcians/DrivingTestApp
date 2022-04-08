class OptionModel {
  dynamic a, b, c, d;

  OptionModel({this.a, this.b, this.c, this.d});

  factory OptionModel.fromJson(map) =>
      OptionModel(a: map['a'], b: map['b'], c: map['c'], d: map['d']);

  Map<String, dynamic> toJson() => {'a': a, 'b': b, 'c': c, 'd': d};
}
