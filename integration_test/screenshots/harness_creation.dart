import 'package:tief_test_harness/tief_test_harness.dart';
import 'package:finamp/main.dart' as app;

import 'screenshot_manager_provider.dart';

ScenarioHarness createHarness({ScenarioCallback? beforeEach}) {
  return ScenarioHarness(
    appContent: app.Finamp(),
    beforeEach: beforeEach,
    afterEach: (tester, binding, ref, harnessName, scenarioName) async =>
        await ref.read(screenshotManagerStateProvider)?.pumpAndScreenshot(scenarioName, tester, binding),
    afterAll: (binding, ref, harnessName) async {
      await ref.read(screenshotManagerStateProvider)?.uploadScreenshots(harnessName);
      ref.read(screenshotManagerStateProvider)?.clear();
    },
  );
}
