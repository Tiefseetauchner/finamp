import 'package:finamp/models/finamp_models.dart';
import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../models/jellyfin_models.dart';
import '../../services/audio_service_helper.dart';
import '../album_image.dart';
import 'artist_item_info.dart';

class ArtistScreenContentFlexibleSpaceBar extends StatelessWidget {
  const ArtistScreenContentFlexibleSpaceBar({
    Key? key,
    required this.parentItem,
    required this.isGenre,
    required this.items,
  }) : super(key: key);

  final BaseItemDto parentItem;
  final bool isGenre;
  final List<BaseItemDto> items;

  @override
  Widget build(BuildContext context) {
    GetIt.instance<AudioServiceHelper>();
    QueueService queueService = GetIt.instance<QueueService>();

    void playAllFromArtist() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.linear,
      );
    }

    void shuffleAllFromArtist() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }

    void addArtistNext() {
      queueService.addNext(
          items: items,
          source: QueueItemSource(
            type: isGenre
                ? QueueItemSourceType.nextUpPlaylist
                : QueueItemSourceType.nextUpArtist,
            name: QueueItemSourceName(
                type: QueueItemSourceNameType.preTranslated,
                pretranslatedName: parentItem.name ??
                    AppLocalizations.of(context)!.placeholderSource),
            id: parentItem.id,
            item: parentItem,
          ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .confirmPlayNext(isGenre ? "genre" : "artist")),
        ),
      );
    }

    void shuffleAlbumsFromArtist() {
      queueService.startPlayback(
        items: items,
        source: QueueItemSource(
          type:
              isGenre ? QueueItemSourceType.genre : QueueItemSourceType.artist,
          name: QueueItemSourceName(
              type: QueueItemSourceNameType.preTranslated,
              pretranslatedName: parentItem.name ??
                  AppLocalizations.of(context)!.placeholderSource),
          id: parentItem.id,
          item: parentItem,
        ),
        order: FinampPlaybackOrder.shuffled,
      );
    }

    return FlexibleSpaceBar(
      background: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 125,
                      child: AlbumImage(item: parentItem),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                    Expanded(
                      flex: 2,
                      child: ArtistItemInfo(
                        item: parentItem,
                        itemSongs: items.length,
                        itemAlbums: parentItem.albumCount ?? 0,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
