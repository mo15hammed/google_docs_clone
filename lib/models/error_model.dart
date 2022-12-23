class ErrorModel<DataType> {
  final String? error;
  final DataType data;

  ErrorModel({
    this.error,
    required this.data,
  });
}
