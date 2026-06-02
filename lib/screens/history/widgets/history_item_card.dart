import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/translation_model.dart';
import '../../../core/utils/date_utils.dart' as du;

class HistoryItemCard extends StatelessWidget {
  final TranslationModel translation;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onSave;

  const HistoryItemCard({
    super.key,
    required this.translation,
    required this.onTap,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(translation.id ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.07),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              const SizedBox(height: 10),
              _buildSourceText(),
              const SizedBox(height: 6),
              _buildDivider(),
              const SizedBox(height: 6),
              _buildTranslatedText(),
              const SizedBox(height: 12),
              _buildBottomRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        _LangPill(lang: translation.sourceLang ?? 'EN'),
        const SizedBox(width: 8),
        const Icon(Icons.arrow_forward, color: Color(0xFF00C896), size: 14),
        const SizedBox(width: 8),
        _LangPill(lang: translation.targetLang ?? 'ES'),
        const Spacer(),
        if (translation.isSaved == true)
          const Icon(Icons.star_rounded, color: Color(0xFF00C896), size: 18),
        const SizedBox(width: 4),
        Text(
          du.AppDateUtils.timeAgo(translation.createdAt),
          style: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceText() {
    return Text(
      translation.sourceText ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white.withOpacity(0.55),
        fontSize: 14,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Container(
          width: 3,
          height: 3,
          decoration: const BoxDecoration(
            color: Color(0xFF00C896),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ],
    );
  }

  Widget _buildTranslatedText() {
    return Text(
      translation.translatedText ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        _ActionBtn(
          icon: Icons.copy_outlined,
          label: 'Copy',
          onTap: () {
            Clipboard.setData(ClipboardData(text: translation.translatedText ?? ''));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Copied to clipboard'),
                backgroundColor: const Color(0xFF1A1A1A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          icon: translation.isSaved == true ? Icons.star_rounded : Icons.star_border_rounded,
          label: translation.isSaved == true ? 'Saved' : 'Save',
          onTap: onSave,
          isActive: translation.isSaved == true,
        ),
        const Spacer(),
        _ActionBtn(
          icon: Icons.delete_outline,
          label: 'Delete',
          onTap: onDelete,
          isDestructive: true,
        ),
      ],
    );
  }
}

class _LangPill extends StatelessWidget {
  final String lang;
  const _LangPill({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF00C896).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        lang.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00C896),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDestructive;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.redAccent.withOpacity(0.7)
        : isActive
            ? const Color(0xFF00C896)
            : Colors.white.withOpacity(0.4);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }
}
