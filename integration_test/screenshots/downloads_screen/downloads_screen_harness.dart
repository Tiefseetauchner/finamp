import 'package:finamp/screens/downloads_screen.dart';
import 'package:tief_test_harness/tief_test_harness.dart';

import '../harness_creation.dart';

@RegisterHarness("phone", name: "Downloads Screen")
Future<ScenarioHarness> buildEmptyHomeScreenHarness() async {
  final harness = createHarness(child: DownloadsScreen());

  harness.addScenario(Scenario(name: "Main"));

  return harness;
}
