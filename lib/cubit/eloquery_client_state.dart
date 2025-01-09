part of 'eloquery_client_cubit.dart';

@immutable
sealed class EloqueryClientState {}

final class EloqueryClientInitial extends EloqueryClientState {}

final class EloqueryClientReady extends EloqueryClientState {
  final List<({List<String> queryKey, EloqueryResponse eloqueryResponse})> data;
  EloqueryClientReady(this.data);
}
