import 'package:finamp/screens/downloads_screen.dart';
import 'package:tief_test_harness/tief_test_harness.dart';

import '../screenshot_manager_provider.dart';

@RegisterHarness("phone", name: "Splash Screen")
Future<ScenarioHarness> buildEmptyHomeScreenHarness() async {
  final harness = ScenarioHarness(
    appContent: DownloadsScreen(),
    afterEach: (tester, binding, ref, harnessName, scenarioName) async =>
        await ref.read(screenshotManagerStateProvider)?.pumpAndScreenshot(scenarioName, tester, binding),
    afterAll: (binding, ref, harnessName) async =>
        await ref.read(screenshotManagerStateProvider)?.uploadScreenshots(harnessName),
  );

  harness.addScenario(Scenario(name: "Main"));

  return harness;
}
