import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care_app/ice/main_ice.dart';
import 'package:health_care_app/widgets/action_container.dart';

import '../utils/benchmark_helper.dart';
import 'utils/common_actions.dart';

void main() {
  testWidgets('ICE CRUD', (tester) async {
    await runPerf(() async {
      await tester.pumpAndSettle();

      await login(tester);

      await tester.pumpAndSettle(Duration(seconds: 2));

      final actions = find.byType(ActionContainer);
      if (actions.evaluate().isNotEmpty) {
        bool found = false;
        for (var i = 0; i < actions.evaluate().length; i++) {
          final actionWidget = actions.at(i);
          final actionWidgetText = find.descendant(
            of: actionWidget,
            matching: find.byType(Text),
          );

          if (actionWidgetText.evaluate().isNotEmpty) {
            final textWidgets = actionWidgetText.evaluate();
            for (var textElement in textWidgets) {
              final Text text = textElement.widget as Text;
              final String textData = text.data ?? '';

              if (textData.toLowerCase().contains('emergency') ||
                  textData.toLowerCase().contains('ice') ||
                  textData.toLowerCase().contains('case')) {
                await tester.tap(actionWidget);
                found = true;
                break;
              }
            }
          }

          if (found) break;
        }

        if (!found) {
          final iceWidget = find.byType(MainIce);
          if (iceWidget.evaluate().isNotEmpty) {
            found = true;
          } else if (actions.evaluate().isNotEmpty) {
            await tester.tap(actions.first);
          }
        }
      }
      await tester.pumpAndSettle();

      await addIceInfo(tester);
      await editIceInfo(tester);
      await deleteIceInfo(tester);
    }, name: 'integ_ice_crud');
  });
}
