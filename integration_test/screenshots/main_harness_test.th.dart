// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:tief_test_harness/tief_test_harness.dart';
import 'splash_screen/splash_screen_harness.dart' as h0;

enum PhoneHarness {
  splashScreen;

  String get harnessName => switch (this) {
    PhoneHarness.splashScreen => 'Splash Screen',
  };

  static PhoneHarness fromHarnessName(String name) =>
      values.firstWhere(
        (harness) => harness.harnessName == name,
        orElse: () => throw ArgumentError.value(
          name,
          'name',
          'No PhoneHarness with this harness name.',
        ),
      );
}

class PhoneHarnessRegistry {
  const PhoneHarnessRegistry() : this._(null);
  const PhoneHarnessRegistry._(this._selected);

  final Set<PhoneHarness>? _selected;

  static const Map<PhoneHarness, Future<ScenarioHarness> Function()> _builders = {
    PhoneHarness.splashScreen: h0.buildEmptyHomeScreenHarness,
  };

  /// Restricts a subsequent [build] to just [harnesses].
  PhoneHarnessRegistry only(Set<PhoneHarness> harnesses) =>
      PhoneHarnessRegistry._(harnesses);

  /// Restricts a subsequent [build] to just the harnesses named [names].
  PhoneHarnessRegistry onlyNamed(Set<String> names) =>
      only(names.map(PhoneHarness.fromHarnessName).toSet());

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
