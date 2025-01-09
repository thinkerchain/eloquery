part of 'eloquery_cubit.dart';

@immutable
sealed class EloqueryState<T> {}

final class EloqueryInitial<T> extends EloqueryState<T> {}

final class EloquerySuccess<T> extends EloqueryState<T> {
  final EloqueryResponse<T> data;
  EloquerySuccess(this.data);
}

final class EloqueryError<T> extends EloqueryState<T> {}

final class EloqueryFetching<T> extends EloqueryState<T> {}
