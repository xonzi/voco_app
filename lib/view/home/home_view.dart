import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voco_app/core/auth_manager.dart';
import 'package:voco_app/core/cache_manager.dart';
import 'package:voco_app/model/user_model.dart';
import 'package:voco_app/product/utility/project_colors.dart';
import 'package:voco_app/service/network_status.dart';
import 'package:voco_app/service/provider/user_provider.dart';
import 'package:voco_app/view/login/login_view.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> with CacheManager, WidgetsBindingObserver {
  String token = '';
  ConnectivityController connectivityController = ConnectivityController();
  late List<User?> userModel;

  Future<void> getTokenCache() async {
    token = await getToken() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    connectivityController.init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox.shrink(),
            title: const Text("VocoApp Example"),
            actions: [
              IconButton(
                  onPressed: () {
                    ref.read(AuthProvider).signout();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  icon: const Icon(Icons.logout_outlined))
            ],
          ),
          body: ValueListenableBuilder(
              valueListenable: connectivityController.isConnected,
              builder: (context, value, child) {
                if (value) {
                  return Consumer(
                    builder: (context, ref, child) {
                      final usersAsyncValue = ref.watch(usersProvider);
                      return usersAsyncValue.when(
                          data: (users) {
                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Users",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          shape: const RoundedRectangleBorder(
                                              side: BorderSide(color: ProjectColors.primaryLight),
                                              borderRadius: BorderRadius.all(Radius.circular(12))),
                                          leading: CircleAvatar(
                                            child: Image.network(user.avatarUrl),
                                          ),
                                          title: Text("${user.firstName} ${user.lastName}"),
                                          subtitle: Text(user.email),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                          error: (error, stackTrace) => Text('Error: $error'),
                          loading: () => const Center(child: CircularProgressIndicator()));
                    },
                  );
                } else {
                  return AlertDialog(
                    backgroundColor: Colors.red.shade800,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    icon: const Icon(
                      Icons.dangerous,
                      size: 50,
                      color: Colors.white,
                    ),
                    title: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "İnternet Bağlantınızı Kontrol Edin!",
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text("data"))),
    );
  }
}
