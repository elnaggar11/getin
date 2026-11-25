import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/material.dart';

import '../Router/Router.dart';
import '../localization/localization_helper.dart';
import '../services/alerts.dart';
import '../../shared/widgets/myLoading.dart';
// import '../config/config.dart';
import '../utils/utils.dart';

class DioService {
  late final Dio _dio;

  DioService([String baseUrl = ""]) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (status) => status! < 300,
        followRedirects: false,
        headers: _getDefaultHeaders(),
        contentType: "application/x-www-form-urlencoded",
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        sendTimeout: const Duration(milliseconds: 30000),
      ),
    )..interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
  }

  Map<String, dynamic> _getDefaultHeaders() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "lang": LocalizationHelper.currentLocale,
      "Accept-Language": LocalizationHelper.currentLocale,
    };
  }

  void _updateHeaders({bool isFile = false, bool isJson = false}) {
    _dio.options.headers = {
      ..._getDefaultHeaders(),
      if (Utils.token.isNotEmpty) "Authorization": 'Bearer ${Utils.token}',
      if (isFile)
        "Content-Type": "multipart/form-data"
      else if (isJson)
        "Content-Type": "application/json",
    };
  }

  Future<ApiResponse> _request({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    bool isFile = false,
    bool isJson = false,
  }) async {
    try {
      if (loading) MyLoading.show();

      _updateHeaders(isFile: isFile, isJson: isJson);
      final data = isForm ? FormData.fromMap(body ?? {}) : body;

      Response response = await _dio.request(
        url,
        options: Options(method: method),
        data: data,
        queryParameters: query,
      );

      if (loading) MyLoading.dismis();
      return _checkForSuccess(response);
    } on DioException catch (e) {
      if (loading) MyLoading.dismis();
      return _handleDioException(e);
    }
  }

  Future<ApiResponse> postData({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
    bool isFile = false,
    bool isJson = false,
  }) {
    return _request(
      method: "POST",
      url: url,
      body: body,
      query: query,
      loading: loading,
      isForm: isForm,
      isFile: isFile,
      isJson: isJson,
    );
  }

  Future<ApiResponse> putData({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isForm = false,
  }) {
    return _request(
      method: "PUT",
      url: url,
      body: body,
      query: query,
      loading: loading,
      isForm: isForm,
    );
  }

  Future<ApiResponse> deleteData({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    bool loading = false,
    bool isJson = false,
  }) {
    return _request(
      method: "DELETE",
      url: url,
      body: body,
      query: query,
      loading: loading,
      isJson: isJson,
    );
  }

  Future<ApiResponse> getData({
    required String url,
    Map<String, dynamic>? query,
    bool loading = false,
  }) {
    return _request(method: "GET", url: url, query: query, loading: loading);
  }

  ApiResponse _checkForSuccess(Response response) {
    final dynamic responseData = response.data;
    if (responseData is! Map) {
      return ApiResponse(isError: true, response: response);
    }

    final bool status = responseData["status"] == true;
    if (status) {
      return ApiResponse(isError: false, response: response);
    } else {
      final dynamic message = responseData["message"];
      Alerts.snack(
        text: message is String ? message : "An unexpected server response.",
        state: SnackState.failed,
      );
      return ApiResponse(isError: true, response: response);
    }
  }

  ApiResponse _handleDioException(DioException e) {
    log("Error: ${e.message}");

    String errorMessage = "An unexpected error occurred.";
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.badResponse) {
      final dynamic responseData = e.response?.data;
      final dynamic responseMessage =
          responseData is Map ? responseData["message"] : null;

      if (e.response?.statusCode == 307) {
        final String? location = e.response?.headers.value("location");
        errorMessage = location == null
            ? "The server redirected this request (307)."
            : "The server redirected this request (307) to $location.";
        log("Request redirected (307). Location: ${location ?? 'missing'}");
      } else if (responseMessage is String && responseMessage.isNotEmpty) {
        errorMessage = responseMessage;
      } else if (responseData is String && responseData.isNotEmpty) {
        errorMessage = responseData;
      } else {
        errorMessage = "Server error (${e.response?.statusCode ?? 'unknown'}).";
      }

      if (errorMessage.contains("Unauthenticated")) {
        _handleUnauthenticated();
      }
    } else if (e.type == DioExceptionType.connectionError) {
      if (e.message?.contains('SocketException') ?? false) {
        errorMessage = "No Network. Please check your connection.";
      }
    }

    Alerts.snack(text: errorMessage, state: SnackState.failed);
    return ApiResponse(isError: true, response: e.response);
  }

  void _handleUnauthenticated() async {
    await Utils.dataManager.deleteUserData();
    Navigator.of(
      Utils.navigatorKey().currentContext!,
    ).pushNamedAndRemoveUntil(Routes.LoginSignupToggleScreen, (route) => false);
  }
}

class ApiResponse {
  final bool isError;
  final Response? response;

  ApiResponse({required this.isError, this.response});
}
