import 'package:finamp/components/PlayerScreen/player_split_screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:tief_test_harness/tief_test_harness.dart';

import '../helpers.dart';
import 'main_harness_test.th.dart';
import 'screenshot_manager_provider.dart';

@GenerateHarnessRegistry("phone")
Future<void> main() async {
  final harnessRegistry = PhoneHarnessRegistry();

  final harnesses = await harnessRegistry.build();

  final harnessRunner = HarnessRunner(
    harnesses: harnesses,
    appBuilder: ({required child, required locale, providerScopeBuilder}) => MaterialApp(
      home: child,
      builder: (BuildContext context, Widget? widget) {
        return buildPlayerSplitScreenScaffold(context, widget);
      },
    ),
  );

  await harnessRunner.run(
    setUp: (binding, ref) async {
      final (mainCompleted, mainErrors) = await initializeApp();

      if (!mainCompleted || mainErrors.isNotEmpty) throw Exception("Main did not complete without errors.");

      ref.read(screenshotManagerStateProvider.notifier).initialize("10.0.2.2", 3824);
    },
    tearDown: (binding, ref) async {
      ref.read(screenshotManagerStateProvider)!.dispose();
    },
  );
}
