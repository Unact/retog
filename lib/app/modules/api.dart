import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fk_user_agent/fk_user_agent.dart';

import 'package:retog/app/app.dart';
import 'package:retog/app/models/user.dart';

class Api {
  static Future<void> resetPassword(String username) async {
    await _request(
      'POST',
      'v1/reset_password',
      headers: {
        'Authorization': 'Renew login=$username'
      }
    );
  }

  static Future<void> login(String username, String password) async {
    await User.currentUser.reset();
    dynamic response = await _request(
      'POST',
      'v2/authenticate',
      headers: {
        'Authorization': 'Renew login=$username,password=$password'
      }
    );

    User.currentUser.accessToken = response['access_token'];
    User.currentUser.refreshToken = response['refresh_token'];
    User.currentUser.username = username;

    await User.currentUser.save();
    await User.currentUser.loadDataFromRemote();
  }

  static Future<void> logout() async {
    await User.currentUser.reset();
  }

  static Future<void> refresh() async {
    User.currentUser.accessToken = null;
    dynamic response = await _request(
      'POST',
      'v2/refresh',
      headers: {
        'Authorization': 'Renew token=${User.currentUser.refreshToken}'
      }
    );

    User.currentUser.accessToken = response['access_token'];
    User.currentUser.refreshToken = response['refresh_token'];

    await User.currentUser.save();
    await User.currentUser.loadDataFromRemote();
  }

  static Future<dynamic> get(
    String method,
    {
      Map<String, String> headers,
      Map<String, dynamic> queryParameters,
    }
  ) async {
    return await request('GET', method, headers: headers, queryParameters: queryParameters);
  }

  static Future<dynamic> post(
    String method,
    {
      Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      dynamic data,
      File file,
      String fileKey = 'file'
    }
  ) async {
    return await request(
      'POST',
      method,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
      file: file,
      fileKey: fileKey
    );
  }

  static Future<dynamic> request(
    String method,
    String apiMethod,
    {
      Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      dynamic data,
      File file,
      String fileKey = 'file'
    }
  ) async {
    dynamic dataToSend = data;

    if (data is! Map<String, dynamic> && file != null) {
      throw 'file not empty, data must be Map<String, dynamic>';
    }

    if (file != null) {
      dataToSend = _createFileFormData(data, file, fileKey);
    }

    try {
      return await _request(method, apiMethod, headers: headers, data: dataToSend, queryParameters: queryParameters);
    } on AuthException {
      await refresh();

      if (dataToSend is FormData) {
        dataToSend = _createFileFormData(data, file, fileKey);
      }

      return await _request(method, apiMethod, headers: headers, data: dataToSend, queryParameters: queryParameters);
    }
  }

  static Dio _createDio([Map<String, String> headers = const {}]) {
    String version = App.application.config.packageInfo.version;

    if (headers == null) headers = {};

    if (User.currentUser.accessToken != null) {
      headers.addAll({
        'Authorization': 'Renew token=${User.currentUser.accessToken}'
      });
    }

    headers.addAll({
      'Accept': 'application/json',
      'Retog': '$version',
      HttpHeaders.userAgentHeader: 'Retog/$version ${FkUserAgent.userAgent}',
    });

    return Dio(BaseOptions(
      baseUrl: App.application.config.apiBaseUrl,
      connectTimeout: 100000,
      receiveTimeout: 100000,
      headers: headers,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ));
  }

  static void _onDioError(DioError e) {
    if (e.response != null) {
      final int statusCode = e.response.statusCode;
      final dynamic body = e.response.data;

      if (statusCode < 200) {
        throw ApiException('Ошибка при получении данных', statusCode);
      }

      if (statusCode >= 500) {
        throw ServerException(statusCode);
      }

      if (statusCode == 401) {
        throw AuthException(body['error']);
      }

      if (statusCode == 410) {
        throw VersionException(body['error']);
      }

      if (statusCode >= 400) {
        throw ApiException(body['error'], statusCode);
      }
    } else {
      if (e.error is SocketException) {
        throw ApiConnException();
      }

      throw e;
    }
  }

  static FormData _createFileFormData(Map<String, dynamic> data, File file, String fileKey) {
    Map<String, dynamic> dataToAdd = data;
    dataToAdd[fileKey] = MultipartFile.fromBytes(file.readAsBytesSync(), filename: file.path.split('/').last);

    return FormData.fromMap(dataToAdd);
  }

  static Future<dynamic> _request(
    String method,
    String apiMethod,
    {
      Map<String, String> headers,
      Map<String, dynamic> queryParameters,
      data
    }
  ) async {
    Dio dio = _createDio(headers);
    dio.options.method = method;

    try {
      return (await dio.request(apiMethod, data: data, queryParameters: queryParameters)).data;
    } on DioError catch(e) {
      _onDioError(e);
    }
  }
}

class ApiException implements Exception {
  String errorMsg;
  int statusCode;

  ApiException(this.errorMsg, this.statusCode);
}

class AuthException extends ApiException {
  AuthException(errorMsg) : super(errorMsg, 401);
}

class ServerException extends ApiException {
  ServerException(statusCode) : super('Нет связи с сервером', statusCode);
}

class ApiConnException extends ApiException {
  ApiConnException() : super('Нет связи', 503);
}

class VersionException extends ApiException {
  VersionException(errorMsg) : super(errorMsg, 410);
}
