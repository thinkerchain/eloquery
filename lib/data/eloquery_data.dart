class EloqueryData<T> {
  // DATA
  T? data;

  // STALE TIME
  int lastDataGatheringEpoch = 0;
  late int staleTimeMilis;

  // QUERY OPTION
  bool enabled;

  EloqueryData({
    this.staleTimeMilis = 1000 * 60 * 5,
    this.enabled = true,
  });
}
