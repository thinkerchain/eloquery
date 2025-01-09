import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/data/eloquery_data.dart';

part 'eloquery_state.dart';

class EloqueryOption<T> {
  EloqueryOption({required this.builder, required this.queryKey});

  List<String> queryKey;
  Widget Function(BuildContext, EloqueryState<T>, Function refetch) builder;
}

class QueryCubitImpl<T> extends Cubit<EloqueryState<T>> {
  // QUERY
  List<String> queryKey;
  FutureOr<T> Function() queryFn;

  late EloqueryData eloqueryData;

  // BUILDER
  Widget Function(BuildContext, EloqueryState<T>, Function refetch) builder;

  QueryCubitImpl({
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    EloqueryData? eloqueryData,
  }) : super(EloqueryInitial()) {
    this.eloqueryData = eloqueryData ?? EloqueryData();
  }

  void runQueryFun() async {
    try {
      emit(EloqueryFetching());
      if (eloqueryData.data) {
        emit(EloquerySuccess(eloqueryData.data));
        return;
      }
      final result = await queryFn();
      eloqueryData.data = result;
      eloqueryData.lastDataGatheringEpoch =
          DateTime.now().millisecondsSinceEpoch;
      emit(EloquerySuccess<T>(result));
    } catch (e) {
      emit(EloqueryError());
    }
  }

  bool checkDataStale() {
    final epoch = DateTime.now().millisecondsSinceEpoch;
    final isStale =
        eloqueryData.lastDataGatheringEpoch + eloqueryData.staleTimeMilis <
            epoch;
    return isStale;
  }
}
