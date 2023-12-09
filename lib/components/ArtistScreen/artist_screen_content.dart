import 'package:finamp/services/queue_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/finamp_models.dart';
import '../../models/jellyfin_models.dart';
import '../../services/jellyfin_api_helper.dart';
import '../AlbumScreen/album_screen_content.dart';
import '../AlbumScreen/song_list_tile.dart';
import '../MusicScreen/music_screen_tab_view.dart';

class ArtistScreenContent extends StatefulWidget {
  const ArtistScreenContent({Key? key, required this.parent}) : super(key: key);

  final BaseItemDto parent;

  @override
  State<ArtistScreenContent> createState() => _ArtistScreenContentState();
}

class _ArtistScreenContentState extends State<ArtistScreenContent> {
  Future<List<BaseItemDto>?>? songs;
  JellyfinApiHelper jellyfinApiHelper = GetIt.instance<JellyfinApiHelper>();

  @override
  Widget build(BuildContext context) {
    songs ??= jellyfinApiHelper.getItems(
      parentItem: widget.parent,
      filters: "Artist=${widget.parent.name}",
      sortBy: "PlayCount",
      includeItemTypes: "Audio",
      isGenres: false,
    );

    return FutureBuilder(
        future: songs,
        builder: (context, snapshot) {
          var orderedSongs = snapshot.data?.reversed.toList() ?? [];

          return Scrollbar(
              child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
              const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
              SliverToBoxAdapter(
                  child: Text(
                AppLocalizations.of(context)!.topSongs,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              SongsSliverList(
                childrenForList: orderedSongs.take(5).toList(),
                childrenForQueue: orderedSongs,
                showArtist: false,
                showPlayCount: true,
                parent: widget.parent,
              ),
              const SliverPadding(padding: EdgeInsets.fromLTRB(0, 15.0, 0, 0)),
              SliverToBoxAdapter(
                  child: Text(
                AppLocalizations.of(context)!.albums,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
            ],
            body: MusicScreenTabView(
                tabContentType: TabContentType.albums,
                parentItem: widget.parent,
                isFavourite: false),
          ));
        });
  }
}
