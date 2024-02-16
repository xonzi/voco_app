import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voco_app/product/strings/auth_strings.dart';
import 'package:voco_app/product/utility/project_colors.dart';
import 'package:voco_app/product/utility/project_paddings.dart';
import 'package:voco_app/product/utility/project_spacers.dart';
import 'package:voco_app/view/login/model/login_view_model.dart';

import '../../product/components/login/login_form_field.dart';
import '../../product/enums/text_editing_type.dart';
part '../../product/components/login/auth_buttons.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends LoginViewModel {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png"),
                    ProjectSpacers.customSpacer,
                    loginForm(context),
                  ],
                ),
              ),
            ),
    ));
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: ProjectPaddings.horizontal20,
        child: Column(
          children: [
            LoginFormField(
              editingController: emailController,
              icon: const Icon(CupertinoIcons.mail),
              hintText: loginStrings.emailHint,
              textEditingType: TextEditingType.email,
            ),
            ProjectSpacers.spacer16,
            LoginFormField(
              editingController: passwordController,
              icon: const Icon(
                CupertinoIcons.lock,
              ),
              hintText: loginStrings.passwordHint,
              textEditingType: TextEditingType.password,
            ),
            ProjectSpacers.spacer16,
            loginButton(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customMaterialButton(onPressed: () {}, text: loginStrings.forgotPasswordText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox loginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          bool isValid = formKey.currentState!.validate();
          if (isValid) {
            // API isteği başlamadan önce isLoading durumunu true yap
            setState(() {
              isLoading = true;
            });

            try {
              // API isteğini gönder
              await fetchUserLogin(emailController.text, passwordController.text);

              // API isteği tamamlandığında isLoading durumunu false yap
              setState(() {
                isLoading = false;
              });
            } catch (error) {
              // Hata durumunda isLoading durumunu false yap
              setState(() {
                isLoading = false;
              });
              // Hata durumunu yönet
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ProjectColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: ProjectPaddings.radiusCircular,
          ),
          fixedSize: const Size(0, 50),
        ),
        child: Text(
          loginStrings.login,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
