class LoginToken{
  String token;
  LoginToken(this.token);
  LoginToken.fromJson(Map<String, dynamic> json):
      token = json["token"];

}