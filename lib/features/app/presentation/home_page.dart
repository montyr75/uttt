import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/screen_utils.dart';
import '../../../routes.dart';
import '../services/app/app_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appServiceProvider.select((state) => state.appVersion));

    final styles = context.textStyles;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: paddingAllXL,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 300,
                        ),
                        Text(
                          'Ultimate',
                          style: styles.headlineLarge,
                        ),
                        Text(
                          'Tic-Tac-Toe',
                          style: styles.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        boxXXL,
                        boxXXL,
                        boxXXL,
                        FilledButton(
                          onPressed: () => context.pushNamed(AppRoute.game.name),
                          child: const Text('Play Game'),
                        ),
                        boxXXL,
                        OutlinedButton(
                          onPressed: () => context.pushNamed(AppRoute.instructions.name),
                          child: const Text('Instructions'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                appVersion,
                style: styles.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
