import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_virtual/src/config/custom_colors.dart';
import 'package:quitanda_virtual/src/pages/common_widgets/app_name_widget.dart';
import 'package:quitanda_virtual/src/pages_routes/app_pages.dart';

import '../../../services/validators.dart';
import '../../common_widgets/custom_text_field.dart';
import '../controller/auth_controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final emailController =
      TextEditingController(text: 'gblsilvalopes@gmail.com');
  final passwordController = TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppNameWidget(
                    greenTitleColor: Colors.white,
                    textSize: 40,
                  ),
                  SizedBox(
                    height: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 25),
                      child: AnimatedTextKit(
                        pause: Duration.zero,
                        repeatForever: true,
                        animatedTexts: [
                          FadeAnimatedText('Frutas'),
                          FadeAnimatedText('Verduras'),
                          FadeAnimatedText('Legumes'),
                          FadeAnimatedText('Carnes'),
                          FadeAnimatedText('Cereais'),
                          FadeAnimatedText('Laticíneos'),
                        ],
                      ),
                    ),
                  )
                ],
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Email
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        icon: Icons.email,
                        validator: emailValidator,
                      ),
                      //Senha
                      CustomTextField(
                        controller: passwordController,
                        label: 'Senha',
                        icon: Icons.lock,
                        isPassword: true,
                        validator: passwordValidator,
                      ),
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (authController) {
                            return ElevatedButton(
                              onPressed: !authController.isLoading.value
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        authController.signIn(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    }
                                  : null,
                              child: authController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(fontSize: 18),
                                    ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                  color: CustomColors.customConstrastColor),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.toNamed(PagesRoutes.signUpRoute);
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(width: 2, color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
