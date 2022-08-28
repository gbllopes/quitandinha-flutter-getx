import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvKeys {
  static String get aplicationId => _get('APLICATION_ID');
  static String get aplicationRestApiKey => _get('APLICATION_REST_API_KEY');

  static String _get(String variableName) => dotenv.get(variableName);
}
