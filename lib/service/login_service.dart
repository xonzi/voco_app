import 'dart:io';

import 'package:dio/dio.dart';
import 'package:voco_app/model/user_request_model.dart';
import 'package:voco_app/model/user_response_model.dart';

abstract class ILoginService {
  final String path = '/api/login';

  ILoginService(this.dio);

  Future<UserResponseModel?> fetchLogin(UserRequestModel model);
  final Dio dio;
}

class LoginService extends ILoginService {
  LoginService(Dio dio) : super(dio);

  @override
  Future<UserResponseModel?> fetchLogin(UserRequestModel model) async {
    try {
      final response =
          await dio.get(path, data: model, options: Options(headers: {'Content-Type': 'application/json'}));
      if (response.statusCode == HttpStatus.ok) {
        return UserResponseModel.fromJson(response.data);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
