class Character {
  final String name;
  final String image;
  final String species;

  Character({
    required this.name,
    required this.image,
    required this.species,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      image: json['image'],
      species: json['species'],
    );
  }
}
