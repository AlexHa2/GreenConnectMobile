/// Add query parameters into a base path safely
String withQuery(String base, Map<String, dynamic>? params) {
  if (params == null || params.isEmpty) return base;

  final query = params.entries
      .where((e) => e.value != null)
      .map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent("${e.value}")}')
      .join('&');

  return '$base?$query';
}
