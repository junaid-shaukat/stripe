import '/core/app_export.dart';

enum PropState { initial, loading, refreshing, success, error }

enum ErrorType { none, network }

/// A snapshot of the current state and data, passed to UI builders.

class Props<T> extends GetxController {
  final Rx<T?> data;
  final Rx<ErrorType> type;
  final Rx<String?> error;
  final Rx<PropState> state;
  final Rx<Paginator> paginator;
  final RxMap<String, dynamic> extra;

  Props({
    PropState initialState = PropState.initial,
    ErrorType initialType = ErrorType.none,
    T? initialData,
    String? initialError,
    Paginator? initialPaginator,
    Map<String, dynamic> initialExtra = const {},
  }) : state = Rx<PropState>(initialState),
       type = Rx<ErrorType>(initialType),
       data = Rx<T?>(initialData),
       error = Rx<String?>(initialError),
       paginator = Rx<Paginator>(initialPaginator ?? Paginator()),
       extra = RxMap<String, dynamic>(initialExtra);

  // --- Getters ---
  bool get isInitial => state.value == PropState.initial;
  bool get isLoading => state.value == PropState.loading;
  bool get isRefreshing => state.value == PropState.refreshing;
  bool get isSuccess => state.value == PropState.success;
  bool get isError => state.value == PropState.error;

  // --- State Updates ---

  void _updateState({
    T? data,
    String? message,
    bool hasMore = false,
    bool indicator = false,
    Paginator? paginator,
    required PropState state,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) {
    // Handle Progress Dialog
    if (indicator) {
      ProgressDialog.onStart();
    } else {
      ProgressDialog.onStop();
    }

    // Handle List Appending for Pagination
    if (hasMore && data is List && this.data.value is List) {
      try {
        final currentList = List.from(this.data.value as List);
        currentList.addAll(data as List);
        this.data.value = currentList as T? ?? this.data.value;
      } catch (e) {
        // Fallback: just assign new data if casting fails
        this.data.value = data;
      }
    } else {
      // Keep old data if data is null (useful for background refreshing)
      this.data.value = data ?? this.data.value;
    }

    this.state.value = state;
    this.type.value = type;
    error.value = message;
    if (paginator != null) this.paginator.value = paginator;
    if (extra != null) this.extra.assignAll(extra);
  }

  // --- Transition Methods ---

  void setInitial({
    T? data,
    String? message,
    bool hasMore = false,
    Paginator? paginator,
    bool indicator = false,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) => _updateState(
    data: data,
    type: type,
    extra: extra,
    hasMore: hasMore,
    message: message,
    indicator: indicator,
    paginator: paginator,
    state: PropState.initial,
  );

  void setLoading({
    T? data,
    String? message,
    bool hasMore = false,
    Paginator? paginator,
    bool indicator = false,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) => _updateState(
    data: data,
    type: type,
    extra: extra,
    hasMore: hasMore,
    message: message,
    indicator: indicator,
    paginator: paginator,
    state: PropState.loading,
  );

  void setRefreshing({
    T? data,
    String? message,
    bool hasMore = false,
    Paginator? paginator,
    bool indicator = false,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) => _updateState(
    data: data,
    type: type,
    extra: extra,
    hasMore: hasMore,
    message: message,
    indicator: indicator,
    paginator: paginator,
    state: PropState.refreshing,
  );

  void setSuccess({
    T? data,
    String? message,
    Paginator? paginator,
    bool hasMore = false,
    bool indicator = false,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) {
    _updateState(
      data: data,
      type: type,
      extra: extra,
      hasMore: hasMore,
      message: message,
      indicator: indicator,
      paginator: paginator,
      state: PropState.success,
    );
  }

  void setError({
    T? data,
    String? message,
    Paginator? paginator,
    bool hasMore = false,
    bool indicator = false,
    Map<String, dynamic>? extra,
    ErrorType type = ErrorType.none,
  }) {
    _updateState(
      data: data,
      type: type,
      extra: extra,
      hasMore: hasMore,
      message: message,
      indicator: indicator,
      paginator: paginator,
      state: PropState.error,
    );
    console.log(message, name: 'State Error');
  }

  void clear() {
    state.value = PropState.initial;
    data.value = null;
    error.value = null;
    extra.clear();
  }
}
