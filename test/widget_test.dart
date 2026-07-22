import 'package:flutter_test/flutter_test.dart';
import 'package:secucheck/my_app.dart';

// basic smoke test to ensure the app widget renders without crashing
void main() {
  testWidgets('App smoke test', (final WidgetTester tester) async {
    // build the root app widget
    await tester.pumpWidget(const MyApp());
    // verify the app initializes without throwing
    expect(find.byType(MyApp), findsOneWidget);
  });
}
