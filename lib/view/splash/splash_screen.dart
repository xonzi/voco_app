import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voco_app/core/auth_manager.dart';
import 'package:voco_app/model/user_model.dart';
import 'package:voco_app/product/utility/project_colors.dart';
import 'package:voco_app/product/utility/project_spacers.dart';
import 'package:voco_app/view/home/home_view.dart';
import 'package:voco_app/view/login/login_view.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    controlToLogin();
  }

  Future<void> controlToLogin() async {
    await ref.read(AuthProvider).fetchUserLogin();
    if (ref.read(AuthProvider).isLogin) {
      await Future.delayed(const Duration(seconds: 1));
      ref.read(AuthProvider).model = User(id: 1, email: "", firstName: "", lastName: "", avatarUrl: "");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      appBar: AppBar(
        backgroundColor: ProjectColors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset("assets/logo.png"),
            ),
          ),
          const Expanded(
            flex: 1,
            child: ProjectSpacers.spacer20,
          ),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "Hoş Geldiniz!",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                  ),
                ),
              )),
          const Expanded(
              flex: 4,
              child: Center(
                child: CircularProgressIndicator(
                  color: ProjectColors.lightGrey,
                ),
              ))
        ],
      ),
    );
  }
}
