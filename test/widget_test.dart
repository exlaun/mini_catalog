// Basic smoke test: the app builds and shows the home screen chrome.

import 'package:flutter_test/flutter_test.dart';

import 'package:mini_catalog/main.dart';

void main() {
  testWidgets('Home screen renders the app title', (tester) async {
    await tester.pumpWidget(const MiniCatalogApp());

    expect(find.text('Kicks.'), findsOneWidget);
  });
}
