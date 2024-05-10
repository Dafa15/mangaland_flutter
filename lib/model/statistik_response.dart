class StatistikMangaResponse {
  String? result;
  Statistics? statistics;

  StatistikMangaResponse({
    required this.result,
    required this.statistics,
  });
}

class MangaId {
  Statistics? statistics;
  MangaId({
    required this.statistics,
  });
}

class Statistics {
  int? follows;
  Rating rating;

  Statistics({
    required this.follows,
    required this.rating,
  });
}

class Rating {
  num? average;
  num? bayesian;

  Rating({
    required this.average,
    required this.bayesian,
  });
}
