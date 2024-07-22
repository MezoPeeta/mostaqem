import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mostaqem/src/screens/navigation/repository/download_repository.dart';

import '../../../core/routes/routes.dart';
import '../../../shared/widgets/tooltip_icon.dart';
import '../repository/player_repository.dart';
import 'full_screen_controls.dart';
import 'play_controls.dart';
import 'player_widget.dart';
import 'playing_surah.dart';
import 'volume_control.dart';

class NormalPlayer extends StatelessWidget {
  const NormalPlayer({
    super.key,
    required this.isFullScreen,
    required this.ref,
  });

  final bool isFullScreen;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        PlayingSurah(
          isFullScreen: isFullScreen,
          ref: ref,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: PlayControls(
            isFullScreen: isFullScreen,
            ref: ref,
          ),
        ),
        Row(
          children: [
            Visibility(
              visible:
                  !ref.read(playerNotifierProvider.notifier).isLocalAudio(),
              child: ToolTipIconButton(
                  message: "تحميل",
                  iconSize: 16,
                  onPressed: () async {
                    final album = ref.read(playerSurahProvider);
                    ref
                        .read(downloadAudioProvider.notifier)
                        .download(album: album!);
                  },
                  icon: const Icon(Icons.download_for_offline)),
            ),
            Visibility(
              visible: !isFullScreen &&
                  !ref.read(playerNotifierProvider.notifier).isLocalAudio(),
              child: ToolTipIconButton(
                message: "اقرأ",
                onPressed: () async {
                  final surahID = ref.read(playerSurahProvider)!.surah.id;

                  ref.watch(goRouterProvider).goNamed(
                        'Reading',
                        extra: surahID,
                      );
                },
                icon: SvgPicture.asset(
                  "assets/img/read.svg",
                  width: 16,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSecondaryContainer,
                      BlendMode.srcIn),
                ),
              ),
            ),
            const VolumeControls(),
            FullScreenControl(ref: ref, isFullScreen: isFullScreen)
          ],
        ),
      ]),
    );
  }
}
