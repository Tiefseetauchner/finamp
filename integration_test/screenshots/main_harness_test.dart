import 'package:finamp/components/PlayerScreen/player_split_screen_scaffold.dart';
import 'package:finamp/l10n/app_localizations.dart';
import 'package:finamp/services/keep_screen_on_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
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
    appBuilder: ({required child, required locale, providerScopeBuilder}) => UncontrolledProviderScope(
      container: GetIt.instance<ProviderContainer>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {"/": (context) => child},
        initialRoute: "/",
        navigatorObservers: [SplitScreenNavigatorObserver(), KeepScreenOnObserver()],
        builder: (BuildContext context, Widget? widget) {
          return buildPlayerSplitScreenScaffold(context, widget);
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        // We awkwardly put English as the first supported locale so
        // that basicLocaleListResolution falls back to it instead of
        // the first language in supportedLocales (Arabic as of writing)
        localeListResolutionCallback: (locales, supportedLocales) =>
            basicLocaleListResolution(locales, [const Locale("en")].followedBy(supportedLocales)),
        locale: locale,
      ),
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
