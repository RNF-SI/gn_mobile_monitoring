class ModuleEntity {
  final String moduleCode;
  final String moduleName;
  final Map<String, dynamic> cruved;

  ModuleEntity({
    required this.moduleCode,
    required this.moduleName,
    required this.cruved,
  });

  factory ModuleEntity.fromJson(Map<String, dynamic> json) {
    return ModuleEntity(
      moduleCode: json['module_code'] as String,
      moduleName: json['module_name'] as String,
      cruved: json['cruved'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_code': moduleCode,
      'module_name': moduleName,
      'cruved': cruved,
    };
  }
}
