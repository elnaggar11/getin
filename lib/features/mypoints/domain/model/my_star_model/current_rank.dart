class Rank {
  int? id;
  String? name;
  String? image;
  String? title;
  String? minStars;
  String? maxStars;
  String? pointsIncrement;
  String? starsIncrement;
  String? description;
  String? badgeColor;

  Rank({
    this.id,
    this.name,
    this.image,
    this.title,
    this.minStars,
    this.maxStars,
    this.pointsIncrement,
    this.starsIncrement,
    this.description,
    this.badgeColor,
  });

  factory Rank.fromJson(Map<String, dynamic> json) => Rank(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
        title: json['title'] as String?,
        minStars: json['min_stars'].toString() as String?,
        maxStars: json['max_stars'].toString() as String?,
        pointsIncrement: json['points_increment'].toString() as String?,
        starsIncrement: json['stars_increment'].toString() as String?,
        description: json['description'] as String?,
        badgeColor: json['badge_color'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'min_stars': minStars,
        'max_stars': maxStars,
        'points_increment': pointsIncrement,
        'stars_increment': starsIncrement,
        'description': description,
        'badge_color': badgeColor,
      };
}
