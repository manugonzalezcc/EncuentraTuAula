// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // Importa PDFView para buscarlo por tipo


import 'package:encuentra_tu_aula/main.dart';

void main() {
  testWidgets('HomePage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EncuentraTuAulaApp());

    // Verify that the AppBar title is correct.
    expect(find.text('Encuentra Tu Aula'), findsOneWidget);

    // Verifica que el PDFView (o el indicador de carga) esté presente.
    // Como el PDF se carga asíncronamente, podríamos encontrar el CircularProgressIndicator inicialmente.
    // O, si el PDF se carga muy rápido en el entorno de prueba, podríamos encontrar el PDFView.
    // Para una prueba más robusta, podrías necesitar `pumpAndSettle`.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Opcionalmente, después de un pumpAndSettle si esperas que el PDF cargue:
    // await tester.pumpAndSettle();
    // expect(find.byType(PDFView), findsOneWidget);


    // Verifica que el GestureDetector para la búsqueda esté presente.
    expect(find.byType(GestureDetector), findsAtLeastNWidgets(1)); // Puede haber más GestureDetectors
    final searchBarGestureDetector = find.descendant(
      of: find.byType(Padding), // Asumiendo que el Padding envuelve tu barra de búsqueda
      matching: find.byType(GestureDetector),
    );
    expect(searchBarGestureDetector, findsOneWidget);

    // Simula un tap en la barra de búsqueda para abrir el BottomSheet.
    await tester.tap(searchBarGestureDetector);
    await tester.pumpAndSettle(); // Espera a que las animaciones terminen y el sheet aparezca.

    // Verifica que el TextField dentro del BottomSheet esté presente.
    expect(find.widgetWithText(TextField, 'Escribe aquí para buscar...'), findsOneWidget);
  });
}
