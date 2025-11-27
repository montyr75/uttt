// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GameCtrl)
const gameCtrlProvider = GameCtrlProvider._();

final class GameCtrlProvider extends $NotifierProvider<GameCtrl, GameState> {
  const GameCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameCtrlHash();

  @$internal
  @override
  GameCtrl create() => GameCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameState>(value),
    );
  }
}

String _$gameCtrlHash() => r'63df894a53313e8180c455bdbe20bef97b73c8bc';

abstract class _$GameCtrl extends $Notifier<GameState> {
  GameState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GameState, GameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameState, GameState>,
              GameState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
