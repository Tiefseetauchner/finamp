// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:tief_test_harness/tief_test_harness.dart';
import 'downloads_screen/downloads_screen_harness.dart' as h0;

enum MainHarness {
  downloadsScreen;

  String get harnessName => switch (this) {
    MainHarness.downloadsScreen => 'Downloads Screen',
  };

  static MainHarness fromHarnessName(String name) =>
      values.firstWhere(
        (harness) => harness.harnessName == name,
        orElse: () => throw ArgumentError.value(
          name,
          'name',
          'No MainHarness with this harness name.',
        ),
      );
}

class MainHarnessRegistry {
  const MainHarnessRegistry() : this._(null);
  const MainHarnessRegistry._(this._selected);

  final Set<MainHarness>? _selected;

  static const Map<MainHarness, Future<ScenarioHarness> Function()> _builders = {
    MainHarness.downloadsScreen: h0.buildEmptyHomeScreenHarness,
  };

  /// Restricts a subsequent [build] to just [harnesses].
  MainHarnessRegistry only(Set<MainHarness> harnesses) =>
      MainHarnessRegistry._(harnesses);

  /// Restricts a subsequent [build] to just the harnesses named [names].
  MainHarnessRegistry onlyNamed(Set<String> names) =>
      only(names.map(MainHarness.fromHarnessName).toSet());

  /// Calls every selected builder and awaits the results, keyed by harness name.
  Future<Map<String, ScenarioHarness>> build() async {
    final selected = _selected == null
        ? _builders.entries
        : _builders.entries.where((entry) => _selected.contains(entry.key));

    final resolved = await Future.wait(
      selected.map((entry) async => MapEntry(entry.key.harnessName, await entry.value())),
    );

    return Map.fromEntries(resolved);
  }
}
