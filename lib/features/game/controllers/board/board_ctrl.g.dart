// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BoardCtrl)
const boardCtrlProvider = BoardCtrlFamily._();

final class BoardCtrlProvider extends $NotifierProvider<BoardCtrl, BoardState> {
  const BoardCtrlProvider._({
    required BoardCtrlFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'boardCtrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boardCtrlHash();

  @override
  String toString() {
    return r'boardCtrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BoardCtrl create() => BoardCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BoardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BoardState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoardCtrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boardCtrlHash() => r'fd925a4eff518dbbdce6bc5bd7afe6de7abb7f38';

final class BoardCtrlFamily extends $Family
    with
        $ClassFamilyOverride<
          BoardCtrl,
          BoardState,
          BoardState,
          BoardState,
          int
        > {
  const BoardCtrlFamily._()
    : super(
        retry: null,
        name: r'boardCtrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BoardCtrlProvider call(int boardIndex) =>
      BoardCtrlProvider._(argument: boardIndex, from: this);

  @override
  String toString() => r'boardCtrlProvider';
}

abstract class _$BoardCtrl extends $Notifier<BoardState> {
  late final _$args = ref.$arg as int;
  int get boardIndex => _$args;

  BoardState build(int boardIndex);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<BoardState, BoardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BoardState, BoardState>,
              BoardState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
