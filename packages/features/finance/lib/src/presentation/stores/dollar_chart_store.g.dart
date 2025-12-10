// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dollar_chart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DollarChartStore on _DollarChartStore, Store {
  late final _$chartAtom = Atom(
    name: '_DollarChartStore.chart',
    context: context,
  );

  @override
  CurrencyChart? get chart {
    _$chartAtom.reportRead();
    return super.chart;
  }

  @override
  set chart(CurrencyChart? value) {
    _$chartAtom.reportWrite(value, super.chart, () {
      super.chart = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_DollarChartStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadChartAsyncAction = AsyncAction(
    '_DollarChartStore.loadChart',
    context: context,
  );

  @override
  Future<void> loadChart() {
    return _$loadChartAsyncAction.run(() => super.loadChart());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_DollarChartStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
chart: ${chart},
errorMessage: ${errorMessage}
    ''';
  }
}
