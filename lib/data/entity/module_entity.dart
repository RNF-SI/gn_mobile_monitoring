class ModuleEntity {
  final int idModule;
  final String moduleCode;
  final String moduleName;
  final String? moduleDesc;
  final String? modulePath;
  final String? modulePicto;
  final bool downloaded; // New property
  final Map<String, dynamic>? cruved;

  ModuleEntity({
    required this.idModule,
    required this.moduleCode,
    required this.moduleName,
    this.moduleDesc,
    this.modulePath,
    this.modulePicto,
    required this.downloaded, // New property
    this.cruved,
  });

  factory ModuleEntity.fromJson(Map<String, dynamic> json) {
    return ModuleEntity(
      idModule: json['id_module'] as int,
      moduleCode: json['module_code'] as String,
      moduleName: json['module_label'] as String,
      moduleDesc: json['module_desc'] as String?,
      modulePath: json['module_path'] as String?,
      modulePicto: json['module_picto'] as String?,
      downloaded: json['downloaded'] as bool? ?? false, // Default to false
      cruved: json['cruved'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_module': idModule,
      'module_code': moduleCode,
      'module_label': moduleName,
      'module_desc': moduleDesc,
      'module_path': modulePath,
      'module_picto': modulePicto,
      'downloaded': downloaded, // New property
      'cruved': cruved,
    };
  }
}
