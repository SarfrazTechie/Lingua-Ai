import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/history_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import 'widgets/history_item_card.dart';
import 'widgets/history_filter_bar.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, user?.name),
            _buildSearchBar(),
            HistoryFilterBar(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) => setState(() => _selectedFilter = filter),
            ),
            Expanded(
              child: historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00C896))),
                error: (e, _) => _buildErrorState(),
                data: (items) {
                  final filtered = _filterItems(items);
                  if (filtered.isEmpty) return _buildEmptyState();
                  return _buildHistoryList(filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? userName) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('History', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('Your past translations', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 14)),
            ],
          ),
          _buildClearButton(),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return Consumer(
      builder: (context, ref, _) {
        return TextButton.icon(
          onPressed: () => _showClearDialog(context, ref),
          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFF00C896)),
          label: const Text('Clear', style: TextStyle(color: Color(0xFF00C896), fontSize: 14)),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF00C896).withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search translations...',
            hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.35), fontSize: 15),
            prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withValues(alpha: 0.4), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurface.withValues(alpha: 0.4), size: 18),
                    onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<dynamic> items) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return HistoryItemCard(
          translation: item,
          onTap: () => _onItemTap(context, item),
          onDelete: () => _deleteItem(item.id),
          onSave: () => _toggleSave(item),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.history_rounded, color: Color(0xFF00C896), size: 40),
          ),
          const SizedBox(height: 20),
          Text('No translations yet', style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Start translating to see your history here',
            style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.45), fontSize: 14),
            textAlign: TextAlign.center),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => context.go('/translator'),
            icon: const Icon(Icons.translate, size: 18),
            label: const Text('Start Translating'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C896),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red.withValues(alpha: 0.7), size: 48),
          const SizedBox(height: 12),
          Text('Something went wrong', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 16)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => ref.refresh(historyProvider),
            child: const Text('Retry', style: TextStyle(color: Color(0xFF00C896))),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterItems(List<dynamic> items) {
    var result = items;
    if (_searchQuery.isNotEmpty) {
      result = result.where((item) {
        final source = item.sourceText?.toLowerCase() ?? '';
        final translated = item.translatedText?.toLowerCase() ?? '';
        final sourceLang = item.sourceLang?.toLowerCase() ?? '';
        final targetLang = item.targetLang?.toLowerCase() ?? '';
        return source.contains(_searchQuery) || translated.contains(_searchQuery) ||
            sourceLang.contains(_searchQuery) || targetLang.contains(_searchQuery);
      }).toList();
    }
    if (_selectedFilter == 'Saved') {
      result = result.where((item) => item.isSaved == true).toList();
    } else if (_selectedFilter == 'Today') {
      final today = DateTime.now();
      result = result.where((item) {
        final created = item.createdAt as DateTime?;
        if (created == null) return false;
        return created.year == today.year && created.month == today.month && created.day == today.day;
      }).toList();
    } else if (_selectedFilter == 'This Week') {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      result = result.where((item) {
        final created = item.createdAt as DateTime?;
        if (created == null) return false;
        return created.isAfter(weekAgo);
      }).toList();
    }
    return result;
  }

  void _onItemTap(BuildContext context, dynamic item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _DetailSheet(item: item),
    );
  }

  void _deleteItem(String? id) {
    if (id == null) return;
    ref.read(historyProvider.notifier).deleteItem(id);
  }

  void _toggleSave(dynamic item) {
    ref.read(historyProvider.notifier).toggleSave(item);
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear History', style: TextStyle(color: colorScheme.onSurface)),
        content: Text('All translation history will be deleted. This cannot be undone.',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)))),
          TextButton(
            onPressed: () { ref.read(historyProvider.notifier).clearAll(); Navigator.pop(context); },
            child: const Text('Clear', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final dynamic item;
  const _DetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _LangChip(label: item.sourceLang ?? 'EN'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, color: Color(0xFF00C896), size: 16)),
              _LangChip(label: item.targetLang ?? 'ES'),
            ],
          ),
          const SizedBox(height: 16),
          Text(item.sourceText ?? '', style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
          const SizedBox(height: 12),
          Text(item.translatedText ?? '', style: TextStyle(color: colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    side: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.translate, size: 16),
                  label: const Text('Retranslate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C896),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  const _LangChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00C896).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00C896).withValues(alpha: 0.3)),
      ),
      child: Text(label.toUpperCase(), style: const TextStyle(
        color: Color(0xFF00C896), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
