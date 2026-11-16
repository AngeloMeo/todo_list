import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_list/main.dart';

Future<void> _createTodo(
  WidgetTester tester, {
  required String title,
  bool important = false,
}) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), title);
  await tester.pump();

  if (important) {
    await tester.tap(find.byType(SwitchListTile));
    await tester.pump();
  }

  await tester.tap(find.text('Salva attività'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    '1. Stato iniziale vuoto con conteggio 0/0 e indicazione per aggiungere attività',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      expect(find.text('Le mie attività'), findsOneWidget);
      expect(find.text('Completate: 0 / 0'), findsOneWidget);
      expect(find.text('Nessuna attività in programma'), findsOneWidget);
      expect(
        find.text(
          'Premi il pulsante "+" ("Aggiungi attività") in basso per creare la tua prima attività.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Aggiungi attività'), findsOneWidget);
    },
  );

  testWidgets(
    '2. Creazione attività valida (con trim e importanza), aggiornamento lista/conteggio e SnackBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Nuova attività'), findsOneWidget);
      expect(find.text('No — priorità normale'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '  Studiare Flutter  ');
      await tester.pump();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pump();
      expect(find.text('Sì — verrà evidenziata nell’elenco'), findsOneWidget);

      await tester.tap(find.text('Salva attività'));
      await tester.pumpAndSettle();

      expect(find.text('Le mie attività'), findsOneWidget);
      expect(find.text('Studiare Flutter'), findsOneWidget);
      expect(find.text('Da fare'), findsOneWidget);
      expect(find.text('Importante'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(find.text('Completate: 0 / 1'), findsOneWidget);
      expect(find.text('Attività aggiunta'), findsOneWidget);

      await _createTodo(tester, title: 'Fare la spesa', important: false);

      expect(find.text('Fare la spesa'), findsOneWidget);
      expect(find.text('Completate: 0 / 2'), findsOneWidget);
      expect(find.text('Importante'), findsOneWidget);
    },
  );

  testWidgets(
    '3. Validazione titolo mancante mostra errore e lo rimuove appena l’utente digita',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();

      await tester.tap(find.text('Salva attività'));
      await tester.pump();

      expect(find.text('Nuova attività'), findsOneWidget);
      expect(find.text('Inserisci un titolo per l’attività'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'C');
      await tester.pump();

      expect(find.text('Inserisci un titolo per l’attività'), findsNothing);
    },
  );

  testWidgets(
    '4. Rinuncia alla creazione chiude senza aggiungere attività né mostrare SnackBar',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Attività annullata');
      await tester.pump();

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.text('Le mie attività'), findsOneWidget);
      expect(find.text('Attività annullata'), findsNothing);
      expect(find.text('Completate: 0 / 0'), findsOneWidget);
      expect(find.text('Nessuna attività in programma'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Annulla'));
      await tester.pumpAndSettle();

      expect(find.text('Le mie attività'), findsOneWidget);
      expect(find.text('Completate: 0 / 0'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    },
  );

  testWidgets(
    '5. Cambio stato da "da fare" a "completata" e ritorno con aggiornamento conteggio',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await _createTodo(tester, title: 'Leggere capitolo 3');

      expect(find.text('Completate: 0 / 1'), findsOneWidget);
      expect(find.text('Da fare'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(find.text('Completate: 1 / 1'), findsOneWidget);
      expect(find.text('Completata'), findsOneWidget);
      expect(find.text('Tutto completato'), findsOneWidget);

      final completedTitleText = tester.widget<Text>(
        find.text('Leggere capitolo 3'),
      );
      expect(completedTitleText.style?.decoration, TextDecoration.lineThrough);

      await tester.tap(find.text('Leggere capitolo 3'));
      await tester.pumpAndSettle();

      expect(find.text('Completate: 0 / 1'), findsOneWidget);
      expect(find.text('Da fare'), findsOneWidget);

      final reopenedTitleText = tester.widget<Text>(
        find.text('Leggere capitolo 3'),
      );
      expect(reopenedTitleText.style?.decoration, TextDecoration.none);
    },
  );

  testWidgets(
    '6. Eliminazione attività con dialog di conferma e variante di rinuncia',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());

      await _createTodo(tester, title: 'Comprare il latte');
      expect(find.text('Completate: 0 / 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Elimina attività'), findsOneWidget);
      expect(
        find.text('Vuoi eliminare l’attività "Comprare il latte"?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Annulla'));
      await tester.pumpAndSettle();

      expect(find.text('Comprare il latte'), findsOneWidget);
      expect(find.text('Completate: 0 / 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('Comprare il latte'), findsOneWidget);
      expect(find.text('Completate: 0 / 1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Elimina'));
      await tester.pumpAndSettle();

      expect(find.text('Comprare il latte'), findsNothing);
      expect(find.text('Completate: 0 / 0'), findsOneWidget);
      expect(find.text('Nessuna attività in programma'), findsOneWidget);
    },
  );
}
