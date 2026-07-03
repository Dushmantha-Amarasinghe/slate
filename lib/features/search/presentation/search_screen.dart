import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/db/tables/tasks_table.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/tokens/spacing_tokens.dart';
import '../../../core/widgets/icon_badge.dart';
import '../../../core/widgets/priority_bars.dart';
import '../../../core/widgets/section_label.dart';
import '../../../core/widgets/dropdown_chip.dart';
import '../../../core/widgets/undo_delete_snackbar.dart';
import '../../../data/pending_delete_controller.dart';
import '../../../data/task_actions.dart';
import '../../tags/application/tag_controller.dart';
import '../../today/presentation/widgets/task_card.dart';
import '../application/search_controller.dart';
import '../application/search_history_prefs.dart';

/// Full-screen search overlay (spec section 2): live filter across every
/// task's title/description, plus tag/priority/due-date filter chips —
/// simple in-memory filtering over [allTasksProvider] rather than a DB
/// query, which the spec explicitly calls "fine for v1" at personal-todo
/// dataset sizes (FTS5 is a later optimization if it's ever needed).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  List<String> _recentQueries = <String>[];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
    SearchHistoryPrefs.recent().then((List<String> recent) {
      if (mounted) setState(() => _recentQueries = recent);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _runQuery(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> _commitQuery(String query) async {
    final List<String> updated = await SearchHistoryPrefs.add(query);
    if (mounted) setState(() => _recentQueries = updated);
  }

  @override
  Widget build(BuildContext context) {
    final String query = ref.watch(searchQueryProvider);
    final String? tagFilter = ref.watch(searchTagFilterProvider);
    final TaskPriority? priorityFilter = ref.watch(searchPriorityFilterProvider);
    final SearchDateFilter dateFilter = ref.watch(searchDateFilterProvider);
    final List<Tag> tags = ref.watch(allTagsProvider).value ?? const <Tag>[];
    final Map<String, Tag> tagsById = ref.watch(tagsByIdProvider);
    final Set<String> pendingDelete = ref.watch(pendingDeleteProvider);

    final bool hasAnyFilter = query.trim().isNotEmpty ||
        tagFilter != null ||
        priorityFilter != null ||
        dateFilter != SearchDateFilter.any;
    final List<Task> results = ref
        .watch(searchResultsProvider)
        .where((Task t) => !pendingDelete.contains(t.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).canPop() ? Navigator.of(context).pop() : context.go(AppRoutes.today),
        ),
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search tasks',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (String value) => ref.read(searchQueryProvider.notifier).state = value,
          onSubmitted: (String value) => _commitQuery(value),
        ),
        actions: <Widget>[
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Clear',
              onPressed: () => _runQuery(''),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
            child: Row(
              children: <Widget>[
                _FilterDropdown<SearchDateFilter>(
                  icon: const Icon(Icons.event_outlined),
                  label: dateFilter == SearchDateFilter.any ? 'Date' : _dateFilterLabel(dateFilter),
                  selected: dateFilter != SearchDateFilter.any,
                  options: <(SearchDateFilter, String)>[
                    for (final SearchDateFilter filter in <SearchDateFilter>[
                      SearchDateFilter.overdue,
                      SearchDateFilter.dueToday,
                      SearchDateFilter.dueThisWeek,
                      SearchDateFilter.noDueDate,
                    ])
                      (filter, _dateFilterLabel(filter)),
                  ],
                  onSelected: (SearchDateFilter filter) =>
                      ref.read(searchDateFilterProvider.notifier).state = filter,
                  onClear: dateFilter == SearchDateFilter.any
                      ? null
                      : () => ref.read(searchDateFilterProvider.notifier).state = SearchDateFilter.any,
                ),
                const SizedBox(width: AppSpacing.xs),
                _FilterDropdown<TaskPriority>(
                  icon: PriorityBars(priority: priorityFilter ?? TaskPriority.medium, maxHeight: 12),
                  label: priorityFilter == null ? 'Priority' : priorityLabel(priorityFilter),
                  selected: priorityFilter != null,
                  options: <(TaskPriority, String)>[
                    for (final TaskPriority priority in TaskPriority.values.where(
                      (TaskPriority p) => p != TaskPriority.none,
                    ))
                      (priority, priorityLabel(priority)),
                  ],
                  onSelected: (TaskPriority priority) =>
                      ref.read(searchPriorityFilterProvider.notifier).state = priority,
                  onClear: priorityFilter == null
                      ? null
                      : () => ref.read(searchPriorityFilterProvider.notifier).state = null,
                ),
                if (tags.isNotEmpty) ...<Widget>[
                  const SizedBox(width: AppSpacing.xs),
                  _FilterDropdown<String>(
                    icon: const Icon(Icons.label_outline),
                    label: tagFilter == null ? 'Tag' : (tagsById[tagFilter]?.name ?? 'Tag'),
                    selected: tagFilter != null,
                    options: <(String, String)>[
                      for (final Tag tag in tags) (tag.id, tag.name),
                    ],
                    onSelected: (String tagId) => ref.read(searchTagFilterProvider.notifier).state = tagId,
                    onClear: tagFilter == null
                        ? null
                        : () => ref.read(searchTagFilterProvider.notifier).state = null,
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: !hasAnyFilter
                ? _SearchIdleState(
                    queries: _recentQueries,
                    tags: tags,
                    onSelectQuery: _runQuery,
                    onSelectTag: (String tagId) =>
                        ref.read(searchTagFilterProvider.notifier).state = tagId,
                    onClearQueries: () async {
                      await SearchHistoryPrefs.clear();
                      if (mounted) setState(() => _recentQueries = <String>[]);
                    },
                  )
                : results.isEmpty
                    ? _NoResults(query: query)
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: results.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Task task = results[index];
                          return TaskCard(
                            key: ValueKey<String>(task.id),
                            task: task,
                            tag: task.tagId == null ? null : tagsById[task.tagId],
                            onToggleComplete: () => task.isCompleted
                                ? ref.read(taskActionsProvider).uncompleteTask(task.id)
                                : ref.read(taskActionsProvider).completeTask(task.id),
                            onTap: () {
                              if (query.trim().isNotEmpty) _commitQuery(query);
                              context.push(AppRoutes.taskDetailPath(task.id));
                            },
                            onDelete: () =>
                                showUndoDeleteSnackbar(context, ref, taskId: task.id, taskTitle: task.title),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _dateFilterLabel(SearchDateFilter filter) => switch (filter) {
        SearchDateFilter.any => 'Any date',
        SearchDateFilter.overdue => 'Overdue',
        SearchDateFilter.dueToday => 'Due today',
        SearchDateFilter.dueThisWeek => 'Due this week',
        SearchDateFilter.noDueDate => 'No due date',
      };
}

/// What Search shows before any query/filter is active — recent queries
/// and a "browse by tag" shortcut, both as compact chips matching the
/// filter row above, rather than a single sparse list with a lot of
/// leftover space under it.
class _SearchIdleState extends StatelessWidget {
  const _SearchIdleState({
    required this.queries,
    required this.tags,
    required this.onSelectQuery,
    required this.onSelectTag,
    required this.onClearQueries,
  });

  final List<String> queries;
  final List<Tag> tags;
  final ValueChanged<String> onSelectQuery;
  final ValueChanged<String> onSelectTag;
  final VoidCallback onClearQueries;

  @override
  Widget build(BuildContext context) {
    if (queries.isEmpty && tags.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const IconBadge(icon: Icons.search, size: 56, iconSize: 26),
              const SizedBox(height: AppSpacing.md),
              Text('Search your tasks', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Find anything by title, description, tag, priority, or due date.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    final ColorScheme scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: <Widget>[
        if (queries.isNotEmpty) ...<Widget>[
          SectionLabel(
            'Recent',
            trailing: GestureDetector(
              onTap: onClearQueries,
              child: const Text('Clear'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (final String query in queries)
                ActionChip(
                  avatar: Icon(Icons.history, size: 16, color: scheme.onSurface.withValues(alpha: 0.6)),
                  label: Text(query),
                  onPressed: () => onSelectQuery(query),
                ),
            ],
          ),
        ],
        if (queries.isNotEmpty && tags.isNotEmpty) const SizedBox(height: AppSpacing.lg),
        if (tags.isNotEmpty) ...<Widget>[
          const SectionLabel('Browse by tag'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (final Tag tag in tags)
                ActionChip(
                  label: Text(tag.name),
                  onPressed: () => onSelectTag(tag.id),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Adapts [DropdownChip]'s generic menu-item builder to a plain list of
/// (value, label) options — three compact triggers (Date, Priority, Tag)
/// read far less busy than eight-plus standalone [ChoiceChip]s competing
/// for attention above the results list.
class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
    this.onClear,
  });

  final Widget icon;
  final String label;
  final bool selected;
  final List<(T, String)> options;
  final ValueChanged<T> onSelected;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return DropdownChip<T>(
      icon: icon,
      label: label,
      selected: selected,
      onClear: onClear,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<T>>[
        for (final (T, String) option in options)
          PopupMenuItem<T>(value: option.$1, child: Text(option.$2)),
      ],
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const IconBadge(icon: Icons.search_off, size: 56, iconSize: 26),
            const SizedBox(height: AppSpacing.md),
            Text('No matches', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              query.trim().isEmpty
                  ? 'No tasks match the selected filters.'
                  : 'Nothing matches "$query".',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
