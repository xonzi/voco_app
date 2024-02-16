import 'package:dio/dio.dart';
import 'package:voco_app/model/user_model.dart';

class UserService {
  final Dio _dio = Dio();

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('https://reqres.in/api/users');
      final List<User> users = (response.data['data'] as List).map((userJson) => User.fromJson(userJson)).toList();
      return users;
    } catch (error) {
      print('Error fetching users: $error');
      rethrow;
    }
  }
}
