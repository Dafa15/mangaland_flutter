import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'CLIENT_ID')
    static const String clientId = _Env.clientId;
    @EnviedField(varName: 'CLIENT_SECRET_KEY')
    static const String clientSecretKey = _Env.clientSecretKey;
    @EnviedField(varName: 'GEMINI_API_KEY')
    static const String geminiApiKey = _Env.geminiApiKey;
}