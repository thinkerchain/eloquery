import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkerchain_stack_eloquery/data/eloquery_response.dart';

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

  late EloqueryResponse<T> eloqueryData;

  // BUILDER
  Widget Function(BuildContext, EloqueryState<T>, Function refetch) builder;

  QueryCubitImpl({
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    EloqueryResponse<T>? eloqueryData,
  }) : super(EloqueryInitial()) {
    this.eloqueryData = eloqueryData ?? EloqueryResponse<T>();
  }

  void runQueryFun() async {
    try {
      emit(EloqueryFetching());
      if (eloqueryData.data != null && !eloqueryData.isStale) {
        emit(EloquerySuccess(eloqueryData));
        return;
      }
      final result = await queryFn();
      eloqueryData.data = result;
      eloqueryData.lastDataGatheringEpoch =
          DateTime.now().millisecondsSinceEpoch;
      emit(EloquerySuccess<T>(eloqueryData));
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
