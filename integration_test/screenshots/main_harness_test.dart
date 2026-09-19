import 'package:tief_test_harness/tief_test_harness.dart';

import '../helpers.dart';
import 'main_harness_test.th.dart';
import 'screenshot_manager_provider.dart';

@GenerateHarnessRegistry("main")
Future<void> main() async {
  final harnessRegistry = MainHarnessRegistry();

  final harnesses = await harnessRegistry.build();

  final harnessRunner = HarnessRunner(
    harnesses: harnesses,
    appBuilder: ({required child, required locale, providerScopeBuilder}) => child,
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
