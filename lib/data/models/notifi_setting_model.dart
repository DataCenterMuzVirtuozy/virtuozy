


 class NotifiSettingModel{

   final String name;
   final int config;

   const NotifiSettingModel({
    required this.name,
    required this.config,
  });

   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'config': config,
    };
  }

  factory NotifiSettingModel.fromMap(Map<String, dynamic> map) {
    return NotifiSettingModel(
      name: map['name'] as String,
      config: map['config'] as int,
    );
  }
}