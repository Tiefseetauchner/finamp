import 'package:finamp/components/global_snackbar.dart';
import 'package:finamp/models/jellyfin_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tief_test_harness/tief_test_harness.dart';

import '../../helpers.dart';
import '../harness_creation.dart';

@RegisterHarness("main", name: "Home Screen")
Future<ScenarioHarness> buildHomeScreenHarness() async {
  final harness = createHarness();

  harness.addScenario(
    Scenario(
      name: "Main",
      testCallback: (tester, binding) async {
        await loginToJellyfin(tester);

        GlobalSnackbar.navigatorState!.pushNamed(
          "/music/album",
          arguments: BaseItemDto(id: BaseItemId("<YOUR_ALBUM_ID>")),
        );
      },
    ),
  );

  return harness;
}
