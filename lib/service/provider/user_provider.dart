import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voco_app/model/user_model.dart';
import 'package:voco_app/service/users_services.dart';

final usersProvider = FutureProvider<List<User>>((ref) async {
  final userService = UserService();
  final users = await userService.getUsers();
  return users;
});
