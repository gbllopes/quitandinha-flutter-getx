import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quitanda_virtual/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda_virtual/src/services/validators.dart';

import '../../../config/custom_colors.dart';
import '../../common_widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

  final phoneFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {'#': RegExp(r'[0-9]')});

  final _globalKey = GlobalKey<FormState>();

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 32),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              label: 'Email',
                              icon: Icons.email,
                              onSaved: (value) {
                                authController.user.email = value;
                              },
                              validator: emailValidator,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            CustomTextField(
                                label: 'Senha',
                                icon: Icons.lock,
                                validator: passwordValidator,
                                onSaved: (value) {
                                  authController.user.password = value;
                                },
                                isPassword: true),
                            CustomTextField(
                              label: 'Nome',
                              icon: Icons.person,
                              validator: nameValidator,
                              onSaved: (value) {
                                authController.user.name = value;
                              },
                            ),
                            CustomTextField(
                              label: 'Celular',
                              icon: Icons.phone,
                              validator: phoneValidator,
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                authController.user.phone = value;
                              },
                              inputFormatters: [phoneFormatter],
                            ),
                            CustomTextField(
                              label: 'CPF',
                              keyboardType: TextInputType.number,
                              validator: cpfValidator,
                              onSaved: (value) {
                                authController.user.cpf = value;
                              },
                              icon: Icons.file_copy,
                              inputFormatters: [cpfFormatter],
                            ),
                            SizedBox(
                                height: 50,
                                child: Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18))),
                                    onPressed: !authController
                                            .isCategoryLoading.value
                                        ? () {
                                            if (_globalKey.currentState!
                                                .validate()) {
                                              _globalKey.currentState!.save();
                                              authController.signUp();
                                            }
                                            FocusScope.of(context).unfocus();
                                          }
                                        : null,
                                    child:
                                        !authController.isCategoryLoading.value
                                            ? const Text(
                                                'Cadastrar usuário',
                                                style: TextStyle(fontSize: 18),
                                              )
                                            : const CircularProgressIndicator(),
                                  ),
                                ))
                          ],
                        ),
                      ))
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
