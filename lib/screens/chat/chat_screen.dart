import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import 'widgets/chat_bubble.dart';
import '../../providers/auth_provider.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/mode_selector.dart';
import 'widgets/typing_indicator.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  String _selectedMode = 'Travel Companion';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (ref.read(chatProvider.notifier).limitReached) {
      context.go('/subscription');
      return;
    }
    if (text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text, mode: _selectedMode);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final isLoading = ref.read(chatProvider.notifier).isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    if (messages.isNotEmpty) _scrollToBottom();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/translator'),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('AI Chat',
                        style: AppTextStyles.headline3.copyWith(color: colorScheme.onSurface)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppGradients.premium,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Row(children: [
                      Icon(Icons.workspace_premium_rounded, color: Colors.black, size: 14),
                      SizedBox(width: 4),
                      Text('Pro', style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 11,
                        fontWeight: FontWeight.w700, color: Colors.black,
                      )),
                    ]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: messages.isEmpty
                  ? _buildScenarioSelector()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: messages.length + (isLoading ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == messages.length) return const TypingIndicator();
                        return ChatBubble(message: messages[i]);
                      },
                    ),
            ),
            if (messages.isNotEmpty)
              ModeSelector(
                selected: _selectedMode,
                onSelected: (mode) => setState(() => _selectedMode = mode),
              ),
            ChatInputBar(onSend: _sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).valueOrNull;
    final userName = user?.name.split(' ').first ?? 'there';
    final scenarios = [
      (Icons.flight_rounded, 'Travel Companion', 'Get help while traveling'),
      (Icons.business_center_rounded, 'Business Assistant', 'Professional support'),
      (Icons.school_rounded, 'Language Tutor', 'Learn and practice'),
      (Icons.chat_bubble_rounded, 'Casual Conversation', 'Chat about anything'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hi, $userName 👋',
              style: AppTextStyles.headline2.copyWith(color: colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text('How can I help you today?',
              style: AppTextStyles.body2.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 24),
          Text('Popular Scenarios',
              style: AppTextStyles.body2.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...scenarios.map((s) => _ScenarioCard(
                icon: s.$1,
                title: s.$2,
                subtitle: s.$3,
                onTap: () {
                  setState(() => _selectedMode = s.$2);
                  _sendMessage('Hello! I need help with ${s.$2}.');
                },
              )),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ScenarioCard({required this.icon, required this.title,
      required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body1.copyWith(
                      color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.caption
                      .copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }
}
