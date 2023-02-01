enum ResultType { user, bot }

class GradeResult {
  GradeResult({
    required this.text,
    required this.chatMessageType,
  });

  final String text;
  final ResultType chatMessageType;
}
