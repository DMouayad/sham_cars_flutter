class MedicalProcedure {
  final String name;
  final List<String> preformedByPhysicianIds;

  const MedicalProcedure({
    required this.name,
    this.preformedByPhysicianIds = const [],
  });
}
