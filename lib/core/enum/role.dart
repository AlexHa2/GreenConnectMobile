enum Role {
  individualCollector,
  businessCollector,
  household;

  String toJson() => name;

  String get label {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  static Role fromJson(String json) => values.firstWhere(
    (e) => e.name.toLowerCase() == json.toLowerCase(),
    orElse: () => Role.individualCollector,
  );

  static Role parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'individualcollector':
        return Role.individualCollector;
      case 'businesscollector':
        return Role.businessCollector;
      default:
        return Role.household;
    }
  }

  static bool hasRole(List<String>? roles, Role role) {
    if (roles == null || roles.isEmpty) return false;

    final lowerRoles = roles
        .where((e) => e.isNotEmpty)
        .map((e) => e.trim().toLowerCase())
        .toList();

    return lowerRoles.contains(role.toJson().toLowerCase());
  }
}
