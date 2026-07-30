import 'package:flutter_test/flutter_test.dart';
import 'package:droneatlas/app.dart';

void main() {
  testWidgets('DroneAtlas démarre et affiche l’accueil', (tester) async {
    await tester.pumpWidget(const DroneAtlasApp());
    expect(find.text('DRONEATLAS'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Commencer le parcours'), findsOneWidget);
  });
}
