import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/platform_support.dart';

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

              const SizedBox(height: 12),
              Text(
                isCurrentPlatformSupported()
                    ? 'Platform support: ${currentPlatformLabel()} is supported.'
                    : 'Platform support: ${currentPlatformLabel()} is not fully supported yet.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6A6A6A),
                ),
              ),
              const SizedBox(height: 24),
              _SetupStep(
                title: 'Add a Gemma .bin model asset',
                description:
                    'Place your model at assets/models/gemma-2b-it-gpu-int4.bin (or assets/models/gemma.bin).',
              ),
              const SizedBox(height: 16),
              _SetupStep(
                title: 'Restart the app',
                description:
                    'Echo automatically enables chat once a valid model file is detected.',
              ),
              const Spacer(),
              Text(
                'You can still inject custom dependencies, but the default setup now auto-detects model assets.',
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
