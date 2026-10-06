import 'package:spendapp/core/app_logger.dart';
import 'package:spendapp/core/config.dart';
import 'package:spendapp/domain/entity/base_response/base_response.dart';
import 'package:spendapp/utils/app_constants.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class ApiManager {
  late Dio dio;

  ApiManager();

  void configureDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: getIt<AppConstants>().baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    dio.interceptors.add(CustomInterceptors());
  }

  Future<Either<ApiException, BaseResponse<T>>> requestApi<T>(
    String url, {
    required RequestMethod method,
    required T Function(dynamic object)? fromJsonT,
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Have Baerer token config header
      Map<String, dynamic> headers = {};

      final request = await dio.request(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: method.name, headers: headers),
      );
      if (request.statusCode != 200) {
        return left(
          ApiException(
            code: request.statusCode,
            message: request.statusMessage,
            data: request.data,
          ),
        );
      }
      return right(BaseResponse.fromJson(request.data, fromJsonT));
    } on DioException catch (error) {
      if (error.response != null) {
        return left(
          ApiException(
            code: error.response!.statusCode,
            message: error.response!.statusMessage,
            data: error.response?.data,
          ),
        );
      }
      return left(
        ApiException(
          code: ErrorCode.unknow.value,
          message: ErrorCode.unknow.message,
        ),
      );
    }
  }
}

enum RequestMethod { post, get, put, update, delete }

class CustomInterceptors implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = err.copyWith(
      error: CustomError(requestOptions: err.requestOptions),
    );
    handler.reject(error);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Log.d(
      '[REQUEST]: ${options.uri}, header: ${options.headers} ,body: ${options.data}, queryParameters: ${options.queryParameters}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.resolve(response);
  }
}

// Custom error enum here
class CustomError extends DioException {
  CustomError({required super.requestOptions});

  ErrorCode get errorCode {
    switch (response?.statusCode) {
      case 400:
        return ErrorCode.badRequest;
      case 404:
        return ErrorCode.notFound;
      default:
        return ErrorCode.serverNotResponse;
    }
  }
}

enum ErrorCode {
  notFound,
  badRequest,
  serverNotResponse,
  timeout,
  success,
  unknow,
  authentication,
}

extension ErrorValue on ErrorCode {
  int get value {
    switch (this) {
      case ErrorCode.badRequest:
        return 400;
      case ErrorCode.success:
        return 200;
      case ErrorCode.authentication:
        return 401;
      default:
        return 500;
    }
  }

  String get message {
    switch (this) {
      case ErrorCode.badRequest:
        return 'Bad request params';
      case ErrorCode.success:
        return 'Success';
      case ErrorCode.authentication:
        return 'Unauthentication';
      default:
        return 'System error';
    }
  }
}

class ApiException implements Exception {
  final int? code;
  final String? message;
  final dynamic data;

  ApiException({this.code, this.message, this.data});
}
