class EloqueryResponse<T> {
  // DATA
  T? data;

  // STALE TIME
  // ignore: prefer_final_fields
  late int lastDataGatheringEpoch;
  late int staleTimeMilis;

  bool get isStale =>
      lastDataGatheringEpoch + staleTimeMilis <
      DateTime.now().millisecondsSinceEpoch;

  // QUERY OPTION
  bool enabled;

  EloqueryResponse({
    this.staleTimeMilis = 1000 * 10,
    this.enabled = true,
  }) : lastDataGatheringEpoch = DateTime.now().millisecondsSinceEpoch;
}
