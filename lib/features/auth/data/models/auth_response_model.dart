class AuthResponseModel {
  final bool success;
  final String message;
  final String? uid;
  final String? email;
  final String? idToken; // موجود بس في /login

  AuthResponseModel({
    required this.success,
    required this.message,
    this.uid,
    this.email,
    this.idToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      uid: json['uid'],
      email: json['email'],
      idToken: json['idToken'],
    );
  }
}