class FavoriteTeam {
  const FavoriteTeam({
    required this.teamId,
    required this.name,
    required this.crestUrl,
  });

  final int teamId;
  final String name;
  final String crestUrl;

  /// De una fila de SQLite → objeto Dart
  factory FavoriteTeam.fromMap(Map<String, Object?> map) => FavoriteTeam(
    teamId: map['team_id']! as int,
    name: map['name']! as String,
    crestUrl: map['crest_url']! as String,
  );

  /// De objeto Dart → fila de SQLite
  Map<String, Object?> toMap() => {
    'team_id': teamId,
    'name': name,
    'crest_url': crestUrl,
  };
}
