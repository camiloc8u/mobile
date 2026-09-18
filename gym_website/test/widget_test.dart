import 'package:flutter_test/flutter_test.dart';
import 'package:gym_website/main.dart';

void main() {
  testWidgets('Carga inicial de la app', (WidgetTester tester) async {
    await tester.pumpWidget(const GymZoneApp());
  });
}