import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('docs/instructions.md'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Markdown(
                  data: snapshot.data!,
                  styleSheet: MarkdownStyleSheet(
                    h1: context.textStyles.headlineLarge,
                    h2: context.textStyles.headlineMedium,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text('Error loading instructions: ${snapshot.error}'),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
