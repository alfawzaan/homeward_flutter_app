class LoginTokenResponse {
  String token;
  String error;

  LoginTokenResponse(this.token, this.error);

  LoginTokenResponse.fromJson(Map<String, dynamic> json)
      : token = json["token"];

  LoginTokenResponse.withError(String errorValue)
      : token = "",
        error = errorValue;
}
