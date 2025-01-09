import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/data/eloquery_response.dart';

part 'eloquery_client_state.dart';

class EloqueryClientCubit extends Cubit<EloqueryClientState> {
  final List<({List<String> queryKey, EloqueryResponse eloqueryData})> _data =
      [];
  EloqueryClientCubit() : super(EloqueryClientInitial());

  EloqueryResponse? getExistingData(List<String> queryKey) {
    final existingData = _data
        .firstWhereOrNull((element) => listEquals(element.queryKey, queryKey));
    return existingData?.eloqueryData;
  }

  void init() {
    emit(EloqueryClientReady(_data));
  }

  void addData(({List<String> queryKey, EloqueryResponse eloqueryData}) data) {
    _data.removeWhere((element) => listEquals(element.queryKey, data.queryKey));
    _data.add(data);
  }
}
