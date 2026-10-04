import '/core/app_export.dart';

class Api {
  Api._();

  static final Api instance = Api._();

  static Preference preference = Preference.instance;
  final connectivity = Get.find<ConnectivityController>();

  late final Dio client = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // Setting timeouts to Duration.zero disables them; use null or actual durations if needed.

          Map<String, dynamic> headers = {
            "Accept": "application/json",
            "Content-Type": "application/json",
          };

          headers['Accept-Language'] = preference.languageCode;
          headers['Accept-Currency'] = preference.currencyCode;

          if (preference.accessToken != null) {
            headers['Authorization'] = 'Bearer ${preference.accessToken}';
          }

          if (options.path.startsWith('{{baseUrl}}')) {
            options.baseUrl = Preference.baseUrl;
            options.path = options.path.replaceFirst('{{baseUrl}}', '');
          }

          headers.addAll(options.headers);
          options.headers = headers;
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    )
    ..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => console.logPrint(object),
      ),
    );

  Exception handleDioException(DioException error, dynamic model) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.cancel:
        return CustomException('request_timeout'.tr);
      case DioExceptionType.connectionError:
        return CustomException('no_internet_connection'.tr);
      case DioExceptionType.badResponse:
        String message = 'server_error'.tr;
        dynamic data;
        dynamic errors;
        int status = 500;
        bool success = false;

        final response = error.response;

        if (response != null) {
          final body = response.data;
          if (model != null) {
            try {
              final parse = model.transform(body);
              data = parse.data;
              errors = parse.errors;
              message = parse.message;
              status = parse.status;
              success = parse.success;
            } catch (_) {}
          }
        }

        return BadResponse(
          message,
          data: data,
          errors: errors,
          status: status,
          success: success,
        );
      default:
        break;
    }
    return InternalError('something_went_wrong'.tr);
  }

  dynamic responseHandler(Response response, dynamic model) {
    dynamic data = response.data;
    int statusCode = response.statusCode!;

    if (statusCode >= 200 && statusCode <= 299) {
      if (model != null) {
        return model.transform(data);
      }
      return response;
    } else {
      if (model != null) {
        throw model.transform(data);
      }
      throw CustomException('something_went_wrong'.tr);
    }
  }

  Future<dynamic> get(
    String path, {
    Object? body,
    dynamic model,
    Options? options,
    bool indicator = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? query,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      if (indicator) ProgressDialog.onStart();

      if (connectivity.isConnected.isFalse) {
        throw NetworkException('no_internet_connection'.tr);
      }

      final response = await client.get(
        path,
        data: body,
        options: options,
        queryParameters: query,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return responseHandler(response, model);
    } on DioException catch (e) {
      throw handleDioException(e, model);
    } catch (e) {
      rethrow;
    } finally {
      if (indicator) ProgressDialog.onStop();
    }
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    dynamic model,
    Options? options,
    bool indicator = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? query,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      if (indicator) ProgressDialog.onStart();

      if (connectivity.isConnected.isFalse) {
        throw NetworkException('no_internet_connection'.tr);
      }

      final response = await client.post(
        path,
        data: body,
        options: options,
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return responseHandler(response, model);
    } on DioException catch (e) {
      throw handleDioException(e, model);
    } catch (e) {
      rethrow;
    } finally {
      if (indicator) ProgressDialog.onStop();
    }
  }
}
