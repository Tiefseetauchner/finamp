import 'package:flutter/material.dart';
import 'package:tief_test_harness/tief_test_harness.dart';

import 'screenshot_manager_provider.dart';

ScenarioHarness createHarness({required Widget child}) {
  return ScenarioHarness(
    appContent: child,
    afterEach: (tester, binding, ref, harnessName, scenarioName) async =>
        await ref.read(screenshotManagerStateProvider)?.pumpAndScreenshot(scenarioName, tester, binding),
    afterAll: (binding, ref, harnessName) async {
      await ref.read(screenshotManagerStateProvider)?.uploadScreenshots(harnessName);
      ref.read(screenshotManagerStateProvider)?.clear();
    },
  );
}
