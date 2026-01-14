import 'package:flutter_test/flutter_test.dart';
import 'package:pasien_app/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Data Pasien'), findsOneWidget);
  });
}
