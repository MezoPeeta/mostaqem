import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mostaqem/src/core/screens/screens.dart';
import 'package:mostaqem/src/screens/navigation/repository/fullscreen_notifier.dart';
import 'package:mostaqem/src/screens/navigation/widgets/player_widget.dart';
import 'package:mostaqem/src/shared/widgets/full_screen.dart';
import 'package:mostaqem/src/shared/widgets/tooltip_icon.dart';
import 'package:mostaqem/src/shared/widgets/window_buttons.dart';

final isExtendedProvider = StateProvider<bool>((ref) => false);

class Navigation extends ConsumerWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullScreen = ref.watch(isFullScreenProvider);
    final player = ref.watch(playerSurahProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isFullScreen
          ? FullScreenWidget(player: player!, ref: ref)
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    const WindowButtons(),
                    Expanded(
                      child: Consumer(builder: (context, ref, child) {
                        final children = ref.watch(childrenProvider);
                        final screenIndex = ref.watch(indexScreenProvider);
                        return Row(
                          children: [
                            RightSide(
                                children: children, screenIndex: screenIndex,),
                            LeftSide(
                                children: children, screenIndex: screenIndex,),
                          ],
                        );
                      },),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class RightSide extends ConsumerWidget {
  const RightSide({
    required this.children, required this.screenIndex, super.key,
  });
  final List<Screen> children;
  final int screenIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            extended: ref.watch(isExtendedProvider),
            leading: ToolTipIconButton(
              message: 'توسيع',
              icon: const Icon(Icons.menu),
              onPressed: () => ref
                  .read(isExtendedProvider.notifier)
                  .update((state) => !state),
            ),
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            destinations: [
              ...children.map((child) => NavigationRailDestination(
                  icon: child.icon,
                  label: Text(child.label),
                  selectedIcon: child.selectedIcon,),),
            ],
            selectedIndex: screenIndex,
            onDestinationSelected: (value) =>
                ref.read(indexScreenProvider.notifier).state = value,
          ),
        ),
      ),
    );
  }
}

class LeftSide extends StatelessWidget {
  const LeftSide({
    required this.children, required this.screenIndex, super.key,
  });

  final List<Screen> children;
  final int screenIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: children[screenIndex].widget,
    ),);
  }
}
