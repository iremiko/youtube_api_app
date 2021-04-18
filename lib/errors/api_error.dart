class APIError {
  int errorCode;
  String message;

  APIError(this.errorCode, this.message);

  APIError.fromJson(Map<String, dynamic> json) {
    errorCode = json['error']['code'];
    message = json['error']['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['error']['code'] = this.errorCode;
    data['error']['message'] = this.message;
    return data;
  }

  @override
  String toString() {
    return 'APIError{errorCode: $errorCode, message: $message}';
  }
}

