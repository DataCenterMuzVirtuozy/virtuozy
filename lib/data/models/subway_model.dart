

  class SubwayModel{


    final String name;

    const SubwayModel({
    required this.name,
  });



  factory SubwayModel.fromMap(Map<String, dynamic> map) {
    return SubwayModel(
      name: map['value'] as String,
    );
  }
}