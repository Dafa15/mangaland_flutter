
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String accessToken;
    int expiresIn;
    int refreshExpiresIn;
    String refreshToken;
    String tokenType;
    int notBeforePolicy;
    String sessionState;
    String scope;
    String clientType;

    LoginResponse({
        required this.accessToken,
        required this.expiresIn,
        required this.refreshExpiresIn,
        required this.refreshToken,
        required this.tokenType,
        required this.notBeforePolicy,
        required this.sessionState,
        required this.scope,
        required this.clientType,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        refreshExpiresIn: json["refresh_expires_in"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
        notBeforePolicy: json["not-before-policy"],
        sessionState: json["session_state"],
        scope: json["scope"],
        clientType: json["client_type"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "expires_in": expiresIn,
        "refresh_expires_in": refreshExpiresIn,
        "refresh_token": refreshToken,
        "token_type": tokenType,
        "not-before-policy": notBeforePolicy,
        "session_state": sessionState,
        "scope": scope,
        "client_type": clientType,
    };
}
