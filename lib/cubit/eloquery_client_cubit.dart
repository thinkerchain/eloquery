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
    if (existingData != null) {
      final currentEpoch = DateTime.now().millisecondsSinceEpoch;
      if (existingData.eloqueryData.lastDataGatheringEpoch +
              existingData.eloqueryData.staleTimeMilis <
          currentEpoch) {
        return existingData.eloqueryData;
      }
    }
    return null;
  }

  void init() {
    emit(EloqueryClientReady(_data));
  }

  void addData(({List<String> queryKey, EloqueryData eloqueryData}) data) {
    _data.removeWhere((element) => listEquals(element.queryKey, data.queryKey));
    _data.add(data);
  }
}
