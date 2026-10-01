class ResponseData<T> {
  final bool isSuccess;
  final int statusCode;
  final String errorMessage;
  final T? responseData;

  const ResponseData({
    required this.isSuccess,
    required this.statusCode,
    this.errorMessage = '',
    this.responseData,
  });

  /// Factory for successful responses
  factory ResponseData.success({
    required T data,
    int statusCode = 200,
    String message = '',
  }) {
    return ResponseData(
      isSuccess: true,
      statusCode: statusCode,
      errorMessage: message,
      responseData: data,
    );
  }

  /// Factory for error responses
  factory ResponseData.error({
    required String message,
    int statusCode = 400,
    T? data,
  }) {
    return ResponseData(
      isSuccess: false,
      statusCode: statusCode,
      errorMessage: message,
      responseData: data,
    );
  }

  /// Convenience getters
  bool get hasError => !isSuccess;
  bool get hasData => responseData != null;

  ResponseData<R> map<R>(R Function(T? data) transform) {
    return ResponseData<R>(
      isSuccess: isSuccess,
      statusCode: statusCode,
      errorMessage: errorMessage,
      responseData: isSuccess ? transform(responseData) : null,
    );
  }

  @override
  String toString() {
    return 'ResponseData(isSuccess: $isSuccess, statusCode: $statusCode, '
        'errorMessage: "$errorMessage", data: $responseData)';
  }
}
