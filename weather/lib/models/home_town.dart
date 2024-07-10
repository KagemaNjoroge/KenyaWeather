class HomeTown {
  final String townName;

  HomeTown({
    required this.townName,
  });

  factory HomeTown.fromJson(Map<String, dynamic> json) {
    return HomeTown(
      townName: json['town_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'townName': townName,
    };
  }
}
