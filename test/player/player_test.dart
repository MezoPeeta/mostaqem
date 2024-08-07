import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mostaqem/src/screens/home/data/surah.dart';
import 'package:mostaqem/src/screens/navigation/data/album.dart';
import 'package:mostaqem/src/screens/navigation/repository/player_repository.dart';
import 'package:mostaqem/src/screens/navigation/widgets/player_widget.dart';
import 'package:mostaqem/src/screens/offline/repository/offline_repository.dart';
import 'package:mostaqem/src/screens/reciters/data/reciters_data.dart';
import 'package:mostaqem/src/shared/widgets/tooltip_icon.dart';

import '../core/container.dart';

// to whatever your notifier uses

void main() {
  const channel = MethodChannel('media_kit/media_kit');
  const surah = Surah(
      id: 0,
      simpleName: "simpleName",
      arabicName: "arabicName",
      revelationPlace: "revelationPlace");

  const reciter = Reciter(
      id: 0, englishName: "reciterName", arabicName: "reciterArabicName");

  setUp(() {
    handler(MethodCall methodCall) async {
      if (methodCall.method == 'ensureInitialized') {
        return true;
      }
      return null;
    }

    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
    MediaKit.ensureInitialized();
  });

  testWidgets('Test Text appears on player', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 500));

    await tester.pumpWidget(ProviderScope(overrides: [
      isAudioDownloaded.overrideWith((ref) async* {
        yield false;
      }),
      playerSurahProvider.overrideWith((ref) =>
          const Album(surah: surah, reciter: reciter, url: "http://test")),
    ], child: const MaterialApp(home: Material(child: PlayerWidget()))));

    await tester.pumpAndSettle();

    expect(find.text("arabicName"), findsOneWidget);
    expect(find.text("reciterArabicName"), findsOneWidget);
  });

  testWidgets('Test Player buttons', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 500));

    await tester.pumpWidget(ProviderScope(overrides: [
      playerNotifierProvider.overrideWith(PlayerNotifierMock.new),
      isAudioDownloaded.overrideWith((ref) async* {
        yield false;
      }),
      playerSurahProvider.overrideWith((ref) =>
          const Album(surah: surah, reciter: reciter, url: "http://test")),
    ], child: const MaterialApp(home: Material(child: PlayerWidget()))));

    final pauseBtn = find.byTooltip("تشغيل");

    await tester.tap(pauseBtn);

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.pause_circle_filled_outlined), findsOneWidget);

    expect(find.byTooltip("اعادة"), findsOneWidget);
    expect(find.byTooltip("بعد"), findsOneWidget);
    expect(find.byTooltip("قبل"), findsOneWidget);
    expect(find.byTooltip("اقرأ"), findsOneWidget);
    expect(find.byTooltip("صامت"), findsOneWidget);

    final muteBtn = find.byTooltip("صامت");
    await tester.tap(muteBtn);
    await tester.pumpAndSettle();
    expect(find.byTooltip("صامت"), findsNothing);

    final volumeSlider = find.byKey(const Key("volume"));
    await tester.drag(volumeSlider, const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(find.byTooltip("صامت"), findsOneWidget);
  });
}