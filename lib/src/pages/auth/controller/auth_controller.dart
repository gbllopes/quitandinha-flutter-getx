import 'package:get/get.dart';
import 'package:quitanda_virtual/src/models/user_model.dart';
import 'package:quitanda_virtual/src/pages/auth/repository/auth_repository.dart';
import 'package:quitanda_virtual/src/pages/auth/result/auth_result.dart';
import 'package:quitanda_virtual/src/services/utils_services.dart';

import '../../../constants/storage_keys.dart';
import '../../../pages_routes/app_pages.dart';

class AuthController extends GetxController {
  RxBool isCategoryLoading = false.obs;
  final utilsServices = UtilsServices();
  final authRepository = AuthRepository();

  UserModel user = UserModel();

  void saveTokenAndProceedToBase() {
    utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);

    Get.offAllNamed(PagesRoutes.baseRoute);
  }

  Future<void> signUp() async {
    isCategoryLoading.value = true;
    AuthResult result = await authRepository.signUp(user);
    isCategoryLoading.value = false;
    result.when(success: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> validateToken() async {
    //Recuperar token salvo localmente.
    String? token = await utilsServices.getLocalData(key: StorageKeys.token);
    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }
    AuthResult result = await authRepository.validateToken(token);

    result.when(success: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (message) {
      signOut();
    });
  }

  Future<void> signOut() async {
    //Zerar o user
    user = UserModel();

    //Remover o token localmente
    await utilsServices.removeLocalData(key: StorageKeys.token);

    //Ir para a tela de login
    Get.offAllNamed(PagesRoutes.signInRoute);
  }

  Future<void> signIn({required String email, required String password}) async {
    isCategoryLoading.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isCategoryLoading.value = false;

    result.when(success: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (message) {
      utilsServices.showToast(
        message: message,
        isError: true,
      );
    });
  }
}
