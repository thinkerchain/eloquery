import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/data/eloquery_data.dart';

part 'eloquery_client_state.dart';

class EloqueryClientCubit extends Cubit<EloqueryClientState> {
  final List<({List<String> queryKey, EloqueryData eloqueryData})> _data = [];
  EloqueryClientCubit() : super(EloqueryClientInitial());

  EloqueryData? getExistingData(List<String> queryKey) {
    final existingData = _data
        .firstWhereOrNull((element) => listEquals(element.queryKey, queryKey));
    final existingDataFresh =
        existingData?.eloqueryData.dataState == DataState.dataFresh;
    if (!existingDataFresh) {
      return null;
    }
    return existingData?.eloqueryData;
  }

  void init() {
    emit(EloqueryClientReady(_data));
  }

  void addData(({List<String> queryKey, EloqueryData eloqueryData}) data) {
    final existingData = _data.firstWhereOrNull(
        (element) => listEquals(element.queryKey, data.queryKey));

    // make old data stale
    existingData?.eloqueryData.dataState = DataState.dataStale;

    // add new fresh data
    _data.add(data);

    emit(EloqueryClientReady(_data));
  }
}
