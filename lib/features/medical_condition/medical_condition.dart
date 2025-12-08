class MedicalCondition {
  final String id;
  final String name;
  final List<String> treatedByPhysicianIds;

  const MedicalCondition({
    required this.id,
    required this.name,
    this.treatedByPhysicianIds = const [],
  });
}
