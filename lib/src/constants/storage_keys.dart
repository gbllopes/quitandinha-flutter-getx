import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class StorageKeys {
  static const String token = 'token';

  static String get aplicationId => _get('APLICATION_ID');
  static String get aplicationRestApiKey => _get('APLICATION_REST_API_KEY');

  static String _get(String variableName) => dotenv.get(variableName);
}
