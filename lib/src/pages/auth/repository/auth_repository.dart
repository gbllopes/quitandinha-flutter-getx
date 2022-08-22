import 'package:quitanda_virtual/src/constants/endpoints.dart';
import 'package:quitanda_virtual/src/models/user_model.dart';
import 'package:quitanda_virtual/src/pages/auth/repository/auth_errors.dart'
    as authErros;
import 'package:quitanda_virtual/src/services/http_manager.dart';

import '../result/auth_result.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromMap(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErros.authErrosString(result['error']));
    }
  }

  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
      url: EndPoints.changePassword,
      method: HttpMethods.post,
      body: {
        "email": email,
      },
    );
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.validateToken,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
    );
    return handleUserOrError(result);
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.signin,
      method: HttpMethods.post,
      body: {
        "email": email,
        "password": password,
      },
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.signup,
      method: HttpMethods.post,
      body: user.toMap(),
    );

    return handleUserOrError(result);
  }
}
