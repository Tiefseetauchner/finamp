import 'dart:async';
import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:finamp/components/Buttons/cta_huge.dart';
import 'package:finamp/components/LoginScreen/login_server_selection_page.dart';
import 'package:finamp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:finamp/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

Future<(bool, List<FlutterErrorDetails>)> initializeApp() async {
  bool mainCompleted = false;
  List<FlutterErrorDetails> mainErrors = [];

  // If main throws an error, the future runZoneGuarded returns will never complete, so do not await it.
  // Instead, we will simply check that main has completed with no errors after a 30 second timeout. This also
  // allows some errors thrown by the background services to be caught before the following tests start.
  unawaited(
    runZonedGuarded(
      () async {
        // Login testing flag redirects file accesses to testing folder and clears it on startup.
        // Download base directories are not redirected, so loginTesting flag should be avoided on mobile.
        // Note that this means mobile integration test runs will require manual file clearing outside of CI
        await app.main([], integrationTesting: true, loginTesting: !(Platform.isAndroid || Platform.isIOS));
        mainCompleted = true;
      },
      (e, stack) {
        // Linux throws DBusServiceUnknownException due to dbus service org.freedesktop.UPower
        // missing in CI. Ignore.
        if (e is DBusServiceUnknownException) return;

        mainErrors.add(FlutterErrorDetails(exception: e, stack: stack));
      },
    ),
  );

  Stopwatch stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < Duration(seconds: 30)) {
    if (mainCompleted) return (true, mainErrors);

    await Future<void>.delayed(Duration(seconds: 1));
  }

  return (mainCompleted, mainErrors);
}

extension WaitForElement on WidgetTester {
  Future<void> waitFor(Finder finder, {int seconds = 20, bool realtime = true}) async {
    int i = 0;
    while (true) {
      await pump(Duration(seconds: 1));
      if (any(finder)) {
        return;
      }
      if (i >= seconds) {
        throw "$finder never found expected widget after $seconds seconds.";
      }
      i++;
      if (realtime) {
        await Future<void>.delayed(Duration(seconds: 1));
      }
    }
  }
}

Future<void> loginToJellyfin(WidgetTester tester) async {
  await tester.waitFor(find.byType(LoginScreen));

  final startButton = find.byType(CTAHuge);
  await tester.tap(startButton);
  await tester.pump();

  final serverUrl = const String.fromEnvironment("JELLYFIN_SERVER", defaultValue: "https://demo.jellyfin.org/stable");
  final username = const String.fromEnvironment("JELLYFIN_USER", defaultValue: "demo");
  final password = const String.fromEnvironment("JELLYFIN_PASSWORD", defaultValue: "");

  final urlEntry = find.byType(TextFormField);
  await tester.enterText(urlEntry, serverUrl);

  final serverButton = find.byWidgetPredicate(
    (x) => x is JellyfinServerSelectionWidget && (x.baseUrl?.contains(serverUrl) ?? false),
  );
  await tester.waitFor(serverButton);
  await tester.tap(serverButton);
  await tester.pump(Duration(seconds: 1));

  final customUserButton = find.text("Custom User");
  await tester.tap(customUserButton);
  await tester.pump(Duration(seconds: 1));

  final userTextField = find.byType(TextFormField).first;
  await tester.enterText(userTextField, username);
  final passwordTextField = find.byType(TextFormField).at(1);
  await tester.enterText(passwordTextField, password);
  final loginButton = find.text("Log In");
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}
