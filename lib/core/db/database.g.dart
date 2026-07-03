// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateTimeLocalMeta = const VerificationMeta(
    'dueDateTimeLocal',
  );
  @override
  late final GeneratedColumn<DateTime> dueDateTimeLocal =
      GeneratedColumn<DateTime>(
        'due_date_time_local',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timezoneIdMeta = const VerificationMeta(
    'timezoneId',
  );
  @override
  late final GeneratedColumn<String> timezoneId = GeneratedColumn<String>(
    'timezone_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateHasTimeMeta = const VerificationMeta(
    'dueDateHasTime',
  );
  @override
  late final GeneratedColumn<bool> dueDateHasTime = GeneratedColumn<bool>(
    'due_date_has_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("due_date_has_time" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskPriority, int> priority =
      GeneratedColumn<int>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskPriority>($TasksTable.$converterpriority);
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voiceNotePathMeta = const VerificationMeta(
    'voiceNotePath',
  );
  @override
  late final GeneratedColumn<String> voiceNotePath = GeneratedColumn<String>(
    'voice_note_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    dueDateTimeLocal,
    timezoneId,
    dueDateHasTime,
    isRecurring,
    recurrenceRule,
    priority,
    tagId,
    voiceNotePath,
    isCompleted,
    completedAt,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date_time_local')) {
      context.handle(
        _dueDateTimeLocalMeta,
        dueDateTimeLocal.isAcceptableOrUnknown(
          data['due_date_time_local']!,
          _dueDateTimeLocalMeta,
        ),
      );
    }
    if (data.containsKey('timezone_id')) {
      context.handle(
        _timezoneIdMeta,
        timezoneId.isAcceptableOrUnknown(data['timezone_id']!, _timezoneIdMeta),
      );
    }
    if (data.containsKey('due_date_has_time')) {
      context.handle(
        _dueDateHasTimeMeta,
        dueDateHasTime.isAcceptableOrUnknown(
          data['due_date_has_time']!,
          _dueDateHasTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    }
    if (data.containsKey('voice_note_path')) {
      context.handle(
        _voiceNotePathMeta,
        voiceNotePath.isAcceptableOrUnknown(
          data['voice_note_path']!,
          _voiceNotePathMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDateTimeLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date_time_local'],
      ),
      timezoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone_id'],
      ),
      dueDateHasTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}due_date_has_time'],
      )!,
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      priority: $TasksTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}priority'],
        )!,
      ),
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      ),
      voiceNotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_note_path'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TaskPriority, int, int> $converterpriority =
      const EnumIndexConverter<TaskPriority>(TaskPriority.values);
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDateTimeLocal;
  final String? timezoneId;

  /// False for a date-only due date (no specific time of day) — the task
  /// editor lets a due date be "just a day" as well as a precise moment.
  /// [dueDateTimeLocal] still stores a full DateTime either way (midnight
  /// local time when this is false); this flag is what the UI/reminder
  /// scheduler use to decide whether to show/treat it as a time. Defaults
  /// true so every pre-existing row (all of which had an explicit time
  /// before this column existed) keeps its current display behavior.
  final bool dueDateHasTime;
  final bool isRecurring;
  final String? recurrenceRule;
  final TaskPriority priority;
  final String? tagId;
  final String? voiceNotePath;
  final bool isCompleted;
  final DateTime? completedAt;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDateTimeLocal,
    this.timezoneId,
    required this.dueDateHasTime,
    required this.isRecurring,
    this.recurrenceRule,
    required this.priority,
    this.tagId,
    this.voiceNotePath,
    required this.isCompleted,
    this.completedAt,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDateTimeLocal != null) {
      map['due_date_time_local'] = Variable<DateTime>(dueDateTimeLocal);
    }
    if (!nullToAbsent || timezoneId != null) {
      map['timezone_id'] = Variable<String>(timezoneId);
    }
    map['due_date_has_time'] = Variable<bool>(dueDateHasTime);
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    {
      map['priority'] = Variable<int>(
        $TasksTable.$converterpriority.toSql(priority),
      );
    }
    if (!nullToAbsent || tagId != null) {
      map['tag_id'] = Variable<String>(tagId);
    }
    if (!nullToAbsent || voiceNotePath != null) {
      map['voice_note_path'] = Variable<String>(voiceNotePath);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDateTimeLocal: dueDateTimeLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDateTimeLocal),
      timezoneId: timezoneId == null && nullToAbsent
          ? const Value.absent()
          : Value(timezoneId),
      dueDateHasTime: Value(dueDateHasTime),
      isRecurring: Value(isRecurring),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      priority: Value(priority),
      tagId: tagId == null && nullToAbsent
          ? const Value.absent()
          : Value(tagId),
      voiceNotePath: voiceNotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNotePath),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDateTimeLocal: serializer.fromJson<DateTime?>(
        json['dueDateTimeLocal'],
      ),
      timezoneId: serializer.fromJson<String?>(json['timezoneId']),
      dueDateHasTime: serializer.fromJson<bool>(json['dueDateHasTime']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      priority: $TasksTable.$converterpriority.fromJson(
        serializer.fromJson<int>(json['priority']),
      ),
      tagId: serializer.fromJson<String?>(json['tagId']),
      voiceNotePath: serializer.fromJson<String?>(json['voiceNotePath']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDateTimeLocal': serializer.toJson<DateTime?>(dueDateTimeLocal),
      'timezoneId': serializer.toJson<String?>(timezoneId),
      'dueDateHasTime': serializer.toJson<bool>(dueDateHasTime),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'priority': serializer.toJson<int>(
        $TasksTable.$converterpriority.toJson(priority),
      ),
      'tagId': serializer.toJson<String?>(tagId),
      'voiceNotePath': serializer.toJson<String?>(voiceNotePath),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueDateTimeLocal = const Value.absent(),
    Value<String?> timezoneId = const Value.absent(),
    bool? dueDateHasTime,
    bool? isRecurring,
    Value<String?> recurrenceRule = const Value.absent(),
    TaskPriority? priority,
    Value<String?> tagId = const Value.absent(),
    Value<String?> voiceNotePath = const Value.absent(),
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDateTimeLocal: dueDateTimeLocal.present
        ? dueDateTimeLocal.value
        : this.dueDateTimeLocal,
    timezoneId: timezoneId.present ? timezoneId.value : this.timezoneId,
    dueDateHasTime: dueDateHasTime ?? this.dueDateHasTime,
    isRecurring: isRecurring ?? this.isRecurring,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    priority: priority ?? this.priority,
    tagId: tagId.present ? tagId.value : this.tagId,
    voiceNotePath: voiceNotePath.present
        ? voiceNotePath.value
        : this.voiceNotePath,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDateTimeLocal: data.dueDateTimeLocal.present
          ? data.dueDateTimeLocal.value
          : this.dueDateTimeLocal,
      timezoneId: data.timezoneId.present
          ? data.timezoneId.value
          : this.timezoneId,
      dueDateHasTime: data.dueDateHasTime.present
          ? data.dueDateHasTime.value
          : this.dueDateHasTime,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      priority: data.priority.present ? data.priority.value : this.priority,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      voiceNotePath: data.voiceNotePath.present
          ? data.voiceNotePath.value
          : this.voiceNotePath,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTimeLocal: $dueDateTimeLocal, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('dueDateHasTime: $dueDateHasTime, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('priority: $priority, ')
          ..write('tagId: $tagId, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDateTimeLocal,
    timezoneId,
    dueDateHasTime,
    isRecurring,
    recurrenceRule,
    priority,
    tagId,
    voiceNotePath,
    isCompleted,
    completedAt,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDateTimeLocal == this.dueDateTimeLocal &&
          other.timezoneId == this.timezoneId &&
          other.dueDateHasTime == this.dueDateHasTime &&
          other.isRecurring == this.isRecurring &&
          other.recurrenceRule == this.recurrenceRule &&
          other.priority == this.priority &&
          other.tagId == this.tagId &&
          other.voiceNotePath == this.voiceNotePath &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDateTimeLocal;
  final Value<String?> timezoneId;
  final Value<bool> dueDateHasTime;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  final Value<TaskPriority> priority;
  final Value<String?> tagId;
  final Value<String?> voiceNotePath;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDateTimeLocal = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.dueDateHasTime = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.priority = const Value.absent(),
    this.tagId = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.dueDateTimeLocal = const Value.absent(),
    this.timezoneId = const Value.absent(),
    this.dueDateHasTime = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.priority = const Value.absent(),
    this.tagId = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDateTimeLocal,
    Expression<String>? timezoneId,
    Expression<bool>? dueDateHasTime,
    Expression<bool>? isRecurring,
    Expression<String>? recurrenceRule,
    Expression<int>? priority,
    Expression<String>? tagId,
    Expression<String>? voiceNotePath,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDateTimeLocal != null) 'due_date_time_local': dueDateTimeLocal,
      if (timezoneId != null) 'timezone_id': timezoneId,
      if (dueDateHasTime != null) 'due_date_has_time': dueDateHasTime,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (priority != null) 'priority': priority,
      if (tagId != null) 'tag_id': tagId,
      if (voiceNotePath != null) 'voice_note_path': voiceNotePath,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueDateTimeLocal,
    Value<String?>? timezoneId,
    Value<bool>? dueDateHasTime,
    Value<bool>? isRecurring,
    Value<String?>? recurrenceRule,
    Value<TaskPriority>? priority,
    Value<String?>? tagId,
    Value<String?>? voiceNotePath,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTimeLocal: dueDateTimeLocal ?? this.dueDateTimeLocal,
      timezoneId: timezoneId ?? this.timezoneId,
      dueDateHasTime: dueDateHasTime ?? this.dueDateHasTime,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      priority: priority ?? this.priority,
      tagId: tagId ?? this.tagId,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDateTimeLocal.present) {
      map['due_date_time_local'] = Variable<DateTime>(dueDateTimeLocal.value);
    }
    if (timezoneId.present) {
      map['timezone_id'] = Variable<String>(timezoneId.value);
    }
    if (dueDateHasTime.present) {
      map['due_date_has_time'] = Variable<bool>(dueDateHasTime.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(
        $TasksTable.$converterpriority.toSql(priority.value),
      );
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (voiceNotePath.present) {
      map['voice_note_path'] = Variable<String>(voiceNotePath.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDateTimeLocal: $dueDateTimeLocal, ')
          ..write('timezoneId: $timezoneId, ')
          ..write('dueDateHasTime: $dueDateHasTime, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('priority: $priority, ')
          ..write('tagId: $tagId, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconRefMeta = const VerificationMeta(
    'iconRef',
  );
  @override
  late final GeneratedColumn<String> iconRef = GeneratedColumn<String>(
    'icon_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, iconRef, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_ref')) {
      context.handle(
        _iconRefMeta,
        iconRef.isAcceptableOrUnknown(data['icon_ref']!, _iconRefMeta),
      );
    } else if (isInserting) {
      context.missing(_iconRefMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {name},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_ref'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final String iconRef;
  final DateTime createdAt;
  const Tag({
    required this.id,
    required this.name,
    required this.iconRef,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_ref'] = Variable<String>(iconRef);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      iconRef: Value(iconRef),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconRef: serializer.fromJson<String>(json['iconRef']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconRef': serializer.toJson<String>(iconRef),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    String? iconRef,
    DateTime? createdAt,
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    iconRef: iconRef ?? this.iconRef,
    createdAt: createdAt ?? this.createdAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconRef: data.iconRef.present ? data.iconRef.value : this.iconRef,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconRef: $iconRef, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, iconRef, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconRef == this.iconRef &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconRef;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconRef = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    required String iconRef,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       iconRef = Value(iconRef),
       createdAt = Value(createdAt);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconRef,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconRef != null) 'icon_ref': iconRef,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? iconRef,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconRef: iconRef ?? this.iconRef,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconRef.present) {
      map['icon_ref'] = Variable<String>(iconRef.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconRef: $iconRef, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubtasksTable extends Subtasks with TableInfo<$SubtasksTable, Subtask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    title,
    isCompleted,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subtask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subtask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subtask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SubtasksTable createAlias(String alias) {
    return $SubtasksTable(attachedDatabase, alias);
  }
}

class Subtask extends DataClass implements Insertable<Subtask> {
  final String id;
  final String taskId;
  final String title;
  final bool isCompleted;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Subtask({
    required this.id,
    required this.taskId,
    required this.title,
    required this.isCompleted,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubtasksCompanion toCompanion(bool nullToAbsent) {
    return SubtasksCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      isCompleted: Value(isCompleted),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Subtask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subtask(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Subtask copyWith({
    String? id,
    String? taskId,
    String? title,
    bool? isCompleted,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Subtask(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    isCompleted: isCompleted ?? this.isCompleted,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Subtask copyWithCompanion(SubtasksCompanion data) {
    return Subtask(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subtask(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    title,
    isCompleted,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subtask &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubtasksCompanion extends UpdateCompanion<Subtask> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubtasksCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubtasksCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.isCompleted = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Subtask> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubtasksCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? title,
    Value<bool>? isCompleted,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SubtasksCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtasksCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _triggerTimeUtcMeta = const VerificationMeta(
    'triggerTimeUtc',
  );
  @override
  late final GeneratedColumn<DateTime> triggerTimeUtc =
      GeneratedColumn<DateTime>(
        'trigger_time_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isSnoozedMeta = const VerificationMeta(
    'isSnoozed',
  );
  @override
  late final GeneratedColumn<bool> isSnoozed = GeneratedColumn<bool>(
    'is_snoozed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_snoozed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _snoozeUntilUtcMeta = const VerificationMeta(
    'snoozeUntilUtc',
  );
  @override
  late final GeneratedColumn<DateTime> snoozeUntilUtc =
      GeneratedColumn<DateTime>(
        'snooze_until_utc',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    triggerTimeUtc,
    isSnoozed,
    snoozeUntilUtc,
    notificationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('trigger_time_utc')) {
      context.handle(
        _triggerTimeUtcMeta,
        triggerTimeUtc.isAcceptableOrUnknown(
          data['trigger_time_utc']!,
          _triggerTimeUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggerTimeUtcMeta);
    }
    if (data.containsKey('is_snoozed')) {
      context.handle(
        _isSnoozedMeta,
        isSnoozed.isAcceptableOrUnknown(data['is_snoozed']!, _isSnoozedMeta),
      );
    }
    if (data.containsKey('snooze_until_utc')) {
      context.handle(
        _snoozeUntilUtcMeta,
        snoozeUntilUtc.isAcceptableOrUnknown(
          data['snooze_until_utc']!,
          _snoozeUntilUtcMeta,
        ),
      );
    }
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      triggerTimeUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trigger_time_utc'],
      )!,
      isSnoozed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_snoozed'],
      )!,
      snoozeUntilUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}snooze_until_utc'],
      ),
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String taskId;
  final DateTime triggerTimeUtc;
  final bool isSnoozed;
  final DateTime? snoozeUntilUtc;
  final int notificationId;
  final DateTime createdAt;
  const Reminder({
    required this.id,
    required this.taskId,
    required this.triggerTimeUtc,
    required this.isSnoozed,
    this.snoozeUntilUtc,
    required this.notificationId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['trigger_time_utc'] = Variable<DateTime>(triggerTimeUtc);
    map['is_snoozed'] = Variable<bool>(isSnoozed);
    if (!nullToAbsent || snoozeUntilUtc != null) {
      map['snooze_until_utc'] = Variable<DateTime>(snoozeUntilUtc);
    }
    map['notification_id'] = Variable<int>(notificationId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      taskId: Value(taskId),
      triggerTimeUtc: Value(triggerTimeUtc),
      isSnoozed: Value(isSnoozed),
      snoozeUntilUtc: snoozeUntilUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozeUntilUtc),
      notificationId: Value(notificationId),
      createdAt: Value(createdAt),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      triggerTimeUtc: serializer.fromJson<DateTime>(json['triggerTimeUtc']),
      isSnoozed: serializer.fromJson<bool>(json['isSnoozed']),
      snoozeUntilUtc: serializer.fromJson<DateTime?>(json['snoozeUntilUtc']),
      notificationId: serializer.fromJson<int>(json['notificationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'triggerTimeUtc': serializer.toJson<DateTime>(triggerTimeUtc),
      'isSnoozed': serializer.toJson<bool>(isSnoozed),
      'snoozeUntilUtc': serializer.toJson<DateTime?>(snoozeUntilUtc),
      'notificationId': serializer.toJson<int>(notificationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Reminder copyWith({
    String? id,
    String? taskId,
    DateTime? triggerTimeUtc,
    bool? isSnoozed,
    Value<DateTime?> snoozeUntilUtc = const Value.absent(),
    int? notificationId,
    DateTime? createdAt,
  }) => Reminder(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    triggerTimeUtc: triggerTimeUtc ?? this.triggerTimeUtc,
    isSnoozed: isSnoozed ?? this.isSnoozed,
    snoozeUntilUtc: snoozeUntilUtc.present
        ? snoozeUntilUtc.value
        : this.snoozeUntilUtc,
    notificationId: notificationId ?? this.notificationId,
    createdAt: createdAt ?? this.createdAt,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      triggerTimeUtc: data.triggerTimeUtc.present
          ? data.triggerTimeUtc.value
          : this.triggerTimeUtc,
      isSnoozed: data.isSnoozed.present ? data.isSnoozed.value : this.isSnoozed,
      snoozeUntilUtc: data.snoozeUntilUtc.present
          ? data.snoozeUntilUtc.value
          : this.snoozeUntilUtc,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('triggerTimeUtc: $triggerTimeUtc, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozeUntilUtc: $snoozeUntilUtc, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    triggerTimeUtc,
    isSnoozed,
    snoozeUntilUtc,
    notificationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.triggerTimeUtc == this.triggerTimeUtc &&
          other.isSnoozed == this.isSnoozed &&
          other.snoozeUntilUtc == this.snoozeUntilUtc &&
          other.notificationId == this.notificationId &&
          other.createdAt == this.createdAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<DateTime> triggerTimeUtc;
  final Value<bool> isSnoozed;
  final Value<DateTime?> snoozeUntilUtc;
  final Value<int> notificationId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.triggerTimeUtc = const Value.absent(),
    this.isSnoozed = const Value.absent(),
    this.snoozeUntilUtc = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String taskId,
    required DateTime triggerTimeUtc,
    this.isSnoozed = const Value.absent(),
    this.snoozeUntilUtc = const Value.absent(),
    required int notificationId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       triggerTimeUtc = Value(triggerTimeUtc),
       notificationId = Value(notificationId),
       createdAt = Value(createdAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<DateTime>? triggerTimeUtc,
    Expression<bool>? isSnoozed,
    Expression<DateTime>? snoozeUntilUtc,
    Expression<int>? notificationId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (triggerTimeUtc != null) 'trigger_time_utc': triggerTimeUtc,
      if (isSnoozed != null) 'is_snoozed': isSnoozed,
      if (snoozeUntilUtc != null) 'snooze_until_utc': snoozeUntilUtc,
      if (notificationId != null) 'notification_id': notificationId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<DateTime>? triggerTimeUtc,
    Value<bool>? isSnoozed,
    Value<DateTime?>? snoozeUntilUtc,
    Value<int>? notificationId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      triggerTimeUtc: triggerTimeUtc ?? this.triggerTimeUtc,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozeUntilUtc: snoozeUntilUtc ?? this.snoozeUntilUtc,
      notificationId: notificationId ?? this.notificationId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (triggerTimeUtc.present) {
      map['trigger_time_utc'] = Variable<DateTime>(triggerTimeUtc.value);
    }
    if (isSnoozed.present) {
      map['is_snoozed'] = Variable<bool>(isSnoozed.value);
    }
    if (snoozeUntilUtc.present) {
      map['snooze_until_utc'] = Variable<DateTime>(snoozeUntilUtc.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('triggerTimeUtc: $triggerTimeUtc, ')
          ..write('isSnoozed: $isSnoozed, ')
          ..write('snoozeUntilUtc: $snoozeUntilUtc, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppThemeMode>($AppSettingsTableTable.$converterthemeMode);
  static const VerificationMeta _accentColorIdMeta = const VerificationMeta(
    'accentColorId',
  );
  @override
  late final GeneratedColumn<String> accentColorId = GeneratedColumn<String>(
    'accent_color_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('electricBlue'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SwipeDirection, int>
  swipeDirection =
      GeneratedColumn<int>(
        'swipe_direction',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<SwipeDirection>(
        $AppSettingsTableTable.$converterswipeDirection,
      );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _soundEnabledMeta = const VerificationMeta(
    'soundEnabled',
  );
  @override
  late final GeneratedColumn<bool> soundEnabled = GeneratedColumn<bool>(
    'sound_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _urgentReminderSoundMeta =
      const VerificationMeta('urgentReminderSound');
  @override
  late final GeneratedColumn<bool> urgentReminderSound = GeneratedColumn<bool>(
    'urgent_reminder_sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("urgent_reminder_sound" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TaskSortOption, int> defaultSort =
      GeneratedColumn<int>(
        'default_sort',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskSortOption>(
        $AppSettingsTableTable.$converterdefaultSort,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TaskGroupingOption, int>
  defaultGrouping =
      GeneratedColumn<int>(
        'default_grouping',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskGroupingOption>(
        $AppSettingsTableTable.$converterdefaultGrouping,
      );
  @override
  late final GeneratedColumnWithTypeConverter<WeekStartDay, int> weekStartDay =
      GeneratedColumn<int>(
        'week_start_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<WeekStartDay>(
        $AppSettingsTableTable.$converterweekStartDay,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TaskPriority, int>
  defaultPriority =
      GeneratedColumn<int>(
        'default_priority',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TaskPriority>(
        $AppSettingsTableTable.$converterdefaultPriority,
      );
  static const VerificationMeta _defaultReminderLeadMinutesMeta =
      const VerificationMeta('defaultReminderLeadMinutes');
  @override
  late final GeneratedColumn<int> defaultReminderLeadMinutes =
      GeneratedColumn<int>(
        'default_reminder_lead_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _snoozeOptionsMinutesJsonMeta =
      const VerificationMeta('snoozeOptionsMinutesJson');
  @override
  late final GeneratedColumn<String> snoozeOptionsMinutesJson =
      GeneratedColumn<String>(
        'snooze_options_minutes_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[15,60,1440]'),
      );
  static const VerificationMeta _widgetTaskCountMeta = const VerificationMeta(
    'widgetTaskCount',
  );
  @override
  late final GeneratedColumn<int> widgetTaskCount = GeneratedColumn<int>(
    'widget_task_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  @override
  late final GeneratedColumnWithTypeConverter<WidgetFilterMode, int>
  widgetFilterMode =
      GeneratedColumn<int>(
        'widget_filter_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      ).withConverter<WidgetFilterMode>(
        $AppSettingsTableTable.$converterwidgetFilterMode,
      );
  @override
  late final GeneratedColumnWithTypeConverter<WidgetTapAction, int>
  widgetTapAction =
      GeneratedColumn<int>(
        'widget_tap_action',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<WidgetTapAction>(
        $AppSettingsTableTable.$converterwidgetTapAction,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    accentColorId,
    swipeDirection,
    hapticsEnabled,
    soundEnabled,
    urgentReminderSound,
    reduceMotion,
    defaultSort,
    defaultGrouping,
    weekStartDay,
    defaultPriority,
    defaultReminderLeadMinutes,
    snoozeOptionsMinutesJson,
    widgetTaskCount,
    widgetFilterMode,
    widgetTapAction,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accent_color_id')) {
      context.handle(
        _accentColorIdMeta,
        accentColorId.isAcceptableOrUnknown(
          data['accent_color_id']!,
          _accentColorIdMeta,
        ),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('sound_enabled')) {
      context.handle(
        _soundEnabledMeta,
        soundEnabled.isAcceptableOrUnknown(
          data['sound_enabled']!,
          _soundEnabledMeta,
        ),
      );
    }
    if (data.containsKey('urgent_reminder_sound')) {
      context.handle(
        _urgentReminderSoundMeta,
        urgentReminderSound.isAcceptableOrUnknown(
          data['urgent_reminder_sound']!,
          _urgentReminderSoundMeta,
        ),
      );
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    if (data.containsKey('default_reminder_lead_minutes')) {
      context.handle(
        _defaultReminderLeadMinutesMeta,
        defaultReminderLeadMinutes.isAcceptableOrUnknown(
          data['default_reminder_lead_minutes']!,
          _defaultReminderLeadMinutesMeta,
        ),
      );
    }
    if (data.containsKey('snooze_options_minutes_json')) {
      context.handle(
        _snoozeOptionsMinutesJsonMeta,
        snoozeOptionsMinutesJson.isAcceptableOrUnknown(
          data['snooze_options_minutes_json']!,
          _snoozeOptionsMinutesJsonMeta,
        ),
      );
    }
    if (data.containsKey('widget_task_count')) {
      context.handle(
        _widgetTaskCountMeta,
        widgetTaskCount.isAcceptableOrUnknown(
          data['widget_task_count']!,
          _widgetTaskCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $AppSettingsTableTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      accentColorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color_id'],
      )!,
      swipeDirection: $AppSettingsTableTable.$converterswipeDirection.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}swipe_direction'],
        )!,
      ),
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
      soundEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound_enabled'],
      )!,
      urgentReminderSound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}urgent_reminder_sound'],
      )!,
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      defaultSort: $AppSettingsTableTable.$converterdefaultSort.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}default_sort'],
        )!,
      ),
      defaultGrouping: $AppSettingsTableTable.$converterdefaultGrouping.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}default_grouping'],
        )!,
      ),
      weekStartDay: $AppSettingsTableTable.$converterweekStartDay.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}week_start_day'],
        )!,
      ),
      defaultPriority: $AppSettingsTableTable.$converterdefaultPriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}default_priority'],
        )!,
      ),
      defaultReminderLeadMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_reminder_lead_minutes'],
      )!,
      snoozeOptionsMinutesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snooze_options_minutes_json'],
      )!,
      widgetTaskCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}widget_task_count'],
      )!,
      widgetFilterMode: $AppSettingsTableTable.$converterwidgetFilterMode
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}widget_filter_mode'],
            )!,
          ),
      widgetTapAction: $AppSettingsTableTable.$converterwidgetTapAction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}widget_tap_action'],
        )!,
      ),
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<AppThemeMode>(AppThemeMode.values);
  static JsonTypeConverter2<SwipeDirection, int, int> $converterswipeDirection =
      const EnumIndexConverter<SwipeDirection>(SwipeDirection.values);
  static JsonTypeConverter2<TaskSortOption, int, int> $converterdefaultSort =
      const EnumIndexConverter<TaskSortOption>(TaskSortOption.values);
  static JsonTypeConverter2<TaskGroupingOption, int, int>
  $converterdefaultGrouping = const EnumIndexConverter<TaskGroupingOption>(
    TaskGroupingOption.values,
  );
  static JsonTypeConverter2<WeekStartDay, int, int> $converterweekStartDay =
      const EnumIndexConverter<WeekStartDay>(WeekStartDay.values);
  static JsonTypeConverter2<TaskPriority, int, int> $converterdefaultPriority =
      const EnumIndexConverter<TaskPriority>(TaskPriority.values);
  static JsonTypeConverter2<WidgetFilterMode, int, int>
  $converterwidgetFilterMode = const EnumIndexConverter<WidgetFilterMode>(
    WidgetFilterMode.values,
  );
  static JsonTypeConverter2<WidgetTapAction, int, int>
  $converterwidgetTapAction = const EnumIndexConverter<WidgetTapAction>(
    WidgetTapAction.values,
  );
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final AppThemeMode themeMode;
  final String accentColorId;
  final SwipeDirection swipeDirection;
  final bool hapticsEnabled;
  final bool soundEnabled;
  final bool urgentReminderSound;
  final bool reduceMotion;
  final TaskSortOption defaultSort;
  final TaskGroupingOption defaultGrouping;
  final WeekStartDay weekStartDay;
  final TaskPriority defaultPriority;
  final int defaultReminderLeadMinutes;
  final String snoozeOptionsMinutesJson;
  final int widgetTaskCount;
  final WidgetFilterMode widgetFilterMode;
  final WidgetTapAction widgetTapAction;
  const AppSettingsTableData({
    required this.id,
    required this.themeMode,
    required this.accentColorId,
    required this.swipeDirection,
    required this.hapticsEnabled,
    required this.soundEnabled,
    required this.urgentReminderSound,
    required this.reduceMotion,
    required this.defaultSort,
    required this.defaultGrouping,
    required this.weekStartDay,
    required this.defaultPriority,
    required this.defaultReminderLeadMinutes,
    required this.snoozeOptionsMinutesJson,
    required this.widgetTaskCount,
    required this.widgetFilterMode,
    required this.widgetTapAction,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterthemeMode.toSql(themeMode),
      );
    }
    map['accent_color_id'] = Variable<String>(accentColorId);
    {
      map['swipe_direction'] = Variable<int>(
        $AppSettingsTableTable.$converterswipeDirection.toSql(swipeDirection),
      );
    }
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['sound_enabled'] = Variable<bool>(soundEnabled);
    map['urgent_reminder_sound'] = Variable<bool>(urgentReminderSound);
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    {
      map['default_sort'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultSort.toSql(defaultSort),
      );
    }
    {
      map['default_grouping'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultGrouping.toSql(defaultGrouping),
      );
    }
    {
      map['week_start_day'] = Variable<int>(
        $AppSettingsTableTable.$converterweekStartDay.toSql(weekStartDay),
      );
    }
    {
      map['default_priority'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultPriority.toSql(defaultPriority),
      );
    }
    map['default_reminder_lead_minutes'] = Variable<int>(
      defaultReminderLeadMinutes,
    );
    map['snooze_options_minutes_json'] = Variable<String>(
      snoozeOptionsMinutesJson,
    );
    map['widget_task_count'] = Variable<int>(widgetTaskCount);
    {
      map['widget_filter_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterwidgetFilterMode.toSql(
          widgetFilterMode,
        ),
      );
    }
    {
      map['widget_tap_action'] = Variable<int>(
        $AppSettingsTableTable.$converterwidgetTapAction.toSql(widgetTapAction),
      );
    }
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      accentColorId: Value(accentColorId),
      swipeDirection: Value(swipeDirection),
      hapticsEnabled: Value(hapticsEnabled),
      soundEnabled: Value(soundEnabled),
      urgentReminderSound: Value(urgentReminderSound),
      reduceMotion: Value(reduceMotion),
      defaultSort: Value(defaultSort),
      defaultGrouping: Value(defaultGrouping),
      weekStartDay: Value(weekStartDay),
      defaultPriority: Value(defaultPriority),
      defaultReminderLeadMinutes: Value(defaultReminderLeadMinutes),
      snoozeOptionsMinutesJson: Value(snoozeOptionsMinutesJson),
      widgetTaskCount: Value(widgetTaskCount),
      widgetFilterMode: Value(widgetFilterMode),
      widgetTapAction: Value(widgetTapAction),
    );
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $AppSettingsTableTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
      accentColorId: serializer.fromJson<String>(json['accentColorId']),
      swipeDirection: $AppSettingsTableTable.$converterswipeDirection.fromJson(
        serializer.fromJson<int>(json['swipeDirection']),
      ),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      soundEnabled: serializer.fromJson<bool>(json['soundEnabled']),
      urgentReminderSound: serializer.fromJson<bool>(
        json['urgentReminderSound'],
      ),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      defaultSort: $AppSettingsTableTable.$converterdefaultSort.fromJson(
        serializer.fromJson<int>(json['defaultSort']),
      ),
      defaultGrouping: $AppSettingsTableTable.$converterdefaultGrouping
          .fromJson(serializer.fromJson<int>(json['defaultGrouping'])),
      weekStartDay: $AppSettingsTableTable.$converterweekStartDay.fromJson(
        serializer.fromJson<int>(json['weekStartDay']),
      ),
      defaultPriority: $AppSettingsTableTable.$converterdefaultPriority
          .fromJson(serializer.fromJson<int>(json['defaultPriority'])),
      defaultReminderLeadMinutes: serializer.fromJson<int>(
        json['defaultReminderLeadMinutes'],
      ),
      snoozeOptionsMinutesJson: serializer.fromJson<String>(
        json['snoozeOptionsMinutesJson'],
      ),
      widgetTaskCount: serializer.fromJson<int>(json['widgetTaskCount']),
      widgetFilterMode: $AppSettingsTableTable.$converterwidgetFilterMode
          .fromJson(serializer.fromJson<int>(json['widgetFilterMode'])),
      widgetTapAction: $AppSettingsTableTable.$converterwidgetTapAction
          .fromJson(serializer.fromJson<int>(json['widgetTapAction'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<int>(
        $AppSettingsTableTable.$converterthemeMode.toJson(themeMode),
      ),
      'accentColorId': serializer.toJson<String>(accentColorId),
      'swipeDirection': serializer.toJson<int>(
        $AppSettingsTableTable.$converterswipeDirection.toJson(swipeDirection),
      ),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'soundEnabled': serializer.toJson<bool>(soundEnabled),
      'urgentReminderSound': serializer.toJson<bool>(urgentReminderSound),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'defaultSort': serializer.toJson<int>(
        $AppSettingsTableTable.$converterdefaultSort.toJson(defaultSort),
      ),
      'defaultGrouping': serializer.toJson<int>(
        $AppSettingsTableTable.$converterdefaultGrouping.toJson(
          defaultGrouping,
        ),
      ),
      'weekStartDay': serializer.toJson<int>(
        $AppSettingsTableTable.$converterweekStartDay.toJson(weekStartDay),
      ),
      'defaultPriority': serializer.toJson<int>(
        $AppSettingsTableTable.$converterdefaultPriority.toJson(
          defaultPriority,
        ),
      ),
      'defaultReminderLeadMinutes': serializer.toJson<int>(
        defaultReminderLeadMinutes,
      ),
      'snoozeOptionsMinutesJson': serializer.toJson<String>(
        snoozeOptionsMinutesJson,
      ),
      'widgetTaskCount': serializer.toJson<int>(widgetTaskCount),
      'widgetFilterMode': serializer.toJson<int>(
        $AppSettingsTableTable.$converterwidgetFilterMode.toJson(
          widgetFilterMode,
        ),
      ),
      'widgetTapAction': serializer.toJson<int>(
        $AppSettingsTableTable.$converterwidgetTapAction.toJson(
          widgetTapAction,
        ),
      ),
    };
  }

  AppSettingsTableData copyWith({
    int? id,
    AppThemeMode? themeMode,
    String? accentColorId,
    SwipeDirection? swipeDirection,
    bool? hapticsEnabled,
    bool? soundEnabled,
    bool? urgentReminderSound,
    bool? reduceMotion,
    TaskSortOption? defaultSort,
    TaskGroupingOption? defaultGrouping,
    WeekStartDay? weekStartDay,
    TaskPriority? defaultPriority,
    int? defaultReminderLeadMinutes,
    String? snoozeOptionsMinutesJson,
    int? widgetTaskCount,
    WidgetFilterMode? widgetFilterMode,
    WidgetTapAction? widgetTapAction,
  }) => AppSettingsTableData(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    accentColorId: accentColorId ?? this.accentColorId,
    swipeDirection: swipeDirection ?? this.swipeDirection,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    urgentReminderSound: urgentReminderSound ?? this.urgentReminderSound,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    defaultSort: defaultSort ?? this.defaultSort,
    defaultGrouping: defaultGrouping ?? this.defaultGrouping,
    weekStartDay: weekStartDay ?? this.weekStartDay,
    defaultPriority: defaultPriority ?? this.defaultPriority,
    defaultReminderLeadMinutes:
        defaultReminderLeadMinutes ?? this.defaultReminderLeadMinutes,
    snoozeOptionsMinutesJson:
        snoozeOptionsMinutesJson ?? this.snoozeOptionsMinutesJson,
    widgetTaskCount: widgetTaskCount ?? this.widgetTaskCount,
    widgetFilterMode: widgetFilterMode ?? this.widgetFilterMode,
    widgetTapAction: widgetTapAction ?? this.widgetTapAction,
  );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentColorId: data.accentColorId.present
          ? data.accentColorId.value
          : this.accentColorId,
      swipeDirection: data.swipeDirection.present
          ? data.swipeDirection.value
          : this.swipeDirection,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      soundEnabled: data.soundEnabled.present
          ? data.soundEnabled.value
          : this.soundEnabled,
      urgentReminderSound: data.urgentReminderSound.present
          ? data.urgentReminderSound.value
          : this.urgentReminderSound,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      defaultSort: data.defaultSort.present
          ? data.defaultSort.value
          : this.defaultSort,
      defaultGrouping: data.defaultGrouping.present
          ? data.defaultGrouping.value
          : this.defaultGrouping,
      weekStartDay: data.weekStartDay.present
          ? data.weekStartDay.value
          : this.weekStartDay,
      defaultPriority: data.defaultPriority.present
          ? data.defaultPriority.value
          : this.defaultPriority,
      defaultReminderLeadMinutes: data.defaultReminderLeadMinutes.present
          ? data.defaultReminderLeadMinutes.value
          : this.defaultReminderLeadMinutes,
      snoozeOptionsMinutesJson: data.snoozeOptionsMinutesJson.present
          ? data.snoozeOptionsMinutesJson.value
          : this.snoozeOptionsMinutesJson,
      widgetTaskCount: data.widgetTaskCount.present
          ? data.widgetTaskCount.value
          : this.widgetTaskCount,
      widgetFilterMode: data.widgetFilterMode.present
          ? data.widgetFilterMode.value
          : this.widgetFilterMode,
      widgetTapAction: data.widgetTapAction.present
          ? data.widgetTapAction.value
          : this.widgetTapAction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColorId: $accentColorId, ')
          ..write('swipeDirection: $swipeDirection, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('urgentReminderSound: $urgentReminderSound, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('defaultSort: $defaultSort, ')
          ..write('defaultGrouping: $defaultGrouping, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('defaultPriority: $defaultPriority, ')
          ..write('defaultReminderLeadMinutes: $defaultReminderLeadMinutes, ')
          ..write('snoozeOptionsMinutesJson: $snoozeOptionsMinutesJson, ')
          ..write('widgetTaskCount: $widgetTaskCount, ')
          ..write('widgetFilterMode: $widgetFilterMode, ')
          ..write('widgetTapAction: $widgetTapAction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    accentColorId,
    swipeDirection,
    hapticsEnabled,
    soundEnabled,
    urgentReminderSound,
    reduceMotion,
    defaultSort,
    defaultGrouping,
    weekStartDay,
    defaultPriority,
    defaultReminderLeadMinutes,
    snoozeOptionsMinutesJson,
    widgetTaskCount,
    widgetFilterMode,
    widgetTapAction,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.accentColorId == this.accentColorId &&
          other.swipeDirection == this.swipeDirection &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.soundEnabled == this.soundEnabled &&
          other.urgentReminderSound == this.urgentReminderSound &&
          other.reduceMotion == this.reduceMotion &&
          other.defaultSort == this.defaultSort &&
          other.defaultGrouping == this.defaultGrouping &&
          other.weekStartDay == this.weekStartDay &&
          other.defaultPriority == this.defaultPriority &&
          other.defaultReminderLeadMinutes == this.defaultReminderLeadMinutes &&
          other.snoozeOptionsMinutesJson == this.snoozeOptionsMinutesJson &&
          other.widgetTaskCount == this.widgetTaskCount &&
          other.widgetFilterMode == this.widgetFilterMode &&
          other.widgetTapAction == this.widgetTapAction);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<AppThemeMode> themeMode;
  final Value<String> accentColorId;
  final Value<SwipeDirection> swipeDirection;
  final Value<bool> hapticsEnabled;
  final Value<bool> soundEnabled;
  final Value<bool> urgentReminderSound;
  final Value<bool> reduceMotion;
  final Value<TaskSortOption> defaultSort;
  final Value<TaskGroupingOption> defaultGrouping;
  final Value<WeekStartDay> weekStartDay;
  final Value<TaskPriority> defaultPriority;
  final Value<int> defaultReminderLeadMinutes;
  final Value<String> snoozeOptionsMinutesJson;
  final Value<int> widgetTaskCount;
  final Value<WidgetFilterMode> widgetFilterMode;
  final Value<WidgetTapAction> widgetTapAction;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColorId = const Value.absent(),
    this.swipeDirection = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.urgentReminderSound = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.defaultSort = const Value.absent(),
    this.defaultGrouping = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.defaultPriority = const Value.absent(),
    this.defaultReminderLeadMinutes = const Value.absent(),
    this.snoozeOptionsMinutesJson = const Value.absent(),
    this.widgetTaskCount = const Value.absent(),
    this.widgetFilterMode = const Value.absent(),
    this.widgetTapAction = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColorId = const Value.absent(),
    this.swipeDirection = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.soundEnabled = const Value.absent(),
    this.urgentReminderSound = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.defaultSort = const Value.absent(),
    this.defaultGrouping = const Value.absent(),
    this.weekStartDay = const Value.absent(),
    this.defaultPriority = const Value.absent(),
    this.defaultReminderLeadMinutes = const Value.absent(),
    this.snoozeOptionsMinutesJson = const Value.absent(),
    this.widgetTaskCount = const Value.absent(),
    this.widgetFilterMode = const Value.absent(),
    this.widgetTapAction = const Value.absent(),
  });
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<String>? accentColorId,
    Expression<int>? swipeDirection,
    Expression<bool>? hapticsEnabled,
    Expression<bool>? soundEnabled,
    Expression<bool>? urgentReminderSound,
    Expression<bool>? reduceMotion,
    Expression<int>? defaultSort,
    Expression<int>? defaultGrouping,
    Expression<int>? weekStartDay,
    Expression<int>? defaultPriority,
    Expression<int>? defaultReminderLeadMinutes,
    Expression<String>? snoozeOptionsMinutesJson,
    Expression<int>? widgetTaskCount,
    Expression<int>? widgetFilterMode,
    Expression<int>? widgetTapAction,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentColorId != null) 'accent_color_id': accentColorId,
      if (swipeDirection != null) 'swipe_direction': swipeDirection,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (soundEnabled != null) 'sound_enabled': soundEnabled,
      if (urgentReminderSound != null)
        'urgent_reminder_sound': urgentReminderSound,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (defaultSort != null) 'default_sort': defaultSort,
      if (defaultGrouping != null) 'default_grouping': defaultGrouping,
      if (weekStartDay != null) 'week_start_day': weekStartDay,
      if (defaultPriority != null) 'default_priority': defaultPriority,
      if (defaultReminderLeadMinutes != null)
        'default_reminder_lead_minutes': defaultReminderLeadMinutes,
      if (snoozeOptionsMinutesJson != null)
        'snooze_options_minutes_json': snoozeOptionsMinutesJson,
      if (widgetTaskCount != null) 'widget_task_count': widgetTaskCount,
      if (widgetFilterMode != null) 'widget_filter_mode': widgetFilterMode,
      if (widgetTapAction != null) 'widget_tap_action': widgetTapAction,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<AppThemeMode>? themeMode,
    Value<String>? accentColorId,
    Value<SwipeDirection>? swipeDirection,
    Value<bool>? hapticsEnabled,
    Value<bool>? soundEnabled,
    Value<bool>? urgentReminderSound,
    Value<bool>? reduceMotion,
    Value<TaskSortOption>? defaultSort,
    Value<TaskGroupingOption>? defaultGrouping,
    Value<WeekStartDay>? weekStartDay,
    Value<TaskPriority>? defaultPriority,
    Value<int>? defaultReminderLeadMinutes,
    Value<String>? snoozeOptionsMinutesJson,
    Value<int>? widgetTaskCount,
    Value<WidgetFilterMode>? widgetFilterMode,
    Value<WidgetTapAction>? widgetTapAction,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      accentColorId: accentColorId ?? this.accentColorId,
      swipeDirection: swipeDirection ?? this.swipeDirection,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      urgentReminderSound: urgentReminderSound ?? this.urgentReminderSound,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      defaultSort: defaultSort ?? this.defaultSort,
      defaultGrouping: defaultGrouping ?? this.defaultGrouping,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      defaultReminderLeadMinutes:
          defaultReminderLeadMinutes ?? this.defaultReminderLeadMinutes,
      snoozeOptionsMinutesJson:
          snoozeOptionsMinutesJson ?? this.snoozeOptionsMinutesJson,
      widgetTaskCount: widgetTaskCount ?? this.widgetTaskCount,
      widgetFilterMode: widgetFilterMode ?? this.widgetFilterMode,
      widgetTapAction: widgetTapAction ?? this.widgetTapAction,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (accentColorId.present) {
      map['accent_color_id'] = Variable<String>(accentColorId.value);
    }
    if (swipeDirection.present) {
      map['swipe_direction'] = Variable<int>(
        $AppSettingsTableTable.$converterswipeDirection.toSql(
          swipeDirection.value,
        ),
      );
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (soundEnabled.present) {
      map['sound_enabled'] = Variable<bool>(soundEnabled.value);
    }
    if (urgentReminderSound.present) {
      map['urgent_reminder_sound'] = Variable<bool>(urgentReminderSound.value);
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (defaultSort.present) {
      map['default_sort'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultSort.toSql(defaultSort.value),
      );
    }
    if (defaultGrouping.present) {
      map['default_grouping'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultGrouping.toSql(
          defaultGrouping.value,
        ),
      );
    }
    if (weekStartDay.present) {
      map['week_start_day'] = Variable<int>(
        $AppSettingsTableTable.$converterweekStartDay.toSql(weekStartDay.value),
      );
    }
    if (defaultPriority.present) {
      map['default_priority'] = Variable<int>(
        $AppSettingsTableTable.$converterdefaultPriority.toSql(
          defaultPriority.value,
        ),
      );
    }
    if (defaultReminderLeadMinutes.present) {
      map['default_reminder_lead_minutes'] = Variable<int>(
        defaultReminderLeadMinutes.value,
      );
    }
    if (snoozeOptionsMinutesJson.present) {
      map['snooze_options_minutes_json'] = Variable<String>(
        snoozeOptionsMinutesJson.value,
      );
    }
    if (widgetTaskCount.present) {
      map['widget_task_count'] = Variable<int>(widgetTaskCount.value);
    }
    if (widgetFilterMode.present) {
      map['widget_filter_mode'] = Variable<int>(
        $AppSettingsTableTable.$converterwidgetFilterMode.toSql(
          widgetFilterMode.value,
        ),
      );
    }
    if (widgetTapAction.present) {
      map['widget_tap_action'] = Variable<int>(
        $AppSettingsTableTable.$converterwidgetTapAction.toSql(
          widgetTapAction.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColorId: $accentColorId, ')
          ..write('swipeDirection: $swipeDirection, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('soundEnabled: $soundEnabled, ')
          ..write('urgentReminderSound: $urgentReminderSound, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('defaultSort: $defaultSort, ')
          ..write('defaultGrouping: $defaultGrouping, ')
          ..write('weekStartDay: $weekStartDay, ')
          ..write('defaultPriority: $defaultPriority, ')
          ..write('defaultReminderLeadMinutes: $defaultReminderLeadMinutes, ')
          ..write('snoozeOptionsMinutesJson: $snoozeOptionsMinutesJson, ')
          ..write('widgetTaskCount: $widgetTaskCount, ')
          ..write('widgetFilterMode: $widgetFilterMode, ')
          ..write('widgetTapAction: $widgetTapAction')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $SubtasksTable subtasks = $SubtasksTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final TaskDao taskDao = TaskDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final SubtaskDao subtaskDao = SubtaskDao(this as AppDatabase);
  late final ReminderDao reminderDao = ReminderDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final BackupDao backupDao = BackupDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasks,
    tags,
    subtasks,
    reminders,
    appSettingsTable,
  ];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<DateTime?> dueDateTimeLocal,
      Value<String?> timezoneId,
      Value<bool> dueDateHasTime,
      Value<bool> isRecurring,
      Value<String?> recurrenceRule,
      Value<TaskPriority> priority,
      Value<String?> tagId,
      Value<String?> voiceNotePath,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime?> dueDateTimeLocal,
      Value<String?> timezoneId,
      Value<bool> dueDateHasTime,
      Value<bool> isRecurring,
      Value<String?> recurrenceRule,
      Value<TaskPriority> priority,
      Value<String?> tagId,
      Value<String?> voiceNotePath,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDateTimeLocal => $composableBuilder(
    column: $table.dueDateTimeLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dueDateHasTime => $composableBuilder(
    column: $table.dueDateHasTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskPriority, TaskPriority, int>
  get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDateTimeLocal => $composableBuilder(
    column: $table.dueDateTimeLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dueDateHasTime => $composableBuilder(
    column: $table.dueDateHasTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDateTimeLocal => $composableBuilder(
    column: $table.dueDateTimeLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezoneId => $composableBuilder(
    column: $table.timezoneId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dueDateHasTime => $composableBuilder(
    column: $table.dueDateHasTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskPriority, int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDateTimeLocal = const Value.absent(),
                Value<String?> timezoneId = const Value.absent(),
                Value<bool> dueDateHasTime = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<TaskPriority> priority = const Value.absent(),
                Value<String?> tagId = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                dueDateTimeLocal: dueDateTimeLocal,
                timezoneId: timezoneId,
                dueDateHasTime: dueDateHasTime,
                isRecurring: isRecurring,
                recurrenceRule: recurrenceRule,
                priority: priority,
                tagId: tagId,
                voiceNotePath: voiceNotePath,
                isCompleted: isCompleted,
                completedAt: completedAt,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDateTimeLocal = const Value.absent(),
                Value<String?> timezoneId = const Value.absent(),
                Value<bool> dueDateHasTime = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<TaskPriority> priority = const Value.absent(),
                Value<String?> tagId = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDateTimeLocal: dueDateTimeLocal,
                timezoneId: timezoneId,
                dueDateHasTime: dueDateHasTime,
                isRecurring: isRecurring,
                recurrenceRule: recurrenceRule,
                priority: priority,
                tagId: tagId,
                voiceNotePath: voiceNotePath,
                isCompleted: isCompleted,
                completedAt: completedAt,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      required String iconRef,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> iconRef,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconRef => $composableBuilder(
    column: $table.iconRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconRef => $composableBuilder(
    column: $table.iconRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconRef =>
      $composableBuilder(column: $table.iconRef, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconRef = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                iconRef: iconRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String iconRef,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                iconRef: iconRef,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$SubtasksTableCreateCompanionBuilder =
    SubtasksCompanion Function({
      required String id,
      required String taskId,
      required String title,
      Value<bool> isCompleted,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SubtasksTableUpdateCompanionBuilder =
    SubtasksCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> title,
      Value<bool> isCompleted,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SubtasksTableFilterComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubtasksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubtasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtasksTable> {
  $$SubtasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubtasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubtasksTable,
          Subtask,
          $$SubtasksTableFilterComposer,
          $$SubtasksTableOrderingComposer,
          $$SubtasksTableAnnotationComposer,
          $$SubtasksTableCreateCompanionBuilder,
          $$SubtasksTableUpdateCompanionBuilder,
          (Subtask, BaseReferences<_$AppDatabase, $SubtasksTable, Subtask>),
          Subtask,
          PrefetchHooks Function()
        > {
  $$SubtasksTableTableManager(_$AppDatabase db, $SubtasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion(
                id: id,
                taskId: taskId,
                title: title,
                isCompleted: isCompleted,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String title,
                Value<bool> isCompleted = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SubtasksCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                isCompleted: isCompleted,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubtasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubtasksTable,
      Subtask,
      $$SubtasksTableFilterComposer,
      $$SubtasksTableOrderingComposer,
      $$SubtasksTableAnnotationComposer,
      $$SubtasksTableCreateCompanionBuilder,
      $$SubtasksTableUpdateCompanionBuilder,
      (Subtask, BaseReferences<_$AppDatabase, $SubtasksTable, Subtask>),
      Subtask,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      required String id,
      required String taskId,
      required DateTime triggerTimeUtc,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozeUntilUtc,
      required int notificationId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<DateTime> triggerTimeUtc,
      Value<bool> isSnoozed,
      Value<DateTime?> snoozeUntilUtc,
      Value<int> notificationId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get triggerTimeUtc => $composableBuilder(
    column: $table.triggerTimeUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get snoozeUntilUtc => $composableBuilder(
    column: $table.snoozeUntilUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get triggerTimeUtc => $composableBuilder(
    column: $table.triggerTimeUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSnoozed => $composableBuilder(
    column: $table.isSnoozed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get snoozeUntilUtc => $composableBuilder(
    column: $table.snoozeUntilUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<DateTime> get triggerTimeUtc => $composableBuilder(
    column: $table.triggerTimeUtc,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSnoozed =>
      $composableBuilder(column: $table.isSnoozed, builder: (column) => column);

  GeneratedColumn<DateTime> get snoozeUntilUtc => $composableBuilder(
    column: $table.snoozeUntilUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<DateTime> triggerTimeUtc = const Value.absent(),
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozeUntilUtc = const Value.absent(),
                Value<int> notificationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                taskId: taskId,
                triggerTimeUtc: triggerTimeUtc,
                isSnoozed: isSnoozed,
                snoozeUntilUtc: snoozeUntilUtc,
                notificationId: notificationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required DateTime triggerTimeUtc,
                Value<bool> isSnoozed = const Value.absent(),
                Value<DateTime?> snoozeUntilUtc = const Value.absent(),
                required int notificationId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                taskId: taskId,
                triggerTimeUtc: triggerTimeUtc,
                isSnoozed: isSnoozed,
                snoozeUntilUtc: snoozeUntilUtc,
                notificationId: notificationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<AppThemeMode> themeMode,
      Value<String> accentColorId,
      Value<SwipeDirection> swipeDirection,
      Value<bool> hapticsEnabled,
      Value<bool> soundEnabled,
      Value<bool> urgentReminderSound,
      Value<bool> reduceMotion,
      Value<TaskSortOption> defaultSort,
      Value<TaskGroupingOption> defaultGrouping,
      Value<WeekStartDay> weekStartDay,
      Value<TaskPriority> defaultPriority,
      Value<int> defaultReminderLeadMinutes,
      Value<String> snoozeOptionsMinutesJson,
      Value<int> widgetTaskCount,
      Value<WidgetFilterMode> widgetFilterMode,
      Value<WidgetTapAction> widgetTapAction,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<AppThemeMode> themeMode,
      Value<String> accentColorId,
      Value<SwipeDirection> swipeDirection,
      Value<bool> hapticsEnabled,
      Value<bool> soundEnabled,
      Value<bool> urgentReminderSound,
      Value<bool> reduceMotion,
      Value<TaskSortOption> defaultSort,
      Value<TaskGroupingOption> defaultGrouping,
      Value<WeekStartDay> weekStartDay,
      Value<TaskPriority> defaultPriority,
      Value<int> defaultReminderLeadMinutes,
      Value<String> snoozeOptionsMinutesJson,
      Value<int> widgetTaskCount,
      Value<WidgetFilterMode> widgetFilterMode,
      Value<WidgetTapAction> widgetTapAction,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, int>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get accentColorId => $composableBuilder(
    column: $table.accentColorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SwipeDirection, SwipeDirection, int>
  get swipeDirection => $composableBuilder(
    column: $table.swipeDirection,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get urgentReminderSound => $composableBuilder(
    column: $table.urgentReminderSound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskSortOption, TaskSortOption, int>
  get defaultSort => $composableBuilder(
    column: $table.defaultSort,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskGroupingOption, TaskGroupingOption, int>
  get defaultGrouping => $composableBuilder(
    column: $table.defaultGrouping,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<WeekStartDay, WeekStartDay, int>
  get weekStartDay => $composableBuilder(
    column: $table.weekStartDay,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TaskPriority, TaskPriority, int>
  get defaultPriority => $composableBuilder(
    column: $table.defaultPriority,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get defaultReminderLeadMinutes => $composableBuilder(
    column: $table.defaultReminderLeadMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snoozeOptionsMinutesJson => $composableBuilder(
    column: $table.snoozeOptionsMinutesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widgetTaskCount => $composableBuilder(
    column: $table.widgetTaskCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WidgetFilterMode, WidgetFilterMode, int>
  get widgetFilterMode => $composableBuilder(
    column: $table.widgetFilterMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<WidgetTapAction, WidgetTapAction, int>
  get widgetTapAction => $composableBuilder(
    column: $table.widgetTapAction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentColorId => $composableBuilder(
    column: $table.accentColorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get swipeDirection => $composableBuilder(
    column: $table.swipeDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get urgentReminderSound => $composableBuilder(
    column: $table.urgentReminderSound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultSort => $composableBuilder(
    column: $table.defaultSort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultGrouping => $composableBuilder(
    column: $table.defaultGrouping,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStartDay => $composableBuilder(
    column: $table.weekStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultPriority => $composableBuilder(
    column: $table.defaultPriority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultReminderLeadMinutes => $composableBuilder(
    column: $table.defaultReminderLeadMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snoozeOptionsMinutesJson => $composableBuilder(
    column: $table.snoozeOptionsMinutesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widgetTaskCount => $composableBuilder(
    column: $table.widgetTaskCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widgetFilterMode => $composableBuilder(
    column: $table.widgetFilterMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widgetTapAction => $composableBuilder(
    column: $table.widgetTapAction,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get accentColorId => $composableBuilder(
    column: $table.accentColorId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SwipeDirection, int> get swipeDirection =>
      $composableBuilder(
        column: $table.swipeDirection,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get soundEnabled => $composableBuilder(
    column: $table.soundEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get urgentReminderSound => $composableBuilder(
    column: $table.urgentReminderSound,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TaskSortOption, int> get defaultSort =>
      $composableBuilder(
        column: $table.defaultSort,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TaskGroupingOption, int>
  get defaultGrouping => $composableBuilder(
    column: $table.defaultGrouping,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeekStartDay, int> get weekStartDay =>
      $composableBuilder(
        column: $table.weekStartDay,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TaskPriority, int> get defaultPriority =>
      $composableBuilder(
        column: $table.defaultPriority,
        builder: (column) => column,
      );

  GeneratedColumn<int> get defaultReminderLeadMinutes => $composableBuilder(
    column: $table.defaultReminderLeadMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get snoozeOptionsMinutesJson => $composableBuilder(
    column: $table.snoozeOptionsMinutesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get widgetTaskCount => $composableBuilder(
    column: $table.widgetTaskCount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WidgetFilterMode, int>
  get widgetFilterMode => $composableBuilder(
    column: $table.widgetFilterMode,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WidgetTapAction, int> get widgetTapAction =>
      $composableBuilder(
        column: $table.widgetTapAction,
        builder: (column) => column,
      );
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<String> accentColorId = const Value.absent(),
                Value<SwipeDirection> swipeDirection = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> urgentReminderSound = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<TaskSortOption> defaultSort = const Value.absent(),
                Value<TaskGroupingOption> defaultGrouping =
                    const Value.absent(),
                Value<WeekStartDay> weekStartDay = const Value.absent(),
                Value<TaskPriority> defaultPriority = const Value.absent(),
                Value<int> defaultReminderLeadMinutes = const Value.absent(),
                Value<String> snoozeOptionsMinutesJson = const Value.absent(),
                Value<int> widgetTaskCount = const Value.absent(),
                Value<WidgetFilterMode> widgetFilterMode = const Value.absent(),
                Value<WidgetTapAction> widgetTapAction = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                themeMode: themeMode,
                accentColorId: accentColorId,
                swipeDirection: swipeDirection,
                hapticsEnabled: hapticsEnabled,
                soundEnabled: soundEnabled,
                urgentReminderSound: urgentReminderSound,
                reduceMotion: reduceMotion,
                defaultSort: defaultSort,
                defaultGrouping: defaultGrouping,
                weekStartDay: weekStartDay,
                defaultPriority: defaultPriority,
                defaultReminderLeadMinutes: defaultReminderLeadMinutes,
                snoozeOptionsMinutesJson: snoozeOptionsMinutesJson,
                widgetTaskCount: widgetTaskCount,
                widgetFilterMode: widgetFilterMode,
                widgetTapAction: widgetTapAction,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<String> accentColorId = const Value.absent(),
                Value<SwipeDirection> swipeDirection = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<bool> soundEnabled = const Value.absent(),
                Value<bool> urgentReminderSound = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<TaskSortOption> defaultSort = const Value.absent(),
                Value<TaskGroupingOption> defaultGrouping =
                    const Value.absent(),
                Value<WeekStartDay> weekStartDay = const Value.absent(),
                Value<TaskPriority> defaultPriority = const Value.absent(),
                Value<int> defaultReminderLeadMinutes = const Value.absent(),
                Value<String> snoozeOptionsMinutesJson = const Value.absent(),
                Value<int> widgetTaskCount = const Value.absent(),
                Value<WidgetFilterMode> widgetFilterMode = const Value.absent(),
                Value<WidgetTapAction> widgetTapAction = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                id: id,
                themeMode: themeMode,
                accentColorId: accentColorId,
                swipeDirection: swipeDirection,
                hapticsEnabled: hapticsEnabled,
                soundEnabled: soundEnabled,
                urgentReminderSound: urgentReminderSound,
                reduceMotion: reduceMotion,
                defaultSort: defaultSort,
                defaultGrouping: defaultGrouping,
                weekStartDay: weekStartDay,
                defaultPriority: defaultPriority,
                defaultReminderLeadMinutes: defaultReminderLeadMinutes,
                snoozeOptionsMinutesJson: snoozeOptionsMinutesJson,
                widgetTaskCount: widgetTaskCount,
                widgetFilterMode: widgetFilterMode,
                widgetTapAction: widgetTapAction,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$SubtasksTableTableManager get subtasks =>
      $$SubtasksTableTableManager(_db, _db.subtasks);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
