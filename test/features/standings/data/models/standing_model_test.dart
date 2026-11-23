import 'package:flutter_test/flutter_test.dart';
import 'package:liga_app/features/standings/data/models/standing_model.dart';

void main() {
  group('StandingModel.fromJson', () {
    // Crea un JSON de prueba. Se le puede pasar otro "team" para cada caso.
    Map<String, dynamic> buildJson({Map<String, dynamic>? team}) => {
      'position': 1,
      'team':
          team ??
          {
            'id': 81,
            'name': 'FC Barcelona',
            'shortName': 'Barça',
            'crest': 'https://crests.football-data.org/81.png',
          },
      'playedGames': 13,
      'won': 12,
      'draw': 0,
      'lost': 1,
      'points': 36,
      'goalDifference': 25,
    };

    test('convierte un JSON completo correctamente', () {
      final model = StandingModel.fromJson(buildJson());

      expect(model.teamName, 'FC Barcelona');
      expect(model.shortName, 'Barça');
      expect(model.points, 36);
    });

    // 🛡️ Test de regresión: la app fallaba cuando la API no enviaba shortName ni crest
    test('usa el nombre completo cuando falta shortName', () {
      final model = StandingModel.fromJson(
        buildJson(team: {'id': 81, 'name': 'FC Barcelona'}),
      );

      expect(model.shortName, 'FC Barcelona');
      expect(model.crestUrl, '');
    });
  });
}
