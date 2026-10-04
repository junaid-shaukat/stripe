/// Paginator model for pagination information.
class Paginator {
  /// number of items per page.
  int? perPage;

  /// URL for the next page of results.
  String? nextPageUrl;

  /// Current page number.
  int? page;

  /// Indicates if there are more pages available.
  bool hasMorePages;

  /// Constructor for NotificationsPaginator.
  Paginator({
    this.perPage,
    this.nextPageUrl,
    this.page,
    this.hasMorePages = false,
  });

  int get nextPage {
    if (page == null) return 1;
    return page! + 1;
  }

  /// Factory constructor to create NotificationsPaginator from JSON.
  factory Paginator.fromJson(Map<String, dynamic> json) {
    return Paginator(
      perPage: json['per_page'],
      nextPageUrl: json['next_page_url'],
      page: json['page'],
      hasMorePages: json['has_more_pages'],
    );
  }

  /// Converts NotificationsPaginator to JSON.
  Map<String, dynamic> toJson() {
    return {
      'per_page': perPage,
      'next_page_url': nextPageUrl,
      'page': page,
      'has_more_pages': hasMorePages,
    };
  }

  /// Creates a copy of NotificationsPaginator with updated values.
  Paginator copyWith({
    int? perPage,
    String? nextPageUrl,
    int? page,
    bool? hasMorePages,
  }) {
    return Paginator(
      perPage: perPage ?? this.perPage,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      page: page ?? this.page,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}
