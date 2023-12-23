import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../components/DownloadsErrorScreen/download_error_list.dart';

class DownloadsErrorScreen extends StatelessWidget {
  const DownloadsErrorScreen({Key? key}) : super(key: key);

  static const routeName = "/downloads/errors";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.downloadErrorsTitle),
          /*actions: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final appLocalizations = AppLocalizations.of(context);

                  final redownloaded = 0; //await downloadsHelper.redownloadFailed();
                  //TODO decide what to do here.  Do we want to just merge this into sync?
                  // Maybe show currently downloading items here as well as failed?

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          appLocalizations!.redownloadedItems(redownloaded)),
                    ),
                  );
                })
          ]*/
          ),
      body: const DownloadErrorList(),
    );
  }
}
