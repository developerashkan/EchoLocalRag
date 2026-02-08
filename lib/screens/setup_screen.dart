import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key, required this.statusMessage});

  final String statusMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Echo Setup',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                statusMessage,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color(0xFF4D4D4D),
                ),
              ),
              const SizedBox(height: 24),
              _SetupStep(
                title: 'Connect your local vector store',
                description:
                    'Provide an ObjectBox Store with your note chunks and embeddings.',
              ),
              const SizedBox(height: 16),
              _SetupStep(
                title: 'Attach your embedder + Gemma runtime',
                description:
                    'Wire up an Embedder and GemmaService to run fully offline.',
              ),
              const Spacer(),
              Text(
                'Once configured, rebuild the app with injected dependencies.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF6A6A6A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF4D4D4D),
            ),
          ),
        ],
      ),
    );
  }
}
