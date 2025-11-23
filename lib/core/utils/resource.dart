
sealed class Resource<T> {
  const Resource();
}

class Loading<T> extends Resource<T> {
  const Loading();
}

class Success<T> extends Resource<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Resource<T> {
  final String message;
  final int? code;
  final String? status;

  const Error({
    required this.message,
    this.code,
    this.status,
  });
}