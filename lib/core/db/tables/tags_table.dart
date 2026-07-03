import 'package:drift/drift.dart';

/// Tags — user-defined categories. `iconRef` maps to a key in the custom
/// SVG icon set (lib/core/icons/app_icons.dart, built in Phase 4), not a
/// raw asset path, so icon-set changes never require a data migration.
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get iconRef => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};

  @override
  List<Set<Column>> get uniqueKeys => <Set<Column>>[
    <Column>{name},
  ];
}
