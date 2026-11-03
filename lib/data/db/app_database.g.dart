// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($ExercisesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($ExercisesTable.$converterupdatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> archivedAt =
      GeneratedColumn<int>(
        'archived_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ExercisesTable.$converterarchivedAtn);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedNameMeta = const VerificationMeta(
    'normalizedName',
  );
  @override
  late final GeneratedColumn<String> normalizedName = GeneratedColumn<String>(
    'normalized_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ExerciseLogType, String> logType =
      GeneratedColumn<String>(
        'log_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ExerciseLogType>($ExercisesTable.$converterlogType);
  @override
  late final GeneratedColumnWithTypeConverter<Muscle, String> primaryMuscle =
      GeneratedColumn<String>(
        'primary_muscle',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Muscle>($ExercisesTable.$converterprimaryMuscle);
  @override
  late final GeneratedColumnWithTypeConverter<Equipment?, String> equipment =
      GeneratedColumn<String>(
        'equipment',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Equipment?>($ExercisesTable.$converterequipmentn);
  static const VerificationMeta _incrementValueMeta = const VerificationMeta(
    'incrementValue',
  );
  @override
  late final GeneratedColumn<double> incrementValue = GeneratedColumn<double>(
    'increment_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeightUnit?, String>
  incrementUnit = GeneratedColumn<String>(
    'increment_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<WeightUnit?>($ExercisesTable.$converterincrementUnitn);
  static const VerificationMeta _incrementGramsMeta = const VerificationMeta(
    'incrementGrams',
  );
  @override
  late final GeneratedColumn<int> incrementGrams = GeneratedColumn<int>(
    'increment_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultRestSecondsMeta =
      const VerificationMeta('defaultRestSeconds');
  @override
  late final GeneratedColumn<int> defaultRestSeconds = GeneratedColumn<int>(
    'default_rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    archivedAt,
    name,
    normalizedName,
    logType,
    primaryMuscle,
    equipment,
    incrementValue,
    incrementUnit,
    incrementGrams,
    defaultRestSeconds,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized_name')) {
      context.handle(
        _normalizedNameMeta,
        normalizedName.isAcceptableOrUnknown(
          data['normalized_name']!,
          _normalizedNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_normalizedNameMeta);
    }
    if (data.containsKey('increment_value')) {
      context.handle(
        _incrementValueMeta,
        incrementValue.isAcceptableOrUnknown(
          data['increment_value']!,
          _incrementValueMeta,
        ),
      );
    }
    if (data.containsKey('increment_grams')) {
      context.handle(
        _incrementGramsMeta,
        incrementGrams.isAcceptableOrUnknown(
          data['increment_grams']!,
          _incrementGramsMeta,
        ),
      );
    }
    if (data.containsKey('default_rest_seconds')) {
      context.handle(
        _defaultRestSecondsMeta,
        defaultRestSeconds.isAcceptableOrUnknown(
          data['default_rest_seconds']!,
          _defaultRestSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $ExercisesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $ExercisesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      archivedAt: $ExercisesTable.$converterarchivedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}archived_at'],
        ),
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalizedName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_name'],
      )!,
      logType: $ExercisesTable.$converterlogType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}log_type'],
        )!,
      ),
      primaryMuscle: $ExercisesTable.$converterprimaryMuscle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}primary_muscle'],
        )!,
      ),
      equipment: $ExercisesTable.$converterequipmentn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        ),
      ),
      incrementValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}increment_value'],
      ),
      incrementUnit: $ExercisesTable.$converterincrementUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}increment_unit'],
        ),
      ),
      incrementGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}increment_grams'],
      ),
      defaultRestSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_rest_seconds'],
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterarchivedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterarchivedAtn =
      NullAwareTypeConverter.wrap($converterarchivedAt);
  static JsonTypeConverter2<ExerciseLogType, String, String> $converterlogType =
      const EnumNameConverter<ExerciseLogType>(ExerciseLogType.values);
  static JsonTypeConverter2<Muscle, String, String> $converterprimaryMuscle =
      const EnumNameConverter<Muscle>(Muscle.values);
  static JsonTypeConverter2<Equipment, String, String> $converterequipment =
      const EnumNameConverter<Equipment>(Equipment.values);
  static JsonTypeConverter2<Equipment?, String?, String?> $converterequipmentn =
      JsonTypeConverter2.asNullable($converterequipment);
  static JsonTypeConverter2<WeightUnit, String, String>
  $converterincrementUnit = const EnumNameConverter<WeightUnit>(
    WeightUnit.values,
  );
  static JsonTypeConverter2<WeightUnit?, String?, String?>
  $converterincrementUnitn = JsonTypeConverter2.asNullable(
    $converterincrementUnit,
  );
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String name;

  /// Nombre en minúsculas, sin tildes ni espacios repetidos: duplicados y
  /// búsqueda. Lo calcula `normalizeName`.
  final String normalizedName;
  final ExerciseLogType logType;
  final Muscle primaryMuscle;
  final Equipment? equipment;
  final double? incrementValue;
  final WeightUnit? incrementUnit;
  final int? incrementGrams;
  final int? defaultRestSeconds;
  final bool isCustom;
  const Exercise({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.name,
    required this.normalizedName,
    required this.logType,
    required this.primaryMuscle,
    this.equipment,
    this.incrementValue,
    this.incrementUnit,
    this.incrementGrams,
    this.defaultRestSeconds,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $ExercisesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $ExercisesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(
        $ExercisesTable.$converterarchivedAtn.toSql(archivedAt),
      );
    }
    map['name'] = Variable<String>(name);
    map['normalized_name'] = Variable<String>(normalizedName);
    {
      map['log_type'] = Variable<String>(
        $ExercisesTable.$converterlogType.toSql(logType),
      );
    }
    {
      map['primary_muscle'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle),
      );
    }
    if (!nullToAbsent || equipment != null) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipmentn.toSql(equipment),
      );
    }
    if (!nullToAbsent || incrementValue != null) {
      map['increment_value'] = Variable<double>(incrementValue);
    }
    if (!nullToAbsent || incrementUnit != null) {
      map['increment_unit'] = Variable<String>(
        $ExercisesTable.$converterincrementUnitn.toSql(incrementUnit),
      );
    }
    if (!nullToAbsent || incrementGrams != null) {
      map['increment_grams'] = Variable<int>(incrementGrams);
    }
    if (!nullToAbsent || defaultRestSeconds != null) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      name: Value(name),
      normalizedName: Value(normalizedName),
      logType: Value(logType),
      primaryMuscle: Value(primaryMuscle),
      equipment: equipment == null && nullToAbsent
          ? const Value.absent()
          : Value(equipment),
      incrementValue: incrementValue == null && nullToAbsent
          ? const Value.absent()
          : Value(incrementValue),
      incrementUnit: incrementUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(incrementUnit),
      incrementGrams: incrementGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(incrementGrams),
      defaultRestSeconds: defaultRestSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultRestSeconds),
      isCustom: Value(isCustom),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      name: serializer.fromJson<String>(json['name']),
      normalizedName: serializer.fromJson<String>(json['normalizedName']),
      logType: $ExercisesTable.$converterlogType.fromJson(
        serializer.fromJson<String>(json['logType']),
      ),
      primaryMuscle: $ExercisesTable.$converterprimaryMuscle.fromJson(
        serializer.fromJson<String>(json['primaryMuscle']),
      ),
      equipment: $ExercisesTable.$converterequipmentn.fromJson(
        serializer.fromJson<String?>(json['equipment']),
      ),
      incrementValue: serializer.fromJson<double?>(json['incrementValue']),
      incrementUnit: $ExercisesTable.$converterincrementUnitn.fromJson(
        serializer.fromJson<String?>(json['incrementUnit']),
      ),
      incrementGrams: serializer.fromJson<int?>(json['incrementGrams']),
      defaultRestSeconds: serializer.fromJson<int?>(json['defaultRestSeconds']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'name': serializer.toJson<String>(name),
      'normalizedName': serializer.toJson<String>(normalizedName),
      'logType': serializer.toJson<String>(
        $ExercisesTable.$converterlogType.toJson(logType),
      ),
      'primaryMuscle': serializer.toJson<String>(
        $ExercisesTable.$converterprimaryMuscle.toJson(primaryMuscle),
      ),
      'equipment': serializer.toJson<String?>(
        $ExercisesTable.$converterequipmentn.toJson(equipment),
      ),
      'incrementValue': serializer.toJson<double?>(incrementValue),
      'incrementUnit': serializer.toJson<String?>(
        $ExercisesTable.$converterincrementUnitn.toJson(incrementUnit),
      ),
      'incrementGrams': serializer.toJson<int?>(incrementGrams),
      'defaultRestSeconds': serializer.toJson<int?>(defaultRestSeconds),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Exercise copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? name,
    String? normalizedName,
    ExerciseLogType? logType,
    Muscle? primaryMuscle,
    Value<Equipment?> equipment = const Value.absent(),
    Value<double?> incrementValue = const Value.absent(),
    Value<WeightUnit?> incrementUnit = const Value.absent(),
    Value<int?> incrementGrams = const Value.absent(),
    Value<int?> defaultRestSeconds = const Value.absent(),
    bool? isCustom,
  }) => Exercise(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    name: name ?? this.name,
    normalizedName: normalizedName ?? this.normalizedName,
    logType: logType ?? this.logType,
    primaryMuscle: primaryMuscle ?? this.primaryMuscle,
    equipment: equipment.present ? equipment.value : this.equipment,
    incrementValue: incrementValue.present
        ? incrementValue.value
        : this.incrementValue,
    incrementUnit: incrementUnit.present
        ? incrementUnit.value
        : this.incrementUnit,
    incrementGrams: incrementGrams.present
        ? incrementGrams.value
        : this.incrementGrams,
    defaultRestSeconds: defaultRestSeconds.present
        ? defaultRestSeconds.value
        : this.defaultRestSeconds,
    isCustom: isCustom ?? this.isCustom,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      name: data.name.present ? data.name.value : this.name,
      normalizedName: data.normalizedName.present
          ? data.normalizedName.value
          : this.normalizedName,
      logType: data.logType.present ? data.logType.value : this.logType,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      incrementValue: data.incrementValue.present
          ? data.incrementValue.value
          : this.incrementValue,
      incrementUnit: data.incrementUnit.present
          ? data.incrementUnit.value
          : this.incrementUnit,
      incrementGrams: data.incrementGrams.present
          ? data.incrementGrams.value
          : this.incrementGrams,
      defaultRestSeconds: data.defaultRestSeconds.present
          ? data.defaultRestSeconds.value
          : this.defaultRestSeconds,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('logType: $logType, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('equipment: $equipment, ')
          ..write('incrementValue: $incrementValue, ')
          ..write('incrementUnit: $incrementUnit, ')
          ..write('incrementGrams: $incrementGrams, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    archivedAt,
    name,
    normalizedName,
    logType,
    primaryMuscle,
    equipment,
    incrementValue,
    incrementUnit,
    incrementGrams,
    defaultRestSeconds,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.name == this.name &&
          other.normalizedName == this.normalizedName &&
          other.logType == this.logType &&
          other.primaryMuscle == this.primaryMuscle &&
          other.equipment == this.equipment &&
          other.incrementValue == this.incrementValue &&
          other.incrementUnit == this.incrementUnit &&
          other.incrementGrams == this.incrementGrams &&
          other.defaultRestSeconds == this.defaultRestSeconds &&
          other.isCustom == this.isCustom);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> name;
  final Value<String> normalizedName;
  final Value<ExerciseLogType> logType;
  final Value<Muscle> primaryMuscle;
  final Value<Equipment?> equipment;
  final Value<double?> incrementValue;
  final Value<WeightUnit?> incrementUnit;
  final Value<int?> incrementGrams;
  final Value<int?> defaultRestSeconds;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.normalizedName = const Value.absent(),
    this.logType = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.equipment = const Value.absent(),
    this.incrementValue = const Value.absent(),
    this.incrementUnit = const Value.absent(),
    this.incrementGrams = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String name,
    required String normalizedName,
    required ExerciseLogType logType,
    required Muscle primaryMuscle,
    this.equipment = const Value.absent(),
    this.incrementValue = const Value.absent(),
    this.incrementUnit = const Value.absent(),
    this.incrementGrams = const Value.absent(),
    this.defaultRestSeconds = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       normalizedName = Value(normalizedName),
       logType = Value(logType),
       primaryMuscle = Value(primaryMuscle);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<String>? name,
    Expression<String>? normalizedName,
    Expression<String>? logType,
    Expression<String>? primaryMuscle,
    Expression<String>? equipment,
    Expression<double>? incrementValue,
    Expression<String>? incrementUnit,
    Expression<int>? incrementGrams,
    Expression<int>? defaultRestSeconds,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (name != null) 'name': name,
      if (normalizedName != null) 'normalized_name': normalizedName,
      if (logType != null) 'log_type': logType,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (equipment != null) 'equipment': equipment,
      if (incrementValue != null) 'increment_value': incrementValue,
      if (incrementUnit != null) 'increment_unit': incrementUnit,
      if (incrementGrams != null) 'increment_grams': incrementGrams,
      if (defaultRestSeconds != null)
        'default_rest_seconds': defaultRestSeconds,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? name,
    Value<String>? normalizedName,
    Value<ExerciseLogType>? logType,
    Value<Muscle>? primaryMuscle,
    Value<Equipment?>? equipment,
    Value<double?>? incrementValue,
    Value<WeightUnit?>? incrementUnit,
    Value<int?>? incrementGrams,
    Value<int?>? defaultRestSeconds,
    Value<bool>? isCustom,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      name: name ?? this.name,
      normalizedName: normalizedName ?? this.normalizedName,
      logType: logType ?? this.logType,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      equipment: equipment ?? this.equipment,
      incrementValue: incrementValue ?? this.incrementValue,
      incrementUnit: incrementUnit ?? this.incrementUnit,
      incrementGrams: incrementGrams ?? this.incrementGrams,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $ExercisesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $ExercisesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(
        $ExercisesTable.$converterarchivedAtn.toSql(archivedAt.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalizedName.present) {
      map['normalized_name'] = Variable<String>(normalizedName.value);
    }
    if (logType.present) {
      map['log_type'] = Variable<String>(
        $ExercisesTable.$converterlogType.toSql(logType.value),
      );
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<String>(
        $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle.value),
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipmentn.toSql(equipment.value),
      );
    }
    if (incrementValue.present) {
      map['increment_value'] = Variable<double>(incrementValue.value);
    }
    if (incrementUnit.present) {
      map['increment_unit'] = Variable<String>(
        $ExercisesTable.$converterincrementUnitn.toSql(incrementUnit.value),
      );
    }
    if (incrementGrams.present) {
      map['increment_grams'] = Variable<int>(incrementGrams.value);
    }
    if (defaultRestSeconds.present) {
      map['default_rest_seconds'] = Variable<int>(defaultRestSeconds.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('normalizedName: $normalizedName, ')
          ..write('logType: $logType, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('equipment: $equipment, ')
          ..write('incrementValue: $incrementValue, ')
          ..write('incrementUnit: $incrementUnit, ')
          ..write('incrementGrams: $incrementGrams, ')
          ..write('defaultRestSeconds: $defaultRestSeconds, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StrengthRoutinesTable extends StrengthRoutines
    with TableInfo<$StrengthRoutinesTable, StrengthRoutine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StrengthRoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($StrengthRoutinesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($StrengthRoutinesTable.$converterupdatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> archivedAt =
      GeneratedColumn<int>(
        'archived_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($StrengthRoutinesTable.$converterarchivedAtn);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    archivedAt,
    name,
    notes,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'strength_routine';
  @override
  VerificationContext validateIntegrity(
    Insertable<StrengthRoutine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StrengthRoutine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StrengthRoutine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $StrengthRoutinesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $StrengthRoutinesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      archivedAt: $StrengthRoutinesTable.$converterarchivedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}archived_at'],
        ),
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $StrengthRoutinesTable createAlias(String alias) {
    return $StrengthRoutinesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterarchivedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterarchivedAtn =
      NullAwareTypeConverter.wrap($converterarchivedAt);
}

class StrengthRoutine extends DataClass implements Insertable<StrengthRoutine> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String name;
  final String? notes;
  final int sortOrder;
  const StrengthRoutine({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.name,
    this.notes,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $StrengthRoutinesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $StrengthRoutinesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(
        $StrengthRoutinesTable.$converterarchivedAtn.toSql(archivedAt),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  StrengthRoutinesCompanion toCompanion(bool nullToAbsent) {
    return StrengthRoutinesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
    );
  }

  factory StrengthRoutine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StrengthRoutine(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  StrengthRoutine copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? name,
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
  }) => StrengthRoutine(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  StrengthRoutine copyWithCompanion(StrengthRoutinesCompanion data) {
    return StrengthRoutine(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StrengthRoutine(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, archivedAt, name, notes, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StrengthRoutine &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder);
}

class StrengthRoutinesCompanion extends UpdateCompanion<StrengthRoutine> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> name;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const StrengthRoutinesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StrengthRoutinesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<StrengthRoutine> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StrengthRoutinesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? name,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return StrengthRoutinesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $StrengthRoutinesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $StrengthRoutinesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(
        $StrengthRoutinesTable.$converterarchivedAtn.toSql(archivedAt.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StrengthRoutinesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineExercisesTable extends RoutineExercises
    with TableInfo<$RoutineExercisesTable, RoutineExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RoutineExercisesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RoutineExercisesTable.$converterupdatedAt);
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES strength_routine (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise (id)',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    routineId,
    exerciseId,
    sortOrder,
    restSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_exercise';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $RoutineExercisesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RoutineExercisesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
    );
  }

  @override
  $RoutineExercisesTable createAlias(String alias) {
    return $RoutineExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class RoutineExercise extends DataClass implements Insertable<RoutineExercise> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String routineId;
  final String exerciseId;
  final int sortOrder;
  final int? restSeconds;
  const RoutineExercise({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.routineId,
    required this.exerciseId,
    required this.sortOrder,
    this.restSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $RoutineExercisesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RoutineExercisesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['routine_id'] = Variable<String>(routineId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    return map;
  }

  RoutineExercisesCompanion toCompanion(bool nullToAbsent) {
    return RoutineExercisesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      routineId: Value(routineId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
    );
  }

  factory RoutineExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineExercise(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      routineId: serializer.fromJson<String>(json['routineId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'routineId': serializer.toJson<String>(routineId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'restSeconds': serializer.toJson<int?>(restSeconds),
    };
  }

  RoutineExercise copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? routineId,
    String? exerciseId,
    int? sortOrder,
    Value<int?> restSeconds = const Value.absent(),
  }) => RoutineExercise(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    routineId: routineId ?? this.routineId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
  );
  RoutineExercise copyWithCompanion(RoutineExercisesCompanion data) {
    return RoutineExercise(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercise(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    routineId,
    exerciseId,
    sortOrder,
    restSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineExercise &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.routineId == this.routineId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.restSeconds == this.restSeconds);
}

class RoutineExercisesCompanion extends UpdateCompanion<RoutineExercise> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> routineId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int?> restSeconds;
  final Value<int> rowid;
  const RoutineExercisesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.routineId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String routineId,
    required String exerciseId,
    required int sortOrder,
    this.restSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<RoutineExercise> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? routineId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? restSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (routineId != null) 'routine_id': routineId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineExercisesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? routineId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int?>? restSeconds,
    Value<int>? rowid,
  }) {
    return RoutineExercisesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      restSeconds: restSeconds ?? this.restSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RoutineExercisesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RoutineExercisesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercisesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineSetTargetsTable extends RoutineSetTargets
    with TableInfo<$RoutineSetTargetsTable, RoutineSetTarget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineSetTargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RoutineSetTargetsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RoutineSetTargetsTable.$converterupdatedAt);
  static const VerificationMeta _routineExerciseIdMeta = const VerificationMeta(
    'routineExerciseId',
  );
  @override
  late final GeneratedColumn<String> routineExerciseId =
      GeneratedColumn<String>(
        'routine_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routine_exercise (id) ON DELETE CASCADE',
        ),
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
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SetType, String> setType =
      GeneratedColumn<String>(
        'set_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SetType.normal.name),
      ).withConverter<SetType>($RoutineSetTargetsTable.$convertersetType);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightValueMeta = const VerificationMeta(
    'weightValue',
  );
  @override
  late final GeneratedColumn<double> weightValue = GeneratedColumn<double>(
    'weight_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeightUnit?, String> weightUnit =
      GeneratedColumn<String>(
        'weight_unit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<WeightUnit?>(
        $RoutineSetTargetsTable.$converterweightUnitn,
      );
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    routineExerciseId,
    sortOrder,
    setType,
    reps,
    weightValue,
    weightUnit,
    weightGrams,
    rpe,
    durationSeconds,
    distanceMeters,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_set_target';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineSetTarget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_exercise_id')) {
      context.handle(
        _routineExerciseIdMeta,
        routineExerciseId.isAcceptableOrUnknown(
          data['routine_exercise_id']!,
          _routineExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineExerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('weight_value')) {
      context.handle(
        _weightValueMeta,
        weightValue.isAcceptableOrUnknown(
          data['weight_value']!,
          _weightValueMeta,
        ),
      );
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineSetTarget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineSetTarget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $RoutineSetTargetsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RoutineSetTargetsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      routineExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      setType: $RoutineSetTargetsTable.$convertersetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}set_type'],
        )!,
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      weightValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_value'],
      ),
      weightUnit: $RoutineSetTargetsTable.$converterweightUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weight_unit'],
        ),
      ),
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
    );
  }

  @override
  $RoutineSetTargetsTable createAlias(String alias) {
    return $RoutineSetTargetsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<SetType, String, String> $convertersetType =
      const EnumNameConverter<SetType>(SetType.values);
  static JsonTypeConverter2<WeightUnit, String, String> $converterweightUnit =
      const EnumNameConverter<WeightUnit>(WeightUnit.values);
  static JsonTypeConverter2<WeightUnit?, String?, String?>
  $converterweightUnitn = JsonTypeConverter2.asNullable($converterweightUnit);
}

class RoutineSetTarget extends DataClass
    implements Insertable<RoutineSetTarget> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String routineExerciseId;
  final int sortOrder;
  final SetType setType;
  final int? reps;
  final double? weightValue;
  final WeightUnit? weightUnit;
  final int? weightGrams;
  final double? rpe;
  final int? durationSeconds;
  final double? distanceMeters;
  const RoutineSetTarget({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.routineExerciseId,
    required this.sortOrder,
    required this.setType,
    this.reps,
    this.weightValue,
    this.weightUnit,
    this.weightGrams,
    this.rpe,
    this.durationSeconds,
    this.distanceMeters,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $RoutineSetTargetsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RoutineSetTargetsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['routine_exercise_id'] = Variable<String>(routineExerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['set_type'] = Variable<String>(
        $RoutineSetTargetsTable.$convertersetType.toSql(setType),
      );
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || weightValue != null) {
      map['weight_value'] = Variable<double>(weightValue);
    }
    if (!nullToAbsent || weightUnit != null) {
      map['weight_unit'] = Variable<String>(
        $RoutineSetTargetsTable.$converterweightUnitn.toSql(weightUnit),
      );
    }
    if (!nullToAbsent || weightGrams != null) {
      map['weight_grams'] = Variable<int>(weightGrams);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    return map;
  }

  RoutineSetTargetsCompanion toCompanion(bool nullToAbsent) {
    return RoutineSetTargetsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      routineExerciseId: Value(routineExerciseId),
      sortOrder: Value(sortOrder),
      setType: Value(setType),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weightValue: weightValue == null && nullToAbsent
          ? const Value.absent()
          : Value(weightValue),
      weightUnit: weightUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(weightUnit),
      weightGrams: weightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGrams),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
    );
  }

  factory RoutineSetTarget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineSetTarget(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      routineExerciseId: serializer.fromJson<String>(json['routineExerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      setType: $RoutineSetTargetsTable.$convertersetType.fromJson(
        serializer.fromJson<String>(json['setType']),
      ),
      reps: serializer.fromJson<int?>(json['reps']),
      weightValue: serializer.fromJson<double?>(json['weightValue']),
      weightUnit: $RoutineSetTargetsTable.$converterweightUnitn.fromJson(
        serializer.fromJson<String?>(json['weightUnit']),
      ),
      weightGrams: serializer.fromJson<int?>(json['weightGrams']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'routineExerciseId': serializer.toJson<String>(routineExerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'setType': serializer.toJson<String>(
        $RoutineSetTargetsTable.$convertersetType.toJson(setType),
      ),
      'reps': serializer.toJson<int?>(reps),
      'weightValue': serializer.toJson<double?>(weightValue),
      'weightUnit': serializer.toJson<String?>(
        $RoutineSetTargetsTable.$converterweightUnitn.toJson(weightUnit),
      ),
      'weightGrams': serializer.toJson<int?>(weightGrams),
      'rpe': serializer.toJson<double?>(rpe),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
    };
  }

  RoutineSetTarget copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? routineExerciseId,
    int? sortOrder,
    SetType? setType,
    Value<int?> reps = const Value.absent(),
    Value<double?> weightValue = const Value.absent(),
    Value<WeightUnit?> weightUnit = const Value.absent(),
    Value<int?> weightGrams = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
  }) => RoutineSetTarget(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    routineExerciseId: routineExerciseId ?? this.routineExerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    setType: setType ?? this.setType,
    reps: reps.present ? reps.value : this.reps,
    weightValue: weightValue.present ? weightValue.value : this.weightValue,
    weightUnit: weightUnit.present ? weightUnit.value : this.weightUnit,
    weightGrams: weightGrams.present ? weightGrams.value : this.weightGrams,
    rpe: rpe.present ? rpe.value : this.rpe,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
  );
  RoutineSetTarget copyWithCompanion(RoutineSetTargetsCompanion data) {
    return RoutineSetTarget(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      routineExerciseId: data.routineExerciseId.present
          ? data.routineExerciseId.value
          : this.routineExerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      setType: data.setType.present ? data.setType.value : this.setType,
      reps: data.reps.present ? data.reps.value : this.reps,
      weightValue: data.weightValue.present
          ? data.weightValue.value
          : this.weightValue,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineSetTarget(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('reps: $reps, ')
          ..write('weightValue: $weightValue, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('rpe: $rpe, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    routineExerciseId,
    sortOrder,
    setType,
    reps,
    weightValue,
    weightUnit,
    weightGrams,
    rpe,
    durationSeconds,
    distanceMeters,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineSetTarget &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.routineExerciseId == this.routineExerciseId &&
          other.sortOrder == this.sortOrder &&
          other.setType == this.setType &&
          other.reps == this.reps &&
          other.weightValue == this.weightValue &&
          other.weightUnit == this.weightUnit &&
          other.weightGrams == this.weightGrams &&
          other.rpe == this.rpe &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters);
}

class RoutineSetTargetsCompanion extends UpdateCompanion<RoutineSetTarget> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> routineExerciseId;
  final Value<int> sortOrder;
  final Value<SetType> setType;
  final Value<int?> reps;
  final Value<double?> weightValue;
  final Value<WeightUnit?> weightUnit;
  final Value<int?> weightGrams;
  final Value<double?> rpe;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<int> rowid;
  const RoutineSetTargetsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.routineExerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.setType = const Value.absent(),
    this.reps = const Value.absent(),
    this.weightValue = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.rpe = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineSetTargetsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String routineExerciseId,
    required int sortOrder,
    this.setType = const Value.absent(),
    this.reps = const Value.absent(),
    this.weightValue = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.rpe = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : routineExerciseId = Value(routineExerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<RoutineSetTarget> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? routineExerciseId,
    Expression<int>? sortOrder,
    Expression<String>? setType,
    Expression<int>? reps,
    Expression<double>? weightValue,
    Expression<String>? weightUnit,
    Expression<int>? weightGrams,
    Expression<double>? rpe,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (routineExerciseId != null) 'routine_exercise_id': routineExerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (setType != null) 'set_type': setType,
      if (reps != null) 'reps': reps,
      if (weightValue != null) 'weight_value': weightValue,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (rpe != null) 'rpe': rpe,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineSetTargetsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? routineExerciseId,
    Value<int>? sortOrder,
    Value<SetType>? setType,
    Value<int?>? reps,
    Value<double?>? weightValue,
    Value<WeightUnit?>? weightUnit,
    Value<int?>? weightGrams,
    Value<double?>? rpe,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<int>? rowid,
  }) {
    return RoutineSetTargetsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routineExerciseId: routineExerciseId ?? this.routineExerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      setType: setType ?? this.setType,
      reps: reps ?? this.reps,
      weightValue: weightValue ?? this.weightValue,
      weightUnit: weightUnit ?? this.weightUnit,
      weightGrams: weightGrams ?? this.weightGrams,
      rpe: rpe ?? this.rpe,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RoutineSetTargetsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RoutineSetTargetsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (routineExerciseId.present) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(
        $RoutineSetTargetsTable.$convertersetType.toSql(setType.value),
      );
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weightValue.present) {
      map['weight_value'] = Variable<double>(weightValue.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(
        $RoutineSetTargetsTable.$converterweightUnitn.toSql(weightUnit.value),
      );
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineSetTargetsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('reps: $reps, ')
          ..write('weightValue: $weightValue, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('rpe: $rpe, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntervalWorkoutsTable extends IntervalWorkouts
    with TableInfo<$IntervalWorkoutsTable, IntervalWorkout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntervalWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalWorkoutsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalWorkoutsTable.$converterupdatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> archivedAt =
      GeneratedColumn<int>(
        'archived_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($IntervalWorkoutsTable.$converterarchivedAtn);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prepareSecondsMeta = const VerificationMeta(
    'prepareSeconds',
  );
  @override
  late final GeneratedColumn<int> prepareSeconds = GeneratedColumn<int>(
    'prepare_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    archivedAt,
    name,
    prepareSeconds,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interval_workout';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntervalWorkout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('prepare_seconds')) {
      context.handle(
        _prepareSecondsMeta,
        prepareSeconds.isAcceptableOrUnknown(
          data['prepare_seconds']!,
          _prepareSecondsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntervalWorkout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntervalWorkout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $IntervalWorkoutsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $IntervalWorkoutsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      archivedAt: $IntervalWorkoutsTable.$converterarchivedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}archived_at'],
        ),
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      prepareSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prepare_seconds'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $IntervalWorkoutsTable createAlias(String alias) {
    return $IntervalWorkoutsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterarchivedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterarchivedAtn =
      NullAwareTypeConverter.wrap($converterarchivedAt);
}

class IntervalWorkout extends DataClass implements Insertable<IntervalWorkout> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String name;
  final int prepareSeconds;
  final String? notes;
  const IntervalWorkout({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.name,
    required this.prepareSeconds,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $IntervalWorkoutsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $IntervalWorkoutsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(
        $IntervalWorkoutsTable.$converterarchivedAtn.toSql(archivedAt),
      );
    }
    map['name'] = Variable<String>(name);
    map['prepare_seconds'] = Variable<int>(prepareSeconds);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  IntervalWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return IntervalWorkoutsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      name: Value(name),
      prepareSeconds: Value(prepareSeconds),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory IntervalWorkout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntervalWorkout(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      name: serializer.fromJson<String>(json['name']),
      prepareSeconds: serializer.fromJson<int>(json['prepareSeconds']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'name': serializer.toJson<String>(name),
      'prepareSeconds': serializer.toJson<int>(prepareSeconds),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  IntervalWorkout copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    String? name,
    int? prepareSeconds,
    Value<String?> notes = const Value.absent(),
  }) => IntervalWorkout(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    name: name ?? this.name,
    prepareSeconds: prepareSeconds ?? this.prepareSeconds,
    notes: notes.present ? notes.value : this.notes,
  );
  IntervalWorkout copyWithCompanion(IntervalWorkoutsCompanion data) {
    return IntervalWorkout(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      name: data.name.present ? data.name.value : this.name,
      prepareSeconds: data.prepareSeconds.present
          ? data.prepareSeconds.value
          : this.prepareSeconds,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntervalWorkout(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('prepareSeconds: $prepareSeconds, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    archivedAt,
    name,
    prepareSeconds,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntervalWorkout &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.name == this.name &&
          other.prepareSeconds == this.prepareSeconds &&
          other.notes == this.notes);
}

class IntervalWorkoutsCompanion extends UpdateCompanion<IntervalWorkout> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<String> name;
  final Value<int> prepareSeconds;
  final Value<String?> notes;
  final Value<int> rowid;
  const IntervalWorkoutsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.prepareSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntervalWorkoutsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required String name,
    this.prepareSeconds = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<IntervalWorkout> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<String>? name,
    Expression<int>? prepareSeconds,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (name != null) 'name': name,
      if (prepareSeconds != null) 'prepare_seconds': prepareSeconds,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntervalWorkoutsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<String>? name,
    Value<int>? prepareSeconds,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return IntervalWorkoutsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      name: name ?? this.name,
      prepareSeconds: prepareSeconds ?? this.prepareSeconds,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $IntervalWorkoutsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $IntervalWorkoutsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(
        $IntervalWorkoutsTable.$converterarchivedAtn.toSql(archivedAt.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (prepareSeconds.present) {
      map['prepare_seconds'] = Variable<int>(prepareSeconds.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('name: $name, ')
          ..write('prepareSeconds: $prepareSeconds, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntervalBlocksTable extends IntervalBlocks
    with TableInfo<$IntervalBlocksTable, IntervalBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntervalBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalBlocksTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalBlocksTable.$converterupdatedAt);
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interval_workout (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interval_block (id) ON DELETE CASCADE',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IntervalBlockKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<IntervalBlockKind>($IntervalBlocksTable.$converterkind);
  @override
  late final GeneratedColumnWithTypeConverter<PhaseType?, String> phaseType =
      GeneratedColumn<String>(
        'phase_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<PhaseType?>($IntervalBlocksTable.$converterphaseTypen);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roundsMeta = const VerificationMeta('rounds');
  @override
  late final GeneratedColumn<int> rounds = GeneratedColumn<int>(
    'rounds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    workoutId,
    parentId,
    sortOrder,
    kind,
    phaseType,
    label,
    durationSeconds,
    rounds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interval_block';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntervalBlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rounds')) {
      context.handle(
        _roundsMeta,
        rounds.isAcceptableOrUnknown(data['rounds']!, _roundsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntervalBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntervalBlock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $IntervalBlocksTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $IntervalBlocksTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      kind: $IntervalBlocksTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      phaseType: $IntervalBlocksTable.$converterphaseTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase_type'],
        ),
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      rounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds'],
      )!,
    );
  }

  @override
  $IntervalBlocksTable createAlias(String alias) {
    return $IntervalBlocksTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<IntervalBlockKind, String, String> $converterkind =
      const EnumNameConverter<IntervalBlockKind>(IntervalBlockKind.values);
  static JsonTypeConverter2<PhaseType, String, String> $converterphaseType =
      const EnumNameConverter<PhaseType>(PhaseType.values);
  static JsonTypeConverter2<PhaseType?, String?, String?> $converterphaseTypen =
      JsonTypeConverter2.asNullable($converterphaseType);
}

class IntervalBlock extends DataClass implements Insertable<IntervalBlock> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String workoutId;

  /// Grupo que contiene a este bloque; `null` en el primer nivel.
  final String? parentId;
  final int sortOrder;
  final IntervalBlockKind kind;

  /// Solo en intervalos (`kind = interval`).
  final PhaseType? phaseType;
  final String? label;
  final int? durationSeconds;

  /// Repeticiones de un grupo; 1 en intervalos.
  final int rounds;
  const IntervalBlock({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.workoutId,
    this.parentId,
    required this.sortOrder,
    required this.kind,
    this.phaseType,
    this.label,
    this.durationSeconds,
    required this.rounds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $IntervalBlocksTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $IntervalBlocksTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['workout_id'] = Variable<String>(workoutId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['kind'] = Variable<String>(
        $IntervalBlocksTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || phaseType != null) {
      map['phase_type'] = Variable<String>(
        $IntervalBlocksTable.$converterphaseTypen.toSql(phaseType),
      );
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['rounds'] = Variable<int>(rounds);
    return map;
  }

  IntervalBlocksCompanion toCompanion(bool nullToAbsent) {
    return IntervalBlocksCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      workoutId: Value(workoutId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      sortOrder: Value(sortOrder),
      kind: Value(kind),
      phaseType: phaseType == null && nullToAbsent
          ? const Value.absent()
          : Value(phaseType),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      rounds: Value(rounds),
    );
  }

  factory IntervalBlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntervalBlock(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      kind: $IntervalBlocksTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      phaseType: $IntervalBlocksTable.$converterphaseTypen.fromJson(
        serializer.fromJson<String?>(json['phaseType']),
      ),
      label: serializer.fromJson<String?>(json['label']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      rounds: serializer.fromJson<int>(json['rounds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'workoutId': serializer.toJson<String>(workoutId),
      'parentId': serializer.toJson<String?>(parentId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'kind': serializer.toJson<String>(
        $IntervalBlocksTable.$converterkind.toJson(kind),
      ),
      'phaseType': serializer.toJson<String?>(
        $IntervalBlocksTable.$converterphaseTypen.toJson(phaseType),
      ),
      'label': serializer.toJson<String?>(label),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'rounds': serializer.toJson<int>(rounds),
    };
  }

  IntervalBlock copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? workoutId,
    Value<String?> parentId = const Value.absent(),
    int? sortOrder,
    IntervalBlockKind? kind,
    Value<PhaseType?> phaseType = const Value.absent(),
    Value<String?> label = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    int? rounds,
  }) => IntervalBlock(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    workoutId: workoutId ?? this.workoutId,
    parentId: parentId.present ? parentId.value : this.parentId,
    sortOrder: sortOrder ?? this.sortOrder,
    kind: kind ?? this.kind,
    phaseType: phaseType.present ? phaseType.value : this.phaseType,
    label: label.present ? label.value : this.label,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    rounds: rounds ?? this.rounds,
  );
  IntervalBlock copyWithCompanion(IntervalBlocksCompanion data) {
    return IntervalBlock(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      kind: data.kind.present ? data.kind.value : this.kind,
      phaseType: data.phaseType.present ? data.phaseType.value : this.phaseType,
      label: data.label.present ? data.label.value : this.label,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      rounds: data.rounds.present ? data.rounds.value : this.rounds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntervalBlock(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('parentId: $parentId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('kind: $kind, ')
          ..write('phaseType: $phaseType, ')
          ..write('label: $label, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rounds: $rounds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    workoutId,
    parentId,
    sortOrder,
    kind,
    phaseType,
    label,
    durationSeconds,
    rounds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntervalBlock &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.workoutId == this.workoutId &&
          other.parentId == this.parentId &&
          other.sortOrder == this.sortOrder &&
          other.kind == this.kind &&
          other.phaseType == this.phaseType &&
          other.label == this.label &&
          other.durationSeconds == this.durationSeconds &&
          other.rounds == this.rounds);
}

class IntervalBlocksCompanion extends UpdateCompanion<IntervalBlock> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> workoutId;
  final Value<String?> parentId;
  final Value<int> sortOrder;
  final Value<IntervalBlockKind> kind;
  final Value<PhaseType?> phaseType;
  final Value<String?> label;
  final Value<int?> durationSeconds;
  final Value<int> rounds;
  final Value<int> rowid;
  const IntervalBlocksCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.kind = const Value.absent(),
    this.phaseType = const Value.absent(),
    this.label = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rounds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntervalBlocksCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String workoutId,
    this.parentId = const Value.absent(),
    required int sortOrder,
    required IntervalBlockKind kind,
    this.phaseType = const Value.absent(),
    this.label = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rounds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : workoutId = Value(workoutId),
       sortOrder = Value(sortOrder),
       kind = Value(kind);
  static Insertable<IntervalBlock> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? workoutId,
    Expression<String>? parentId,
    Expression<int>? sortOrder,
    Expression<String>? kind,
    Expression<String>? phaseType,
    Expression<String>? label,
    Expression<int>? durationSeconds,
    Expression<int>? rounds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (workoutId != null) 'workout_id': workoutId,
      if (parentId != null) 'parent_id': parentId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (kind != null) 'kind': kind,
      if (phaseType != null) 'phase_type': phaseType,
      if (label != null) 'label': label,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rounds != null) 'rounds': rounds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntervalBlocksCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? workoutId,
    Value<String?>? parentId,
    Value<int>? sortOrder,
    Value<IntervalBlockKind>? kind,
    Value<PhaseType?>? phaseType,
    Value<String?>? label,
    Value<int?>? durationSeconds,
    Value<int>? rounds,
    Value<int>? rowid,
  }) {
    return IntervalBlocksCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      workoutId: workoutId ?? this.workoutId,
      parentId: parentId ?? this.parentId,
      sortOrder: sortOrder ?? this.sortOrder,
      kind: kind ?? this.kind,
      phaseType: phaseType ?? this.phaseType,
      label: label ?? this.label,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rounds: rounds ?? this.rounds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $IntervalBlocksTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $IntervalBlocksTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $IntervalBlocksTable.$converterkind.toSql(kind.value),
      );
    }
    if (phaseType.present) {
      map['phase_type'] = Variable<String>(
        $IntervalBlocksTable.$converterphaseTypen.toSql(phaseType.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rounds.present) {
      map['rounds'] = Variable<int>(rounds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalBlocksCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('workoutId: $workoutId, ')
          ..write('parentId: $parentId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('kind: $kind, ')
          ..write('phaseType: $phaseType, ')
          ..write('label: $label, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rounds: $rounds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SessionsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SessionsTable.$converterupdatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> archivedAt =
      GeneratedColumn<int>(
        'archived_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SessionsTable.$converterarchivedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<SessionKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionKind>($SessionsTable.$converterkind);
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionStatus>($SessionsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> startedAt =
      GeneratedColumn<int>(
        'started_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($SessionsTable.$converterstartedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> endedAt =
      GeneratedColumn<int>(
        'ended_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SessionsTable.$converterendedAtn);
  static const VerificationMeta _timeZoneIdMeta = const VerificationMeta(
    'timeZoneId',
  );
  @override
  late final GeneratedColumn<String> timeZoneId = GeneratedColumn<String>(
    'time_zone_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _utcOffsetMinutesMeta = const VerificationMeta(
    'utcOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> utcOffsetMinutes = GeneratedColumn<int>(
    'utc_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pausedSecondsMeta = const VerificationMeta(
    'pausedSeconds',
  );
  @override
  late final GeneratedColumn<int> pausedSeconds = GeneratedColumn<int>(
    'paused_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  templateSnapshot =
      GeneratedColumn<String>(
        'template_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, Object?>?>(
        $SessionsTable.$convertertemplateSnapshotn,
      );
  static const VerificationMeta _perceivedEffortMeta = const VerificationMeta(
    'perceivedEffort',
  );
  @override
  late final GeneratedColumn<int> perceivedEffort = GeneratedColumn<int>(
    'perceived_effort',
    aliasedName,
    true,
    check: () => ComparableExpr(perceivedEffort).isBetweenValues(1, 10),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkpointPhaseIndexMeta =
      const VerificationMeta('checkpointPhaseIndex');
  @override
  late final GeneratedColumn<int> checkpointPhaseIndex = GeneratedColumn<int>(
    'checkpoint_phase_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkpointElapsedMsMeta =
      const VerificationMeta('checkpointElapsedMs');
  @override
  late final GeneratedColumn<int> checkpointElapsedMs = GeneratedColumn<int>(
    'checkpoint_elapsed_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> checkpointAt =
      GeneratedColumn<int>(
        'checkpoint_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SessionsTable.$convertercheckpointAtn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    archivedAt,
    kind,
    templateId,
    status,
    startedAt,
    endedAt,
    timeZoneId,
    utcOffsetMinutes,
    pausedSeconds,
    templateSnapshot,
    perceivedEffort,
    note,
    checkpointPhaseIndex,
    checkpointElapsedMs,
    checkpointAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('time_zone_id')) {
      context.handle(
        _timeZoneIdMeta,
        timeZoneId.isAcceptableOrUnknown(
          data['time_zone_id']!,
          _timeZoneIdMeta,
        ),
      );
    }
    if (data.containsKey('utc_offset_minutes')) {
      context.handle(
        _utcOffsetMinutesMeta,
        utcOffsetMinutes.isAcceptableOrUnknown(
          data['utc_offset_minutes']!,
          _utcOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_utcOffsetMinutesMeta);
    }
    if (data.containsKey('paused_seconds')) {
      context.handle(
        _pausedSecondsMeta,
        pausedSeconds.isAcceptableOrUnknown(
          data['paused_seconds']!,
          _pausedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('perceived_effort')) {
      context.handle(
        _perceivedEffortMeta,
        perceivedEffort.isAcceptableOrUnknown(
          data['perceived_effort']!,
          _perceivedEffortMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('checkpoint_phase_index')) {
      context.handle(
        _checkpointPhaseIndexMeta,
        checkpointPhaseIndex.isAcceptableOrUnknown(
          data['checkpoint_phase_index']!,
          _checkpointPhaseIndexMeta,
        ),
      );
    }
    if (data.containsKey('checkpoint_elapsed_ms')) {
      context.handle(
        _checkpointElapsedMsMeta,
        checkpointElapsedMs.isAcceptableOrUnknown(
          data['checkpoint_elapsed_ms']!,
          _checkpointElapsedMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $SessionsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $SessionsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      archivedAt: $SessionsTable.$converterarchivedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}archived_at'],
        ),
      ),
      kind: $SessionsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      status: $SessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      startedAt: $SessionsTable.$converterstartedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}started_at'],
        )!,
      ),
      endedAt: $SessionsTable.$converterendedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}ended_at'],
        ),
      ),
      timeZoneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone_id'],
      ),
      utcOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}utc_offset_minutes'],
      )!,
      pausedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paused_seconds'],
      )!,
      templateSnapshot: $SessionsTable.$convertertemplateSnapshotn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}template_snapshot'],
        ),
      ),
      perceivedEffort: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}perceived_effort'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      checkpointPhaseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}checkpoint_phase_index'],
      ),
      checkpointElapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}checkpoint_elapsed_ms'],
      ),
      checkpointAt: $SessionsTable.$convertercheckpointAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}checkpoint_at'],
        ),
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterarchivedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterarchivedAtn =
      NullAwareTypeConverter.wrap($converterarchivedAt);
  static JsonTypeConverter2<SessionKind, String, String> $converterkind =
      const EnumNameConverter<SessionKind>(SessionKind.values);
  static JsonTypeConverter2<SessionStatus, String, String> $converterstatus =
      const EnumNameConverter<SessionStatus>(SessionStatus.values);
  static TypeConverter<DateTime, int> $converterstartedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterendedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterendedAtn =
      NullAwareTypeConverter.wrap($converterendedAt);
  static TypeConverter<Map<String, Object?>, String>
  $convertertemplateSnapshot = const JsonMapConverter();
  static TypeConverter<Map<String, Object?>?, String?>
  $convertertemplateSnapshotn = NullAwareTypeConverter.wrap(
    $convertertemplateSnapshot,
  );
  static TypeConverter<DateTime, int> $convertercheckpointAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $convertercheckpointAtn =
      NullAwareTypeConverter.wrap($convertercheckpointAt);
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final SessionKind kind;

  /// Rutina o entrenamiento de origen (sin FK: puede ser de dos tablas y la
  /// sesión no depende de él gracias a [templateSnapshot]).
  final String? templateId;
  final SessionStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// Zona IANA (p. ej. America/Santiago) si se conoce, y el desfase local
  /// al empezar, para agrupar por día y semana del usuario.
  final String? timeZoneId;
  final int utcOffsetMinutes;
  final int pausedSeconds;

  /// Copia de la plantilla al empezar: editarla no altera esta sesión.
  final Map<String, Object?>? templateSnapshot;
  final int? perceivedEffort;
  final String? note;
  final int? checkpointPhaseIndex;
  final int? checkpointElapsedMs;
  final DateTime? checkpointAt;
  const Session({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
    required this.kind,
    this.templateId,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.timeZoneId,
    required this.utcOffsetMinutes,
    required this.pausedSeconds,
    this.templateSnapshot,
    this.perceivedEffort,
    this.note,
    this.checkpointPhaseIndex,
    this.checkpointElapsedMs,
    this.checkpointAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $SessionsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $SessionsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<int>(
        $SessionsTable.$converterarchivedAtn.toSql(archivedAt),
      );
    }
    {
      map['kind'] = Variable<String>($SessionsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['started_at'] = Variable<int>(
        $SessionsTable.$converterstartedAt.toSql(startedAt),
      );
    }
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(
        $SessionsTable.$converterendedAtn.toSql(endedAt),
      );
    }
    if (!nullToAbsent || timeZoneId != null) {
      map['time_zone_id'] = Variable<String>(timeZoneId);
    }
    map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes);
    map['paused_seconds'] = Variable<int>(pausedSeconds);
    if (!nullToAbsent || templateSnapshot != null) {
      map['template_snapshot'] = Variable<String>(
        $SessionsTable.$convertertemplateSnapshotn.toSql(templateSnapshot),
      );
    }
    if (!nullToAbsent || perceivedEffort != null) {
      map['perceived_effort'] = Variable<int>(perceivedEffort);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || checkpointPhaseIndex != null) {
      map['checkpoint_phase_index'] = Variable<int>(checkpointPhaseIndex);
    }
    if (!nullToAbsent || checkpointElapsedMs != null) {
      map['checkpoint_elapsed_ms'] = Variable<int>(checkpointElapsedMs);
    }
    if (!nullToAbsent || checkpointAt != null) {
      map['checkpoint_at'] = Variable<int>(
        $SessionsTable.$convertercheckpointAtn.toSql(checkpointAt),
      );
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      kind: Value(kind),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      status: Value(status),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      timeZoneId: timeZoneId == null && nullToAbsent
          ? const Value.absent()
          : Value(timeZoneId),
      utcOffsetMinutes: Value(utcOffsetMinutes),
      pausedSeconds: Value(pausedSeconds),
      templateSnapshot: templateSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(templateSnapshot),
      perceivedEffort: perceivedEffort == null && nullToAbsent
          ? const Value.absent()
          : Value(perceivedEffort),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      checkpointPhaseIndex: checkpointPhaseIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointPhaseIndex),
      checkpointElapsedMs: checkpointElapsedMs == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointElapsedMs),
      checkpointAt: checkpointAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkpointAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      kind: $SessionsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      templateId: serializer.fromJson<String?>(json['templateId']),
      status: $SessionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      timeZoneId: serializer.fromJson<String?>(json['timeZoneId']),
      utcOffsetMinutes: serializer.fromJson<int>(json['utcOffsetMinutes']),
      pausedSeconds: serializer.fromJson<int>(json['pausedSeconds']),
      templateSnapshot: serializer.fromJson<Map<String, Object?>?>(
        json['templateSnapshot'],
      ),
      perceivedEffort: serializer.fromJson<int?>(json['perceivedEffort']),
      note: serializer.fromJson<String?>(json['note']),
      checkpointPhaseIndex: serializer.fromJson<int?>(
        json['checkpointPhaseIndex'],
      ),
      checkpointElapsedMs: serializer.fromJson<int?>(
        json['checkpointElapsedMs'],
      ),
      checkpointAt: serializer.fromJson<DateTime?>(json['checkpointAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'kind': serializer.toJson<String>(
        $SessionsTable.$converterkind.toJson(kind),
      ),
      'templateId': serializer.toJson<String?>(templateId),
      'status': serializer.toJson<String>(
        $SessionsTable.$converterstatus.toJson(status),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'timeZoneId': serializer.toJson<String?>(timeZoneId),
      'utcOffsetMinutes': serializer.toJson<int>(utcOffsetMinutes),
      'pausedSeconds': serializer.toJson<int>(pausedSeconds),
      'templateSnapshot': serializer.toJson<Map<String, Object?>?>(
        templateSnapshot,
      ),
      'perceivedEffort': serializer.toJson<int?>(perceivedEffort),
      'note': serializer.toJson<String?>(note),
      'checkpointPhaseIndex': serializer.toJson<int?>(checkpointPhaseIndex),
      'checkpointElapsedMs': serializer.toJson<int?>(checkpointElapsedMs),
      'checkpointAt': serializer.toJson<DateTime?>(checkpointAt),
    };
  }

  Session copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    SessionKind? kind,
    Value<String?> templateId = const Value.absent(),
    SessionStatus? status,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    Value<String?> timeZoneId = const Value.absent(),
    int? utcOffsetMinutes,
    int? pausedSeconds,
    Value<Map<String, Object?>?> templateSnapshot = const Value.absent(),
    Value<int?> perceivedEffort = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<int?> checkpointPhaseIndex = const Value.absent(),
    Value<int?> checkpointElapsedMs = const Value.absent(),
    Value<DateTime?> checkpointAt = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    kind: kind ?? this.kind,
    templateId: templateId.present ? templateId.value : this.templateId,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    timeZoneId: timeZoneId.present ? timeZoneId.value : this.timeZoneId,
    utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
    pausedSeconds: pausedSeconds ?? this.pausedSeconds,
    templateSnapshot: templateSnapshot.present
        ? templateSnapshot.value
        : this.templateSnapshot,
    perceivedEffort: perceivedEffort.present
        ? perceivedEffort.value
        : this.perceivedEffort,
    note: note.present ? note.value : this.note,
    checkpointPhaseIndex: checkpointPhaseIndex.present
        ? checkpointPhaseIndex.value
        : this.checkpointPhaseIndex,
    checkpointElapsedMs: checkpointElapsedMs.present
        ? checkpointElapsedMs.value
        : this.checkpointElapsedMs,
    checkpointAt: checkpointAt.present ? checkpointAt.value : this.checkpointAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      timeZoneId: data.timeZoneId.present
          ? data.timeZoneId.value
          : this.timeZoneId,
      utcOffsetMinutes: data.utcOffsetMinutes.present
          ? data.utcOffsetMinutes.value
          : this.utcOffsetMinutes,
      pausedSeconds: data.pausedSeconds.present
          ? data.pausedSeconds.value
          : this.pausedSeconds,
      templateSnapshot: data.templateSnapshot.present
          ? data.templateSnapshot.value
          : this.templateSnapshot,
      perceivedEffort: data.perceivedEffort.present
          ? data.perceivedEffort.value
          : this.perceivedEffort,
      note: data.note.present ? data.note.value : this.note,
      checkpointPhaseIndex: data.checkpointPhaseIndex.present
          ? data.checkpointPhaseIndex.value
          : this.checkpointPhaseIndex,
      checkpointElapsedMs: data.checkpointElapsedMs.present
          ? data.checkpointElapsedMs.value
          : this.checkpointElapsedMs,
      checkpointAt: data.checkpointAt.present
          ? data.checkpointAt.value
          : this.checkpointAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('pausedSeconds: $pausedSeconds, ')
          ..write('templateSnapshot: $templateSnapshot, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('note: $note, ')
          ..write('checkpointPhaseIndex: $checkpointPhaseIndex, ')
          ..write('checkpointElapsedMs: $checkpointElapsedMs, ')
          ..write('checkpointAt: $checkpointAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    archivedAt,
    kind,
    templateId,
    status,
    startedAt,
    endedAt,
    timeZoneId,
    utcOffsetMinutes,
    pausedSeconds,
    templateSnapshot,
    perceivedEffort,
    note,
    checkpointPhaseIndex,
    checkpointElapsedMs,
    checkpointAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt &&
          other.kind == this.kind &&
          other.templateId == this.templateId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.timeZoneId == this.timeZoneId &&
          other.utcOffsetMinutes == this.utcOffsetMinutes &&
          other.pausedSeconds == this.pausedSeconds &&
          other.templateSnapshot == this.templateSnapshot &&
          other.perceivedEffort == this.perceivedEffort &&
          other.note == this.note &&
          other.checkpointPhaseIndex == this.checkpointPhaseIndex &&
          other.checkpointElapsedMs == this.checkpointElapsedMs &&
          other.checkpointAt == this.checkpointAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<SessionKind> kind;
  final Value<String?> templateId;
  final Value<SessionStatus> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String?> timeZoneId;
  final Value<int> utcOffsetMinutes;
  final Value<int> pausedSeconds;
  final Value<Map<String, Object?>?> templateSnapshot;
  final Value<int?> perceivedEffort;
  final Value<String?> note;
  final Value<int?> checkpointPhaseIndex;
  final Value<int?> checkpointElapsedMs;
  final Value<DateTime?> checkpointAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    this.utcOffsetMinutes = const Value.absent(),
    this.pausedSeconds = const Value.absent(),
    this.templateSnapshot = const Value.absent(),
    this.perceivedEffort = const Value.absent(),
    this.note = const Value.absent(),
    this.checkpointPhaseIndex = const Value.absent(),
    this.checkpointElapsedMs = const Value.absent(),
    this.checkpointAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required SessionKind kind,
    this.templateId = const Value.absent(),
    required SessionStatus status,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.timeZoneId = const Value.absent(),
    required int utcOffsetMinutes,
    this.pausedSeconds = const Value.absent(),
    this.templateSnapshot = const Value.absent(),
    this.perceivedEffort = const Value.absent(),
    this.note = const Value.absent(),
    this.checkpointPhaseIndex = const Value.absent(),
    this.checkpointElapsedMs = const Value.absent(),
    this.checkpointAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       status = Value(status),
       startedAt = Value(startedAt),
       utcOffsetMinutes = Value(utcOffsetMinutes);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? archivedAt,
    Expression<String>? kind,
    Expression<String>? templateId,
    Expression<String>? status,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? timeZoneId,
    Expression<int>? utcOffsetMinutes,
    Expression<int>? pausedSeconds,
    Expression<String>? templateSnapshot,
    Expression<int>? perceivedEffort,
    Expression<String>? note,
    Expression<int>? checkpointPhaseIndex,
    Expression<int>? checkpointElapsedMs,
    Expression<int>? checkpointAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (kind != null) 'kind': kind,
      if (templateId != null) 'template_id': templateId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (timeZoneId != null) 'time_zone_id': timeZoneId,
      if (utcOffsetMinutes != null) 'utc_offset_minutes': utcOffsetMinutes,
      if (pausedSeconds != null) 'paused_seconds': pausedSeconds,
      if (templateSnapshot != null) 'template_snapshot': templateSnapshot,
      if (perceivedEffort != null) 'perceived_effort': perceivedEffort,
      if (note != null) 'note': note,
      if (checkpointPhaseIndex != null)
        'checkpoint_phase_index': checkpointPhaseIndex,
      if (checkpointElapsedMs != null)
        'checkpoint_elapsed_ms': checkpointElapsedMs,
      if (checkpointAt != null) 'checkpoint_at': checkpointAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<SessionKind>? kind,
    Value<String?>? templateId,
    Value<SessionStatus>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String?>? timeZoneId,
    Value<int>? utcOffsetMinutes,
    Value<int>? pausedSeconds,
    Value<Map<String, Object?>?>? templateSnapshot,
    Value<int?>? perceivedEffort,
    Value<String?>? note,
    Value<int?>? checkpointPhaseIndex,
    Value<int?>? checkpointElapsedMs,
    Value<DateTime?>? checkpointAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      kind: kind ?? this.kind,
      templateId: templateId ?? this.templateId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      timeZoneId: timeZoneId ?? this.timeZoneId,
      utcOffsetMinutes: utcOffsetMinutes ?? this.utcOffsetMinutes,
      pausedSeconds: pausedSeconds ?? this.pausedSeconds,
      templateSnapshot: templateSnapshot ?? this.templateSnapshot,
      perceivedEffort: perceivedEffort ?? this.perceivedEffort,
      note: note ?? this.note,
      checkpointPhaseIndex: checkpointPhaseIndex ?? this.checkpointPhaseIndex,
      checkpointElapsedMs: checkpointElapsedMs ?? this.checkpointElapsedMs,
      checkpointAt: checkpointAt ?? this.checkpointAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $SessionsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $SessionsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<int>(
        $SessionsTable.$converterarchivedAtn.toSql(archivedAt.value),
      );
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SessionsTable.$converterkind.toSql(kind.value),
      );
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(
        $SessionsTable.$converterstartedAt.toSql(startedAt.value),
      );
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(
        $SessionsTable.$converterendedAtn.toSql(endedAt.value),
      );
    }
    if (timeZoneId.present) {
      map['time_zone_id'] = Variable<String>(timeZoneId.value);
    }
    if (utcOffsetMinutes.present) {
      map['utc_offset_minutes'] = Variable<int>(utcOffsetMinutes.value);
    }
    if (pausedSeconds.present) {
      map['paused_seconds'] = Variable<int>(pausedSeconds.value);
    }
    if (templateSnapshot.present) {
      map['template_snapshot'] = Variable<String>(
        $SessionsTable.$convertertemplateSnapshotn.toSql(
          templateSnapshot.value,
        ),
      );
    }
    if (perceivedEffort.present) {
      map['perceived_effort'] = Variable<int>(perceivedEffort.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (checkpointPhaseIndex.present) {
      map['checkpoint_phase_index'] = Variable<int>(checkpointPhaseIndex.value);
    }
    if (checkpointElapsedMs.present) {
      map['checkpoint_elapsed_ms'] = Variable<int>(checkpointElapsedMs.value);
    }
    if (checkpointAt.present) {
      map['checkpoint_at'] = Variable<int>(
        $SessionsTable.$convertercheckpointAtn.toSql(checkpointAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('timeZoneId: $timeZoneId, ')
          ..write('utcOffsetMinutes: $utcOffsetMinutes, ')
          ..write('pausedSeconds: $pausedSeconds, ')
          ..write('templateSnapshot: $templateSnapshot, ')
          ..write('perceivedEffort: $perceivedEffort, ')
          ..write('note: $note, ')
          ..write('checkpointPhaseIndex: $checkpointPhaseIndex, ')
          ..write('checkpointElapsedMs: $checkpointElapsedMs, ')
          ..write('checkpointAt: $checkpointAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SessionExercisesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SessionExercisesTable.$converterupdatedAt);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise (id)',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    sessionId,
    exerciseId,
    sortOrder,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercise';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $SessionExercisesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $SessionExercisesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class SessionExercise extends DataClass implements Insertable<SessionExercise> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sessionId;
  final String exerciseId;
  final int sortOrder;
  final String? notes;
  const SessionExercise({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionId,
    required this.exerciseId,
    required this.sortOrder,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $SessionExercisesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $SessionExercisesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory SessionExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExercise(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  SessionExercise copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sessionId,
    String? exerciseId,
    int? sortOrder,
    Value<String?> notes = const Value.absent(),
  }) => SessionExercise(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    notes: notes.present ? notes.value : this.notes,
  );
  SessionExercise copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExercise(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercise(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    sessionId,
    exerciseId,
    sortOrder,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExercise &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.notes == this.notes);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExercise> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<String?> notes;
  final Value<int> rowid;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String sessionId,
    required String exerciseId,
    required int sortOrder,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<SessionExercise> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionExercisesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $SessionExercisesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $SessionExercisesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SetLogsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($SetLogsTable.$converterupdatedAt);
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<String> sessionExerciseId =
      GeneratedColumn<String>(
        'session_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES session_exercise (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise (id)',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SetType, String> setType =
      GeneratedColumn<String>(
        'set_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SetType.normal.name),
      ).withConverter<SetType>($SetLogsTable.$convertersetType);
  static const VerificationMeta _weightValueMeta = const VerificationMeta(
    'weightValue',
  );
  @override
  late final GeneratedColumn<double> weightValue = GeneratedColumn<double>(
    'weight_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeightUnit?, String> weightUnit =
      GeneratedColumn<String>(
        'weight_unit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<WeightUnit?>($SetLogsTable.$converterweightUnitn);
  static const VerificationMeta _weightGramsMeta = const VerificationMeta(
    'weightGrams',
  );
  @override
  late final GeneratedColumn<int> weightGrams = GeneratedColumn<int>(
    'weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> loggedAt =
      GeneratedColumn<int>(
        'logged_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($SetLogsTable.$converterloggedAtn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    sessionExerciseId,
    sessionId,
    exerciseId,
    sortOrder,
    setType,
    weightValue,
    weightUnit,
    weightGrams,
    reps,
    rpe,
    durationSeconds,
    distanceMeters,
    completed,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('weight_value')) {
      context.handle(
        _weightValueMeta,
        weightValue.isAcceptableOrUnknown(
          data['weight_value']!,
          _weightValueMeta,
        ),
      );
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
        _weightGramsMeta,
        weightGrams.isAcceptableOrUnknown(
          data['weight_grams']!,
          _weightGramsMeta,
        ),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $SetLogsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $SetLogsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      setType: $SetLogsTable.$convertersetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}set_type'],
        )!,
      ),
      weightValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_value'],
      ),
      weightUnit: $SetLogsTable.$converterweightUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}weight_unit'],
        ),
      ),
      weightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight_grams'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      loggedAt: $SetLogsTable.$converterloggedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}logged_at'],
        ),
      ),
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<SetType, String, String> $convertersetType =
      const EnumNameConverter<SetType>(SetType.values);
  static JsonTypeConverter2<WeightUnit, String, String> $converterweightUnit =
      const EnumNameConverter<WeightUnit>(WeightUnit.values);
  static JsonTypeConverter2<WeightUnit?, String?, String?>
  $converterweightUnitn = JsonTypeConverter2.asNullable($converterweightUnit);
  static TypeConverter<DateTime, int> $converterloggedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterloggedAtn =
      NullAwareTypeConverter.wrap($converterloggedAt);
}

class SetLog extends DataClass implements Insertable<SetLog> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sessionExerciseId;
  final String sessionId;
  final String exerciseId;
  final int sortOrder;
  final SetType setType;
  final double? weightValue;
  final WeightUnit? weightUnit;
  final int? weightGrams;
  final int? reps;
  final double? rpe;
  final int? durationSeconds;
  final double? distanceMeters;
  final bool completed;
  final DateTime? loggedAt;
  const SetLog({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionExerciseId,
    required this.sessionId,
    required this.exerciseId,
    required this.sortOrder,
    required this.setType,
    this.weightValue,
    this.weightUnit,
    this.weightGrams,
    this.reps,
    this.rpe,
    this.durationSeconds,
    this.distanceMeters,
    required this.completed,
    this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $SetLogsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $SetLogsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['session_exercise_id'] = Variable<String>(sessionExerciseId);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['set_type'] = Variable<String>(
        $SetLogsTable.$convertersetType.toSql(setType),
      );
    }
    if (!nullToAbsent || weightValue != null) {
      map['weight_value'] = Variable<double>(weightValue);
    }
    if (!nullToAbsent || weightUnit != null) {
      map['weight_unit'] = Variable<String>(
        $SetLogsTable.$converterweightUnitn.toSql(weightUnit),
      );
    }
    if (!nullToAbsent || weightGrams != null) {
      map['weight_grams'] = Variable<int>(weightGrams);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || loggedAt != null) {
      map['logged_at'] = Variable<int>(
        $SetLogsTable.$converterloggedAtn.toSql(loggedAt),
      );
    }
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sessionExerciseId: Value(sessionExerciseId),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
      setType: Value(setType),
      weightValue: weightValue == null && nullToAbsent
          ? const Value.absent()
          : Value(weightValue),
      weightUnit: weightUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(weightUnit),
      weightGrams: weightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGrams),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
      completed: Value(completed),
      loggedAt: loggedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(loggedAt),
    );
  }

  factory SetLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLog(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sessionExerciseId: serializer.fromJson<String>(json['sessionExerciseId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      setType: $SetLogsTable.$convertersetType.fromJson(
        serializer.fromJson<String>(json['setType']),
      ),
      weightValue: serializer.fromJson<double?>(json['weightValue']),
      weightUnit: $SetLogsTable.$converterweightUnitn.fromJson(
        serializer.fromJson<String?>(json['weightUnit']),
      ),
      weightGrams: serializer.fromJson<int?>(json['weightGrams']),
      reps: serializer.fromJson<int?>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
      completed: serializer.fromJson<bool>(json['completed']),
      loggedAt: serializer.fromJson<DateTime?>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sessionExerciseId': serializer.toJson<String>(sessionExerciseId),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'setType': serializer.toJson<String>(
        $SetLogsTable.$convertersetType.toJson(setType),
      ),
      'weightValue': serializer.toJson<double?>(weightValue),
      'weightUnit': serializer.toJson<String?>(
        $SetLogsTable.$converterweightUnitn.toJson(weightUnit),
      ),
      'weightGrams': serializer.toJson<int?>(weightGrams),
      'reps': serializer.toJson<int?>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
      'completed': serializer.toJson<bool>(completed),
      'loggedAt': serializer.toJson<DateTime?>(loggedAt),
    };
  }

  SetLog copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sessionExerciseId,
    String? sessionId,
    String? exerciseId,
    int? sortOrder,
    SetType? setType,
    Value<double?> weightValue = const Value.absent(),
    Value<WeightUnit?> weightUnit = const Value.absent(),
    Value<int?> weightGrams = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<double?> rpe = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
    bool? completed,
    Value<DateTime?> loggedAt = const Value.absent(),
  }) => SetLog(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    setType: setType ?? this.setType,
    weightValue: weightValue.present ? weightValue.value : this.weightValue,
    weightUnit: weightUnit.present ? weightUnit.value : this.weightUnit,
    weightGrams: weightGrams.present ? weightGrams.value : this.weightGrams,
    reps: reps.present ? reps.value : this.reps,
    rpe: rpe.present ? rpe.value : this.rpe,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
    completed: completed ?? this.completed,
    loggedAt: loggedAt.present ? loggedAt.value : this.loggedAt,
  );
  SetLog copyWithCompanion(SetLogsCompanion data) {
    return SetLog(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      setType: data.setType.present ? data.setType.value : this.setType,
      weightValue: data.weightValue.present
          ? data.weightValue.value
          : this.weightValue,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      weightGrams: data.weightGrams.present
          ? data.weightGrams.value
          : this.weightGrams,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      completed: data.completed.present ? data.completed.value : this.completed,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLog(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('weightValue: $weightValue, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('completed: $completed, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    sessionExerciseId,
    sessionId,
    exerciseId,
    sortOrder,
    setType,
    weightValue,
    weightUnit,
    weightGrams,
    reps,
    rpe,
    durationSeconds,
    distanceMeters,
    completed,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLog &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder &&
          other.setType == this.setType &&
          other.weightValue == this.weightValue &&
          other.weightUnit == this.weightUnit &&
          other.weightGrams == this.weightGrams &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.completed == this.completed &&
          other.loggedAt == this.loggedAt);
}

class SetLogsCompanion extends UpdateCompanion<SetLog> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> sessionExerciseId;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<SetType> setType;
  final Value<double?> weightValue;
  final Value<WeightUnit?> weightUnit;
  final Value<int?> weightGrams;
  final Value<int?> reps;
  final Value<double?> rpe;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<bool> completed;
  final Value<DateTime?> loggedAt;
  final Value<int> rowid;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.setType = const Value.absent(),
    this.weightValue = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.completed = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetLogsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String sessionExerciseId,
    required String sessionId,
    required String exerciseId,
    required int sortOrder,
    this.setType = const Value.absent(),
    this.weightValue = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.completed = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionExerciseId = Value(sessionExerciseId),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<SetLog> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? sessionExerciseId,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<String>? setType,
    Expression<double>? weightValue,
    Expression<String>? weightUnit,
    Expression<int>? weightGrams,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<bool>? completed,
    Expression<int>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (setType != null) 'set_type': setType,
      if (weightValue != null) 'weight_value': weightValue,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (completed != null) 'completed': completed,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? sessionExerciseId,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<SetType>? setType,
    Value<double?>? weightValue,
    Value<WeightUnit?>? weightUnit,
    Value<int?>? weightGrams,
    Value<int?>? reps,
    Value<double?>? rpe,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<bool>? completed,
    Value<DateTime?>? loggedAt,
    Value<int>? rowid,
  }) {
    return SetLogsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      setType: setType ?? this.setType,
      weightValue: weightValue ?? this.weightValue,
      weightUnit: weightUnit ?? this.weightUnit,
      weightGrams: weightGrams ?? this.weightGrams,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      completed: completed ?? this.completed,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $SetLogsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $SetLogsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<String>(sessionExerciseId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(
        $SetLogsTable.$convertersetType.toSql(setType.value),
      );
    }
    if (weightValue.present) {
      map['weight_value'] = Variable<double>(weightValue.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(
        $SetLogsTable.$converterweightUnitn.toSql(weightUnit.value),
      );
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<int>(weightGrams.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<int>(
        $SetLogsTable.$converterloggedAtn.toSql(loggedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('weightValue: $weightValue, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('completed: $completed, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntervalPhaseLogsTable extends IntervalPhaseLogs
    with TableInfo<$IntervalPhaseLogsTable, IntervalPhaseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntervalPhaseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalPhaseLogsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($IntervalPhaseLogsTable.$converterupdatedAt);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session (id) ON DELETE CASCADE',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PhaseType, String> phaseType =
      GeneratedColumn<String>(
        'phase_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PhaseType>($IntervalPhaseLogsTable.$converterphaseType);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _plannedSecondsMeta = const VerificationMeta(
    'plannedSeconds',
  );
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
    'planned_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualSecondsMeta = const VerificationMeta(
    'actualSeconds',
  );
  @override
  late final GeneratedColumn<int> actualSeconds = GeneratedColumn<int>(
    'actual_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedMeta = const VerificationMeta(
    'skipped',
  );
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
    'skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    sessionId,
    sortOrder,
    phaseType,
    label,
    round,
    plannedSeconds,
    actualSeconds,
    skipped,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interval_phase_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntervalPhaseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
        _plannedSecondsMeta,
        plannedSeconds.isAcceptableOrUnknown(
          data['planned_seconds']!,
          _plannedSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('actual_seconds')) {
      context.handle(
        _actualSecondsMeta,
        actualSeconds.isAcceptableOrUnknown(
          data['actual_seconds']!,
          _actualSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualSecondsMeta);
    }
    if (data.containsKey('skipped')) {
      context.handle(
        _skippedMeta,
        skipped.isAcceptableOrUnknown(data['skipped']!, _skippedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntervalPhaseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntervalPhaseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $IntervalPhaseLogsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $IntervalPhaseLogsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      phaseType: $IntervalPhaseLogsTable.$converterphaseType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}phase_type'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      plannedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_seconds'],
      )!,
      actualSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_seconds'],
      )!,
      skipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}skipped'],
      )!,
    );
  }

  @override
  $IntervalPhaseLogsTable createAlias(String alias) {
    return $IntervalPhaseLogsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<PhaseType, String, String> $converterphaseType =
      const EnumNameConverter<PhaseType>(PhaseType.values);
}

class IntervalPhaseLog extends DataClass
    implements Insertable<IntervalPhaseLog> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String sessionId;
  final int sortOrder;
  final PhaseType phaseType;
  final String? label;
  final int round;
  final int plannedSeconds;
  final int actualSeconds;
  final bool skipped;
  const IntervalPhaseLog({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.sessionId,
    required this.sortOrder,
    required this.phaseType,
    this.label,
    required this.round,
    required this.plannedSeconds,
    required this.actualSeconds,
    required this.skipped,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $IntervalPhaseLogsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $IntervalPhaseLogsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['session_id'] = Variable<String>(sessionId);
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['phase_type'] = Variable<String>(
        $IntervalPhaseLogsTable.$converterphaseType.toSql(phaseType),
      );
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['round'] = Variable<int>(round);
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['actual_seconds'] = Variable<int>(actualSeconds);
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }

  IntervalPhaseLogsCompanion toCompanion(bool nullToAbsent) {
    return IntervalPhaseLogsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      sessionId: Value(sessionId),
      sortOrder: Value(sortOrder),
      phaseType: Value(phaseType),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      round: Value(round),
      plannedSeconds: Value(plannedSeconds),
      actualSeconds: Value(actualSeconds),
      skipped: Value(skipped),
    );
  }

  factory IntervalPhaseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntervalPhaseLog(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      phaseType: $IntervalPhaseLogsTable.$converterphaseType.fromJson(
        serializer.fromJson<String>(json['phaseType']),
      ),
      label: serializer.fromJson<String?>(json['label']),
      round: serializer.fromJson<int>(json['round']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      actualSeconds: serializer.fromJson<int>(json['actualSeconds']),
      skipped: serializer.fromJson<bool>(json['skipped']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'sessionId': serializer.toJson<String>(sessionId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'phaseType': serializer.toJson<String>(
        $IntervalPhaseLogsTable.$converterphaseType.toJson(phaseType),
      ),
      'label': serializer.toJson<String?>(label),
      'round': serializer.toJson<int>(round),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'actualSeconds': serializer.toJson<int>(actualSeconds),
      'skipped': serializer.toJson<bool>(skipped),
    };
  }

  IntervalPhaseLog copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sessionId,
    int? sortOrder,
    PhaseType? phaseType,
    Value<String?> label = const Value.absent(),
    int? round,
    int? plannedSeconds,
    int? actualSeconds,
    bool? skipped,
  }) => IntervalPhaseLog(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    sessionId: sessionId ?? this.sessionId,
    sortOrder: sortOrder ?? this.sortOrder,
    phaseType: phaseType ?? this.phaseType,
    label: label.present ? label.value : this.label,
    round: round ?? this.round,
    plannedSeconds: plannedSeconds ?? this.plannedSeconds,
    actualSeconds: actualSeconds ?? this.actualSeconds,
    skipped: skipped ?? this.skipped,
  );
  IntervalPhaseLog copyWithCompanion(IntervalPhaseLogsCompanion data) {
    return IntervalPhaseLog(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      phaseType: data.phaseType.present ? data.phaseType.value : this.phaseType,
      label: data.label.present ? data.label.value : this.label,
      round: data.round.present ? data.round.value : this.round,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      actualSeconds: data.actualSeconds.present
          ? data.actualSeconds.value
          : this.actualSeconds,
      skipped: data.skipped.present ? data.skipped.value : this.skipped,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntervalPhaseLog(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('phaseType: $phaseType, ')
          ..write('label: $label, ')
          ..write('round: $round, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('skipped: $skipped')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    sessionId,
    sortOrder,
    phaseType,
    label,
    round,
    plannedSeconds,
    actualSeconds,
    skipped,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntervalPhaseLog &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.sessionId == this.sessionId &&
          other.sortOrder == this.sortOrder &&
          other.phaseType == this.phaseType &&
          other.label == this.label &&
          other.round == this.round &&
          other.plannedSeconds == this.plannedSeconds &&
          other.actualSeconds == this.actualSeconds &&
          other.skipped == this.skipped);
}

class IntervalPhaseLogsCompanion extends UpdateCompanion<IntervalPhaseLog> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> sessionId;
  final Value<int> sortOrder;
  final Value<PhaseType> phaseType;
  final Value<String?> label;
  final Value<int> round;
  final Value<int> plannedSeconds;
  final Value<int> actualSeconds;
  final Value<bool> skipped;
  final Value<int> rowid;
  const IntervalPhaseLogsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.phaseType = const Value.absent(),
    this.label = const Value.absent(),
    this.round = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.actualSeconds = const Value.absent(),
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntervalPhaseLogsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String sessionId,
    required int sortOrder,
    required PhaseType phaseType,
    this.label = const Value.absent(),
    this.round = const Value.absent(),
    required int plannedSeconds,
    required int actualSeconds,
    this.skipped = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       sortOrder = Value(sortOrder),
       phaseType = Value(phaseType),
       plannedSeconds = Value(plannedSeconds),
       actualSeconds = Value(actualSeconds);
  static Insertable<IntervalPhaseLog> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? sessionId,
    Expression<int>? sortOrder,
    Expression<String>? phaseType,
    Expression<String>? label,
    Expression<int>? round,
    Expression<int>? plannedSeconds,
    Expression<int>? actualSeconds,
    Expression<bool>? skipped,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (sessionId != null) 'session_id': sessionId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (phaseType != null) 'phase_type': phaseType,
      if (label != null) 'label': label,
      if (round != null) 'round': round,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (actualSeconds != null) 'actual_seconds': actualSeconds,
      if (skipped != null) 'skipped': skipped,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntervalPhaseLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? sessionId,
    Value<int>? sortOrder,
    Value<PhaseType>? phaseType,
    Value<String?>? label,
    Value<int>? round,
    Value<int>? plannedSeconds,
    Value<int>? actualSeconds,
    Value<bool>? skipped,
    Value<int>? rowid,
  }) {
    return IntervalPhaseLogsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sessionId: sessionId ?? this.sessionId,
      sortOrder: sortOrder ?? this.sortOrder,
      phaseType: phaseType ?? this.phaseType,
      label: label ?? this.label,
      round: round ?? this.round,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      actualSeconds: actualSeconds ?? this.actualSeconds,
      skipped: skipped ?? this.skipped,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $IntervalPhaseLogsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $IntervalPhaseLogsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (phaseType.present) {
      map['phase_type'] = Variable<String>(
        $IntervalPhaseLogsTable.$converterphaseType.toSql(phaseType.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (actualSeconds.present) {
      map['actual_seconds'] = Variable<int>(actualSeconds.value);
    }
    if (skipped.present) {
      map['skipped'] = Variable<bool>(skipped.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalPhaseLogsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('phaseType: $phaseType, ')
          ..write('label: $label, ')
          ..write('round: $round, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('skipped: $skipped, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($PersonalRecordsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($PersonalRecordsTable.$converterupdatedAt);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecordType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecordType>($PersonalRecordsTable.$convertertype);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES session (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> achievedAt =
      GeneratedColumn<int>(
        'achieved_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($PersonalRecordsTable.$converterachievedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    exerciseId,
    type,
    value,
    sessionId,
    achievedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $PersonalRecordsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $PersonalRecordsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      type: $PersonalRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      achievedAt: $PersonalRecordsTable.$converterachievedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}achieved_at'],
        )!,
      ),
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<RecordType, String, String> $convertertype =
      const EnumNameConverter<RecordType>(RecordType.values);
  static TypeConverter<DateTime, int> $converterachievedAt =
      const UtcMillisConverter();
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String exerciseId;
  final RecordType type;
  final double value;
  final String? sessionId;
  final DateTime achievedAt;
  const PersonalRecord({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.exerciseId,
    required this.type,
    required this.value,
    this.sessionId,
    required this.achievedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $PersonalRecordsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $PersonalRecordsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['exercise_id'] = Variable<String>(exerciseId);
    {
      map['type'] = Variable<String>(
        $PersonalRecordsTable.$convertertype.toSql(type),
      );
    }
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    {
      map['achieved_at'] = Variable<int>(
        $PersonalRecordsTable.$converterachievedAt.toSql(achievedAt),
      );
    }
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      exerciseId: Value(exerciseId),
      type: Value(type),
      value: Value(value),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      achievedAt: Value(achievedAt),
    );
  }

  factory PersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      type: $PersonalRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      value: serializer.fromJson<double>(json['value']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'type': serializer.toJson<String>(
        $PersonalRecordsTable.$convertertype.toJson(type),
      ),
      'value': serializer.toJson<double>(value),
      'sessionId': serializer.toJson<String?>(sessionId),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  PersonalRecord copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? exerciseId,
    RecordType? type,
    double? value,
    Value<String?> sessionId = const Value.absent(),
    DateTime? achievedAt,
  }) => PersonalRecord(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    exerciseId: exerciseId ?? this.exerciseId,
    type: type ?? this.type,
    value: value ?? this.value,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('sessionId: $sessionId, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    exerciseId,
    type,
    value,
    sessionId,
    achievedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.exerciseId == this.exerciseId &&
          other.type == this.type &&
          other.value == this.value &&
          other.sessionId == this.sessionId &&
          other.achievedAt == this.achievedAt);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> exerciseId;
  final Value<RecordType> type;
  final Value<double> value;
  final Value<String?> sessionId;
  final Value<DateTime> achievedAt;
  final Value<int> rowid;
  const PersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String exerciseId,
    required RecordType type,
    required double value,
    this.sessionId = const Value.absent(),
    required DateTime achievedAt,
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       type = Value(type),
       value = Value(value),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalRecord> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? exerciseId,
    Expression<String>? type,
    Expression<double>? value,
    Expression<String>? sessionId,
    Expression<int>? achievedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (sessionId != null) 'session_id': sessionId,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? exerciseId,
    Value<RecordType>? type,
    Value<double>? value,
    Value<String?>? sessionId,
    Value<DateTime>? achievedAt,
    Value<int>? rowid,
  }) {
    return PersonalRecordsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      exerciseId: exerciseId ?? this.exerciseId,
      type: type ?? this.type,
      value: value ?? this.value,
      sessionId: sessionId ?? this.sessionId,
      achievedAt: achievedAt ?? this.achievedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $PersonalRecordsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $PersonalRecordsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $PersonalRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<int>(
        $PersonalRecordsTable.$converterachievedAt.toSql(achievedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('sessionId: $sessionId, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanDaysTable extends PlanDays with TableInfo<$PlanDaysTable, PlanDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($PlanDaysTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($PlanDaysTable.$converterupdatedAt);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    check: () => ComparableExpr(weekday).isBetweenValues(1, 7),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SessionKind>($PlanDaysTable.$converterkind);
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    weekday,
    kind,
    templateId,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_day';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $PlanDaysTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $PlanDaysTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      kind: $PlanDaysTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $PlanDaysTable createAlias(String alias) {
    return $PlanDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static JsonTypeConverter2<SessionKind, String, String> $converterkind =
      const EnumNameConverter<SessionKind>(SessionKind.values);
}

class PlanDay extends DataClass implements Insertable<PlanDay> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int weekday;
  final SessionKind kind;
  final String templateId;
  final int sortOrder;
  const PlanDay({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.weekday,
    required this.kind,
    required this.templateId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $PlanDaysTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $PlanDaysTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['weekday'] = Variable<int>(weekday);
    {
      map['kind'] = Variable<String>($PlanDaysTable.$converterkind.toSql(kind));
    }
    map['template_id'] = Variable<String>(templateId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  PlanDaysCompanion toCompanion(bool nullToAbsent) {
    return PlanDaysCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      weekday: Value(weekday),
      kind: Value(kind),
      templateId: Value(templateId),
      sortOrder: Value(sortOrder),
    );
  }

  factory PlanDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanDay(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      weekday: serializer.fromJson<int>(json['weekday']),
      kind: $PlanDaysTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      templateId: serializer.fromJson<String>(json['templateId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'weekday': serializer.toJson<int>(weekday),
      'kind': serializer.toJson<String>(
        $PlanDaysTable.$converterkind.toJson(kind),
      ),
      'templateId': serializer.toJson<String>(templateId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  PlanDay copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? weekday,
    SessionKind? kind,
    String? templateId,
    int? sortOrder,
  }) => PlanDay(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    weekday: weekday ?? this.weekday,
    kind: kind ?? this.kind,
    templateId: templateId ?? this.templateId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  PlanDay copyWithCompanion(PlanDaysCompanion data) {
    return PlanDay(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      kind: data.kind.present ? data.kind.value : this.kind,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanDay(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekday: $weekday, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    weekday,
    kind,
    templateId,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanDay &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.weekday == this.weekday &&
          other.kind == this.kind &&
          other.templateId == this.templateId &&
          other.sortOrder == this.sortOrder);
}

class PlanDaysCompanion extends UpdateCompanion<PlanDay> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> weekday;
  final Value<SessionKind> kind;
  final Value<String> templateId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const PlanDaysCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.weekday = const Value.absent(),
    this.kind = const Value.absent(),
    this.templateId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanDaysCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int weekday,
    required SessionKind kind,
    required String templateId,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : weekday = Value(weekday),
       kind = Value(kind),
       templateId = Value(templateId);
  static Insertable<PlanDay> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? weekday,
    Expression<String>? kind,
    Expression<String>? templateId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (weekday != null) 'weekday': weekday,
      if (kind != null) 'kind': kind,
      if (templateId != null) 'template_id': templateId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanDaysCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? weekday,
    Value<SessionKind>? kind,
    Value<String>? templateId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return PlanDaysCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weekday: weekday ?? this.weekday,
      kind: kind ?? this.kind,
      templateId: templateId ?? this.templateId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $PlanDaysTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $PlanDaysTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PlanDaysTable.$converterkind.toSql(kind.value),
      );
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanDaysCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekday: $weekday, ')
          ..write('kind: $kind, ')
          ..write('templateId: $templateId, ')
          ..write('sortOrder: $sortOrder, ')
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
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RemindersTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($RemindersTable.$converterupdatedAt);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    check: () => ComparableExpr(weekday).isBetweenValues(1, 7),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteOfDayMeta = const VerificationMeta(
    'minuteOfDay',
  );
  @override
  late final GeneratedColumn<int> minuteOfDay = GeneratedColumn<int>(
    'minute_of_day',
    aliasedName,
    false,
    check: () => ComparableExpr(minuteOfDay).isBetweenValues(0, 1439),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    weekday,
    minuteOfDay,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    if (data.containsKey('minute_of_day')) {
      context.handle(
        _minuteOfDayMeta,
        minuteOfDay.isAcceptableOrUnknown(
          data['minute_of_day']!,
          _minuteOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minuteOfDayMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
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
      createdAt: $RemindersTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RemindersTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      minuteOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute_of_day'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int weekday;

  /// Hora local en minutos desde medianoche.
  final int minuteOfDay;
  final bool enabled;
  const Reminder({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.weekday,
    required this.minuteOfDay,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $RemindersTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RemindersTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    map['weekday'] = Variable<int>(weekday);
    map['minute_of_day'] = Variable<int>(minuteOfDay);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      weekday: Value(weekday),
      minuteOfDay: Value(minuteOfDay),
      enabled: Value(enabled),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      weekday: serializer.fromJson<int>(json['weekday']),
      minuteOfDay: serializer.fromJson<int>(json['minuteOfDay']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'weekday': serializer.toJson<int>(weekday),
      'minuteOfDay': serializer.toJson<int>(minuteOfDay),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  Reminder copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? weekday,
    int? minuteOfDay,
    bool? enabled,
  }) => Reminder(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    weekday: weekday ?? this.weekday,
    minuteOfDay: minuteOfDay ?? this.minuteOfDay,
    enabled: enabled ?? this.enabled,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      minuteOfDay: data.minuteOfDay.present
          ? data.minuteOfDay.value
          : this.minuteOfDay,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekday: $weekday, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, weekday, minuteOfDay, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.weekday == this.weekday &&
          other.minuteOfDay == this.minuteOfDay &&
          other.enabled == this.enabled);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> weekday;
  final Value<int> minuteOfDay;
  final Value<bool> enabled;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.weekday = const Value.absent(),
    this.minuteOfDay = const Value.absent(),
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int weekday,
    required int minuteOfDay,
    this.enabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : weekday = Value(weekday),
       minuteOfDay = Value(minuteOfDay);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? weekday,
    Expression<int>? minuteOfDay,
    Expression<bool>? enabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (weekday != null) 'weekday': weekday,
      if (minuteOfDay != null) 'minute_of_day': minuteOfDay,
      if (enabled != null) 'enabled': enabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? weekday,
    Value<int>? minuteOfDay,
    Value<bool>? enabled,
    Value<int>? rowid,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weekday: weekday ?? this.weekday,
      minuteOfDay: minuteOfDay ?? this.minuteOfDay,
      enabled: enabled ?? this.enabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RemindersTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RemindersTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (minuteOfDay.present) {
      map['minute_of_day'] = Variable<int>(minuteOfDay.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('weekday: $weekday, ')
          ..write('minuteOfDay: $minuteOfDay, ')
          ..write('enabled: $enabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AdStatesTable extends AdStates with TableInfo<$AdStatesTable, AdState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($AdStatesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($AdStatesTable.$converterupdatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int>
  lastInterstitialAt = GeneratedColumn<int>(
    'last_interstitial_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($AdStatesTable.$converterlastInterstitialAtn);
  static const VerificationMeta _sessionsSinceInterstitialMeta =
      const VerificationMeta('sessionsSinceInterstitial');
  @override
  late final GeneratedColumn<int> sessionsSinceInterstitial =
      GeneratedColumn<int>(
        'sessions_since_interstitial',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  @override
  late final GeneratedColumnWithTypeConverter<ConsentStatus, String>
  consentStatus = GeneratedColumn<String>(
    'consent_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(ConsentStatus.unknown.name),
  ).withConverter<ConsentStatus>($AdStatesTable.$converterconsentStatus);
  static const VerificationMeta _adsRemovedMeta = const VerificationMeta(
    'adsRemoved',
  );
  @override
  late final GeneratedColumn<bool> adsRemoved = GeneratedColumn<bool>(
    'ads_removed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ads_removed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    lastInterstitialAt,
    sessionsSinceInterstitial,
    consentStatus,
    adsRemoved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ad_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sessions_since_interstitial')) {
      context.handle(
        _sessionsSinceInterstitialMeta,
        sessionsSinceInterstitial.isAcceptableOrUnknown(
          data['sessions_since_interstitial']!,
          _sessionsSinceInterstitialMeta,
        ),
      );
    }
    if (data.containsKey('ads_removed')) {
      context.handle(
        _adsRemovedMeta,
        adsRemoved.isAcceptableOrUnknown(data['ads_removed']!, _adsRemovedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdState(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: $AdStatesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $AdStatesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
      lastInterstitialAt: $AdStatesTable.$converterlastInterstitialAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}last_interstitial_at'],
        ),
      ),
      sessionsSinceInterstitial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessions_since_interstitial'],
      )!,
      consentStatus: $AdStatesTable.$converterconsentStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}consent_status'],
        )!,
      ),
      adsRemoved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ads_removed'],
      )!,
    );
  }

  @override
  $AdStatesTable createAlias(String alias) {
    return $AdStatesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterlastInterstitialAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterlastInterstitialAtn =
      NullAwareTypeConverter.wrap($converterlastInterstitialAt);
  static JsonTypeConverter2<ConsentStatus, String, String>
  $converterconsentStatus = const EnumNameConverter<ConsentStatus>(
    ConsentStatus.values,
  );
}

class AdState extends DataClass implements Insertable<AdState> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastInterstitialAt;
  final int sessionsSinceInterstitial;
  final ConsentStatus consentStatus;
  final bool adsRemoved;
  const AdState({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.lastInterstitialAt,
    required this.sessionsSinceInterstitial,
    required this.consentStatus,
    required this.adsRemoved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['created_at'] = Variable<int>(
        $AdStatesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $AdStatesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    if (!nullToAbsent || lastInterstitialAt != null) {
      map['last_interstitial_at'] = Variable<int>(
        $AdStatesTable.$converterlastInterstitialAtn.toSql(lastInterstitialAt),
      );
    }
    map['sessions_since_interstitial'] = Variable<int>(
      sessionsSinceInterstitial,
    );
    {
      map['consent_status'] = Variable<String>(
        $AdStatesTable.$converterconsentStatus.toSql(consentStatus),
      );
    }
    map['ads_removed'] = Variable<bool>(adsRemoved);
    return map;
  }

  AdStatesCompanion toCompanion(bool nullToAbsent) {
    return AdStatesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastInterstitialAt: lastInterstitialAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInterstitialAt),
      sessionsSinceInterstitial: Value(sessionsSinceInterstitial),
      consentStatus: Value(consentStatus),
      adsRemoved: Value(adsRemoved),
    );
  }

  factory AdState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdState(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastInterstitialAt: serializer.fromJson<DateTime?>(
        json['lastInterstitialAt'],
      ),
      sessionsSinceInterstitial: serializer.fromJson<int>(
        json['sessionsSinceInterstitial'],
      ),
      consentStatus: $AdStatesTable.$converterconsentStatus.fromJson(
        serializer.fromJson<String>(json['consentStatus']),
      ),
      adsRemoved: serializer.fromJson<bool>(json['adsRemoved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastInterstitialAt': serializer.toJson<DateTime?>(lastInterstitialAt),
      'sessionsSinceInterstitial': serializer.toJson<int>(
        sessionsSinceInterstitial,
      ),
      'consentStatus': serializer.toJson<String>(
        $AdStatesTable.$converterconsentStatus.toJson(consentStatus),
      ),
      'adsRemoved': serializer.toJson<bool>(adsRemoved),
    };
  }

  AdState copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastInterstitialAt = const Value.absent(),
    int? sessionsSinceInterstitial,
    ConsentStatus? consentStatus,
    bool? adsRemoved,
  }) => AdState(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastInterstitialAt: lastInterstitialAt.present
        ? lastInterstitialAt.value
        : this.lastInterstitialAt,
    sessionsSinceInterstitial:
        sessionsSinceInterstitial ?? this.sessionsSinceInterstitial,
    consentStatus: consentStatus ?? this.consentStatus,
    adsRemoved: adsRemoved ?? this.adsRemoved,
  );
  AdState copyWithCompanion(AdStatesCompanion data) {
    return AdState(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastInterstitialAt: data.lastInterstitialAt.present
          ? data.lastInterstitialAt.value
          : this.lastInterstitialAt,
      sessionsSinceInterstitial: data.sessionsSinceInterstitial.present
          ? data.sessionsSinceInterstitial.value
          : this.sessionsSinceInterstitial,
      consentStatus: data.consentStatus.present
          ? data.consentStatus.value
          : this.consentStatus,
      adsRemoved: data.adsRemoved.present
          ? data.adsRemoved.value
          : this.adsRemoved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdState(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastInterstitialAt: $lastInterstitialAt, ')
          ..write('sessionsSinceInterstitial: $sessionsSinceInterstitial, ')
          ..write('consentStatus: $consentStatus, ')
          ..write('adsRemoved: $adsRemoved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    lastInterstitialAt,
    sessionsSinceInterstitial,
    consentStatus,
    adsRemoved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdState &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastInterstitialAt == this.lastInterstitialAt &&
          other.sessionsSinceInterstitial == this.sessionsSinceInterstitial &&
          other.consentStatus == this.consentStatus &&
          other.adsRemoved == this.adsRemoved);
}

class AdStatesCompanion extends UpdateCompanion<AdState> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastInterstitialAt;
  final Value<int> sessionsSinceInterstitial;
  final Value<ConsentStatus> consentStatus;
  final Value<bool> adsRemoved;
  final Value<int> rowid;
  const AdStatesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastInterstitialAt = const Value.absent(),
    this.sessionsSinceInterstitial = const Value.absent(),
    this.consentStatus = const Value.absent(),
    this.adsRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AdStatesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastInterstitialAt = const Value.absent(),
    this.sessionsSinceInterstitial = const Value.absent(),
    this.consentStatus = const Value.absent(),
    this.adsRemoved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<AdState> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? lastInterstitialAt,
    Expression<int>? sessionsSinceInterstitial,
    Expression<String>? consentStatus,
    Expression<bool>? adsRemoved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastInterstitialAt != null)
        'last_interstitial_at': lastInterstitialAt,
      if (sessionsSinceInterstitial != null)
        'sessions_since_interstitial': sessionsSinceInterstitial,
      if (consentStatus != null) 'consent_status': consentStatus,
      if (adsRemoved != null) 'ads_removed': adsRemoved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AdStatesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastInterstitialAt,
    Value<int>? sessionsSinceInterstitial,
    Value<ConsentStatus>? consentStatus,
    Value<bool>? adsRemoved,
    Value<int>? rowid,
  }) {
    return AdStatesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastInterstitialAt: lastInterstitialAt ?? this.lastInterstitialAt,
      sessionsSinceInterstitial:
          sessionsSinceInterstitial ?? this.sessionsSinceInterstitial,
      consentStatus: consentStatus ?? this.consentStatus,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $AdStatesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $AdStatesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (lastInterstitialAt.present) {
      map['last_interstitial_at'] = Variable<int>(
        $AdStatesTable.$converterlastInterstitialAtn.toSql(
          lastInterstitialAt.value,
        ),
      );
    }
    if (sessionsSinceInterstitial.present) {
      map['sessions_since_interstitial'] = Variable<int>(
        sessionsSinceInterstitial.value,
      );
    }
    if (consentStatus.present) {
      map['consent_status'] = Variable<String>(
        $AdStatesTable.$converterconsentStatus.toSql(consentStatus.value),
      );
    }
    if (adsRemoved.present) {
      map['ads_removed'] = Variable<bool>(adsRemoved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdStatesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastInterstitialAt: $lastInterstitialAt, ')
          ..write('sessionsSinceInterstitial: $sessionsSinceInterstitial, ')
          ..write('consentStatus: $consentStatus, ')
          ..write('adsRemoved: $adsRemoved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $StrengthRoutinesTable strengthRoutines = $StrengthRoutinesTable(
    this,
  );
  late final $RoutineExercisesTable routineExercises = $RoutineExercisesTable(
    this,
  );
  late final $RoutineSetTargetsTable routineSetTargets =
      $RoutineSetTargetsTable(this);
  late final $IntervalWorkoutsTable intervalWorkouts = $IntervalWorkoutsTable(
    this,
  );
  late final $IntervalBlocksTable intervalBlocks = $IntervalBlocksTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SessionExercisesTable sessionExercises = $SessionExercisesTable(
    this,
  );
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final $IntervalPhaseLogsTable intervalPhaseLogs =
      $IntervalPhaseLogsTable(this);
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $PlanDaysTable planDays = $PlanDaysTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AdStatesTable adStates = $AdStatesTable(this);
  late final Index idxExerciseNormalizedName = Index(
    'idx_exercise_normalized_name',
    'CREATE INDEX idx_exercise_normalized_name ON exercise (normalized_name)',
  );
  late final Index idxExerciseMuscle = Index(
    'idx_exercise_muscle',
    'CREATE INDEX idx_exercise_muscle ON exercise (primary_muscle)',
  );
  late final Index idxRoutineExerciseRoutineOrder = Index(
    'idx_routine_exercise_routine_order',
    'CREATE INDEX idx_routine_exercise_routine_order ON routine_exercise (routine_id, sort_order)',
  );
  late final Index idxRoutineSetTargetParentOrder = Index(
    'idx_routine_set_target_parent_order',
    'CREATE INDEX idx_routine_set_target_parent_order ON routine_set_target (routine_exercise_id, sort_order)',
  );
  late final Index idxIntervalBlockWorkoutParentOrder = Index(
    'idx_interval_block_workout_parent_order',
    'CREATE INDEX idx_interval_block_workout_parent_order ON interval_block (workout_id, parent_id, sort_order)',
  );
  late final Index idxSessionStartedAt = Index(
    'idx_session_started_at',
    'CREATE INDEX idx_session_started_at ON session (started_at)',
  );
  late final Index idxSessionStatus = Index(
    'idx_session_status',
    'CREATE INDEX idx_session_status ON session (status)',
  );
  late final Index idxSessionExerciseExercise = Index(
    'idx_session_exercise_exercise',
    'CREATE INDEX idx_session_exercise_exercise ON session_exercise (exercise_id)',
  );
  late final Index idxSessionExerciseSession = Index(
    'idx_session_exercise_session',
    'CREATE INDEX idx_session_exercise_session ON session_exercise (session_id, sort_order)',
  );
  late final Index idxSetLogExercise = Index(
    'idx_set_log_exercise',
    'CREATE INDEX idx_set_log_exercise ON set_log (exercise_id)',
  );
  late final Index idxSetLogSession = Index(
    'idx_set_log_session',
    'CREATE INDEX idx_set_log_session ON set_log (session_id)',
  );
  late final Index idxSetLogSessionExerciseOrder = Index(
    'idx_set_log_session_exercise_order',
    'CREATE INDEX idx_set_log_session_exercise_order ON set_log (session_exercise_id, sort_order)',
  );
  late final Index idxIntervalPhaseLogSession = Index(
    'idx_interval_phase_log_session',
    'CREATE INDEX idx_interval_phase_log_session ON interval_phase_log (session_id, sort_order)',
  );
  late final Index idxPersonalRecordExerciseType = Index(
    'idx_personal_record_exercise_type',
    'CREATE UNIQUE INDEX idx_personal_record_exercise_type ON personal_record (exercise_id, type)',
  );
  late final ExercisesDao exercisesDao = ExercisesDao(this as AppDatabase);
  late final RoutinesDao routinesDao = RoutinesDao(this as AppDatabase);
  late final IntervalWorkoutsDao intervalWorkoutsDao = IntervalWorkoutsDao(
    this as AppDatabase,
  );
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  late final RecordsDao recordsDao = RecordsDao(this as AppDatabase);
  late final PlanDao planDao = PlanDao(this as AppDatabase);
  late final AdStateDao adStateDao = AdStateDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    strengthRoutines,
    routineExercises,
    routineSetTargets,
    intervalWorkouts,
    intervalBlocks,
    sessions,
    sessionExercises,
    setLogs,
    intervalPhaseLogs,
    personalRecords,
    planDays,
    reminders,
    adStates,
    idxExerciseNormalizedName,
    idxExerciseMuscle,
    idxRoutineExerciseRoutineOrder,
    idxRoutineSetTargetParentOrder,
    idxIntervalBlockWorkoutParentOrder,
    idxSessionStartedAt,
    idxSessionStatus,
    idxSessionExerciseExercise,
    idxSessionExerciseSession,
    idxSetLogExercise,
    idxSetLogSession,
    idxSetLogSessionExerciseOrder,
    idxIntervalPhaseLogSession,
    idxPersonalRecordExerciseType,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'strength_routine',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_exercise', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_exercise',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_set_target', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'interval_workout',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interval_block', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'interval_block',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interval_block', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercise', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session_exercise',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_log', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('set_log', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interval_phase_log', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'exercise',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_record', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('personal_record', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String name,
      required String normalizedName,
      required ExerciseLogType logType,
      required Muscle primaryMuscle,
      Value<Equipment?> equipment,
      Value<double?> incrementValue,
      Value<WeightUnit?> incrementUnit,
      Value<int?> incrementGrams,
      Value<int?> defaultRestSeconds,
      Value<bool> isCustom,
      Value<int> rowid,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> name,
      Value<String> normalizedName,
      Value<ExerciseLogType> logType,
      Value<Muscle> primaryMuscle,
      Value<Equipment?> equipment,
      Value<double?> incrementValue,
      Value<WeightUnit?> incrementUnit,
      Value<int?> incrementGrams,
      Value<int?> defaultRestSeconds,
      Value<bool> isCustom,
      Value<int> rowid,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'exercise__id__routine_exercise__exercise_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'exercise__id__session_exercise__exercise_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'exercise__id__set_log__exercise_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PersonalRecordsTable, List<PersonalRecord>>
  _personalRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalRecords,
    aliasName: 'exercise__id__personal_record__exercise_id',
  );

  $$PersonalRecordsTableProcessedTableManager get personalRecordsRefs {
    final manager = $$PersonalRecordsTableTableManager(
      $_db,
      $_db.personalRecords,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personalRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ExerciseLogType, ExerciseLogType, String>
  get logType => $composableBuilder(
    column: $table.logType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Muscle, Muscle, String> get primaryMuscle =>
      $composableBuilder(
        column: $table.primaryMuscle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Equipment?, Equipment, String> get equipment =>
      $composableBuilder(
        column: $table.equipment,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get incrementValue => $composableBuilder(
    column: $table.incrementValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeightUnit?, WeightUnit, String>
  get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get incrementGrams => $composableBuilder(
    column: $table.incrementGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> personalRecordsRefs(
    Expression<bool> Function($$PersonalRecordsTableFilterComposer f) f,
  ) {
    final $$PersonalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logType => $composableBuilder(
    column: $table.logType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscle => $composableBuilder(
    column: $table.primaryMuscle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get incrementValue => $composableBuilder(
    column: $table.incrementValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incrementUnit => $composableBuilder(
    column: $table.incrementUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incrementGrams => $composableBuilder(
    column: $table.incrementGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalizedName => $composableBuilder(
    column: $table.normalizedName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ExerciseLogType, String> get logType =>
      $composableBuilder(column: $table.logType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Muscle, String> get primaryMuscle =>
      $composableBuilder(
        column: $table.primaryMuscle,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Equipment?, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<double> get incrementValue => $composableBuilder(
    column: $table.incrementValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeightUnit?, String> get incrementUnit =>
      $composableBuilder(
        column: $table.incrementUnit,
        builder: (column) => column,
      );

  GeneratedColumn<int> get incrementGrams => $composableBuilder(
    column: $table.incrementGrams,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultRestSeconds => $composableBuilder(
    column: $table.defaultRestSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> personalRecordsRefs<T extends Object>(
    Expression<T> Function($$PersonalRecordsTableAnnotationComposer a) f,
  ) {
    final $$PersonalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool routineExercisesRefs,
            bool sessionExercisesRefs,
            bool setLogsRefs,
            bool personalRecordsRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalizedName = const Value.absent(),
                Value<ExerciseLogType> logType = const Value.absent(),
                Value<Muscle> primaryMuscle = const Value.absent(),
                Value<Equipment?> equipment = const Value.absent(),
                Value<double?> incrementValue = const Value.absent(),
                Value<WeightUnit?> incrementUnit = const Value.absent(),
                Value<int?> incrementGrams = const Value.absent(),
                Value<int?> defaultRestSeconds = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                normalizedName: normalizedName,
                logType: logType,
                primaryMuscle: primaryMuscle,
                equipment: equipment,
                incrementValue: incrementValue,
                incrementUnit: incrementUnit,
                incrementGrams: incrementGrams,
                defaultRestSeconds: defaultRestSeconds,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String name,
                required String normalizedName,
                required ExerciseLogType logType,
                required Muscle primaryMuscle,
                Value<Equipment?> equipment = const Value.absent(),
                Value<double?> incrementValue = const Value.absent(),
                Value<WeightUnit?> incrementUnit = const Value.absent(),
                Value<int?> incrementGrams = const Value.absent(),
                Value<int?> defaultRestSeconds = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                normalizedName: normalizedName,
                logType: logType,
                primaryMuscle: primaryMuscle,
                equipment: equipment,
                incrementValue: incrementValue,
                incrementUnit: incrementUnit,
                incrementGrams: incrementGrams,
                defaultRestSeconds: defaultRestSeconds,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineExercisesRefs = false,
                sessionExercisesRefs = false,
                setLogsRefs = false,
                personalRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineExercisesRefs) db.routineExercises,
                    if (sessionExercisesRefs) db.sessionExercises,
                    if (setLogsRefs) db.setLogs,
                    if (personalRecordsRefs) db.personalRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          RoutineExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._routineExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (setLogsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SetLog
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (personalRecordsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          PersonalRecord
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._personalRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).personalRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool routineExercisesRefs,
        bool sessionExercisesRefs,
        bool setLogsRefs,
        bool personalRecordsRefs,
      })
    >;
typedef $$StrengthRoutinesTableCreateCompanionBuilder =
    StrengthRoutinesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String name,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$StrengthRoutinesTableUpdateCompanionBuilder =
    StrengthRoutinesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> name,
      Value<String?> notes,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$StrengthRoutinesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StrengthRoutinesTable, StrengthRoutine> {
  $$StrengthRoutinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'strength_routine__id__routine_exercise__routine_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StrengthRoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $StrengthRoutinesTable> {
  $$StrengthRoutinesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StrengthRoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $StrengthRoutinesTable> {
  $$StrengthRoutinesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StrengthRoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StrengthRoutinesTable> {
  $$StrengthRoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StrengthRoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StrengthRoutinesTable,
          StrengthRoutine,
          $$StrengthRoutinesTableFilterComposer,
          $$StrengthRoutinesTableOrderingComposer,
          $$StrengthRoutinesTableAnnotationComposer,
          $$StrengthRoutinesTableCreateCompanionBuilder,
          $$StrengthRoutinesTableUpdateCompanionBuilder,
          (StrengthRoutine, $$StrengthRoutinesTableReferences),
          StrengthRoutine,
          PrefetchHooks Function({bool routineExercisesRefs})
        > {
  $$StrengthRoutinesTableTableManager(
    _$AppDatabase db,
    $StrengthRoutinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StrengthRoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StrengthRoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StrengthRoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StrengthRoutinesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StrengthRoutinesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                notes: notes,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StrengthRoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineExercisesRefs) db.routineExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineExercisesRefs)
                    await $_getPrefetchedData<
                      StrengthRoutine,
                      $StrengthRoutinesTable,
                      RoutineExercise
                    >(
                      currentTable: table,
                      referencedTable: $$StrengthRoutinesTableReferences
                          ._routineExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StrengthRoutinesTableReferences(
                            db,
                            table,
                            p0,
                          ).routineExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.routineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StrengthRoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StrengthRoutinesTable,
      StrengthRoutine,
      $$StrengthRoutinesTableFilterComposer,
      $$StrengthRoutinesTableOrderingComposer,
      $$StrengthRoutinesTableAnnotationComposer,
      $$StrengthRoutinesTableCreateCompanionBuilder,
      $$StrengthRoutinesTableUpdateCompanionBuilder,
      (StrengthRoutine, $$StrengthRoutinesTableReferences),
      StrengthRoutine,
      PrefetchHooks Function({bool routineExercisesRefs})
    >;
typedef $$RoutineExercisesTableCreateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String routineId,
      required String exerciseId,
      required int sortOrder,
      Value<int?> restSeconds,
      Value<int> rowid,
    });
typedef $$RoutineExercisesTableUpdateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> routineId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int?> restSeconds,
      Value<int> rowid,
    });

final class $$RoutineExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineExercisesTable, RoutineExercise> {
  $$RoutineExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StrengthRoutinesTable _routineIdTable(_$AppDatabase db) => db
      .strengthRoutines
      .createAlias('routine_exercise__routine_id__strength_routine__id');

  $$StrengthRoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$StrengthRoutinesTableTableManager(
      $_db,
      $_db.strengthRoutines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('routine_exercise__exercise_id__exercise__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RoutineSetTargetsTable, List<RoutineSetTarget>>
  _routineSetTargetsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.routineSetTargets,
        aliasName:
            'routine_exercise__id__routine_set_target__routine_exercise_id',
      );

  $$RoutineSetTargetsTableProcessedTableManager get routineSetTargetsRefs {
    final manager =
        $$RoutineSetTargetsTableTableManager(
          $_db,
          $_db.routineSetTargets,
        ).filter(
          (f) => f.routineExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _routineSetTargetsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$StrengthRoutinesTableFilterComposer get routineId {
    final $$StrengthRoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.strengthRoutines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthRoutinesTableFilterComposer(
            $db: $db,
            $table: $db.strengthRoutines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> routineSetTargetsRefs(
    Expression<bool> Function($$RoutineSetTargetsTableFilterComposer f) f,
  ) {
    final $$RoutineSetTargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineSetTargets,
      getReferencedColumn: (t) => t.routineExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineSetTargetsTableFilterComposer(
            $db: $db,
            $table: $db.routineSetTargets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$StrengthRoutinesTableOrderingComposer get routineId {
    final $$StrengthRoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.strengthRoutines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthRoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.strengthRoutines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  $$StrengthRoutinesTableAnnotationComposer get routineId {
    final $$StrengthRoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.strengthRoutines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StrengthRoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.strengthRoutines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> routineSetTargetsRefs<T extends Object>(
    Expression<T> Function($$RoutineSetTargetsTableAnnotationComposer a) f,
  ) {
    final $$RoutineSetTargetsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.routineSetTargets,
          getReferencedColumn: (t) => t.routineExerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RoutineSetTargetsTableAnnotationComposer(
                $db: $db,
                $table: $db.routineSetTargets,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RoutineExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineExercisesTable,
          RoutineExercise,
          $$RoutineExercisesTableFilterComposer,
          $$RoutineExercisesTableOrderingComposer,
          $$RoutineExercisesTableAnnotationComposer,
          $$RoutineExercisesTableCreateCompanionBuilder,
          $$RoutineExercisesTableUpdateCompanionBuilder,
          (RoutineExercise, $$RoutineExercisesTableReferences),
          RoutineExercise,
          PrefetchHooks Function({
            bool routineId,
            bool exerciseId,
            bool routineSetTargetsRefs,
          })
        > {
  $$RoutineExercisesTableTableManager(
    _$AppDatabase db,
    $RoutineExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                routineId: routineId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                restSeconds: restSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String routineId,
                required String exerciseId,
                required int sortOrder,
                Value<int?> restSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                routineId: routineId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                restSeconds: restSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                exerciseId = false,
                routineSetTargetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineSetTargetsRefs) db.routineSetTargets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.routineId,
                                    referencedTable:
                                        $$RoutineExercisesTableReferences
                                            ._routineIdTable(db),
                                    referencedColumn:
                                        $$RoutineExercisesTableReferences
                                            ._routineIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$RoutineExercisesTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$RoutineExercisesTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineSetTargetsRefs)
                        await $_getPrefetchedData<
                          RoutineExercise,
                          $RoutineExercisesTable,
                          RoutineSetTarget
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineExercisesTableReferences
                              ._routineSetTargetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineSetTargetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutineExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineExercisesTable,
      RoutineExercise,
      $$RoutineExercisesTableFilterComposer,
      $$RoutineExercisesTableOrderingComposer,
      $$RoutineExercisesTableAnnotationComposer,
      $$RoutineExercisesTableCreateCompanionBuilder,
      $$RoutineExercisesTableUpdateCompanionBuilder,
      (RoutineExercise, $$RoutineExercisesTableReferences),
      RoutineExercise,
      PrefetchHooks Function({
        bool routineId,
        bool exerciseId,
        bool routineSetTargetsRefs,
      })
    >;
typedef $$RoutineSetTargetsTableCreateCompanionBuilder =
    RoutineSetTargetsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String routineExerciseId,
      required int sortOrder,
      Value<SetType> setType,
      Value<int?> reps,
      Value<double?> weightValue,
      Value<WeightUnit?> weightUnit,
      Value<int?> weightGrams,
      Value<double?> rpe,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<int> rowid,
    });
typedef $$RoutineSetTargetsTableUpdateCompanionBuilder =
    RoutineSetTargetsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> routineExerciseId,
      Value<int> sortOrder,
      Value<SetType> setType,
      Value<int?> reps,
      Value<double?> weightValue,
      Value<WeightUnit?> weightUnit,
      Value<int?> weightGrams,
      Value<double?> rpe,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<int> rowid,
    });

final class $$RoutineSetTargetsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineSetTargetsTable,
          RoutineSetTarget
        > {
  $$RoutineSetTargetsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutineExercisesTable _routineExerciseIdTable(_$AppDatabase db) =>
      db.routineExercises.createAlias(
        'routine_set_target__routine_exercise_id__routine_exercise__id',
      );

  $$RoutineExercisesTableProcessedTableManager get routineExerciseId {
    final $_column = $_itemColumn<String>('routine_exercise_id')!;

    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineSetTargetsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineSetTargetsTable> {
  $$RoutineSetTargetsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetType, SetType, String> get setType =>
      $composableBuilder(
        column: $table.setType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeightUnit?, WeightUnit, String>
  get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutineExercisesTableFilterComposer get routineExerciseId {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineSetTargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineSetTargetsTable> {
  $$RoutineSetTargetsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutineExercisesTableOrderingComposer get routineExerciseId {
    final $$RoutineExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineSetTargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineSetTargetsTable> {
  $$RoutineSetTargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetType, String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeightUnit?, String> get weightUnit =>
      $composableBuilder(
        column: $table.weightUnit,
        builder: (column) => column,
      );

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  $$RoutineExercisesTableAnnotationComposer get routineExerciseId {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineSetTargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineSetTargetsTable,
          RoutineSetTarget,
          $$RoutineSetTargetsTableFilterComposer,
          $$RoutineSetTargetsTableOrderingComposer,
          $$RoutineSetTargetsTableAnnotationComposer,
          $$RoutineSetTargetsTableCreateCompanionBuilder,
          $$RoutineSetTargetsTableUpdateCompanionBuilder,
          (RoutineSetTarget, $$RoutineSetTargetsTableReferences),
          RoutineSetTarget,
          PrefetchHooks Function({bool routineExerciseId})
        > {
  $$RoutineSetTargetsTableTableManager(
    _$AppDatabase db,
    $RoutineSetTargetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineSetTargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineSetTargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineSetTargetsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> routineExerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<SetType> setType = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weightValue = const Value.absent(),
                Value<WeightUnit?> weightUnit = const Value.absent(),
                Value<int?> weightGrams = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineSetTargetsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                routineExerciseId: routineExerciseId,
                sortOrder: sortOrder,
                setType: setType,
                reps: reps,
                weightValue: weightValue,
                weightUnit: weightUnit,
                weightGrams: weightGrams,
                rpe: rpe,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String routineExerciseId,
                required int sortOrder,
                Value<SetType> setType = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weightValue = const Value.absent(),
                Value<WeightUnit?> weightUnit = const Value.absent(),
                Value<int?> weightGrams = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineSetTargetsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                routineExerciseId: routineExerciseId,
                sortOrder: sortOrder,
                setType: setType,
                reps: reps,
                weightValue: weightValue,
                weightUnit: weightUnit,
                weightGrams: weightGrams,
                rpe: rpe,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RoutineSetTargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.routineExerciseId,
                                referencedTable:
                                    $$RoutineSetTargetsTableReferences
                                        ._routineExerciseIdTable(db),
                                referencedColumn:
                                    $$RoutineSetTargetsTableReferences
                                        ._routineExerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineSetTargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineSetTargetsTable,
      RoutineSetTarget,
      $$RoutineSetTargetsTableFilterComposer,
      $$RoutineSetTargetsTableOrderingComposer,
      $$RoutineSetTargetsTableAnnotationComposer,
      $$RoutineSetTargetsTableCreateCompanionBuilder,
      $$RoutineSetTargetsTableUpdateCompanionBuilder,
      (RoutineSetTarget, $$RoutineSetTargetsTableReferences),
      RoutineSetTarget,
      PrefetchHooks Function({bool routineExerciseId})
    >;
typedef $$IntervalWorkoutsTableCreateCompanionBuilder =
    IntervalWorkoutsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required String name,
      Value<int> prepareSeconds,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$IntervalWorkoutsTableUpdateCompanionBuilder =
    IntervalWorkoutsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<String> name,
      Value<int> prepareSeconds,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$IntervalWorkoutsTableReferences
    extends
        BaseReferences<_$AppDatabase, $IntervalWorkoutsTable, IntervalWorkout> {
  $$IntervalWorkoutsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$IntervalBlocksTable, List<IntervalBlock>>
  _intervalBlocksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.intervalBlocks,
    aliasName: 'interval_workout__id__interval_block__workout_id',
  );

  $$IntervalBlocksTableProcessedTableManager get intervalBlocksRefs {
    final manager = $$IntervalBlocksTableTableManager(
      $_db,
      $_db.intervalBlocks,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_intervalBlocksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IntervalWorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $IntervalWorkoutsTable> {
  $$IntervalWorkoutsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepareSeconds => $composableBuilder(
    column: $table.prepareSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> intervalBlocksRefs(
    Expression<bool> Function($$IntervalBlocksTableFilterComposer f) f,
  ) {
    final $$IntervalBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intervalBlocks,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalBlocksTableFilterComposer(
            $db: $db,
            $table: $db.intervalBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IntervalWorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntervalWorkoutsTable> {
  $$IntervalWorkoutsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepareSeconds => $composableBuilder(
    column: $table.prepareSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IntervalWorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntervalWorkoutsTable> {
  $$IntervalWorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get prepareSeconds => $composableBuilder(
    column: $table.prepareSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> intervalBlocksRefs<T extends Object>(
    Expression<T> Function($$IntervalBlocksTableAnnotationComposer a) f,
  ) {
    final $$IntervalBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intervalBlocks,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.intervalBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IntervalWorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntervalWorkoutsTable,
          IntervalWorkout,
          $$IntervalWorkoutsTableFilterComposer,
          $$IntervalWorkoutsTableOrderingComposer,
          $$IntervalWorkoutsTableAnnotationComposer,
          $$IntervalWorkoutsTableCreateCompanionBuilder,
          $$IntervalWorkoutsTableUpdateCompanionBuilder,
          (IntervalWorkout, $$IntervalWorkoutsTableReferences),
          IntervalWorkout,
          PrefetchHooks Function({bool intervalBlocksRefs})
        > {
  $$IntervalWorkoutsTableTableManager(
    _$AppDatabase db,
    $IntervalWorkoutsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntervalWorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntervalWorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntervalWorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> prepareSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalWorkoutsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                prepareSeconds: prepareSeconds,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required String name,
                Value<int> prepareSeconds = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalWorkoutsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                name: name,
                prepareSeconds: prepareSeconds,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IntervalWorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({intervalBlocksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (intervalBlocksRefs) db.intervalBlocks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (intervalBlocksRefs)
                    await $_getPrefetchedData<
                      IntervalWorkout,
                      $IntervalWorkoutsTable,
                      IntervalBlock
                    >(
                      currentTable: table,
                      referencedTable: $$IntervalWorkoutsTableReferences
                          ._intervalBlocksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$IntervalWorkoutsTableReferences(
                            db,
                            table,
                            p0,
                          ).intervalBlocksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IntervalWorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntervalWorkoutsTable,
      IntervalWorkout,
      $$IntervalWorkoutsTableFilterComposer,
      $$IntervalWorkoutsTableOrderingComposer,
      $$IntervalWorkoutsTableAnnotationComposer,
      $$IntervalWorkoutsTableCreateCompanionBuilder,
      $$IntervalWorkoutsTableUpdateCompanionBuilder,
      (IntervalWorkout, $$IntervalWorkoutsTableReferences),
      IntervalWorkout,
      PrefetchHooks Function({bool intervalBlocksRefs})
    >;
typedef $$IntervalBlocksTableCreateCompanionBuilder =
    IntervalBlocksCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String workoutId,
      Value<String?> parentId,
      required int sortOrder,
      required IntervalBlockKind kind,
      Value<PhaseType?> phaseType,
      Value<String?> label,
      Value<int?> durationSeconds,
      Value<int> rounds,
      Value<int> rowid,
    });
typedef $$IntervalBlocksTableUpdateCompanionBuilder =
    IntervalBlocksCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> workoutId,
      Value<String?> parentId,
      Value<int> sortOrder,
      Value<IntervalBlockKind> kind,
      Value<PhaseType?> phaseType,
      Value<String?> label,
      Value<int?> durationSeconds,
      Value<int> rounds,
      Value<int> rowid,
    });

final class $$IntervalBlocksTableReferences
    extends BaseReferences<_$AppDatabase, $IntervalBlocksTable, IntervalBlock> {
  $$IntervalBlocksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IntervalWorkoutsTable _workoutIdTable(_$AppDatabase db) => db
      .intervalWorkouts
      .createAlias('interval_block__workout_id__interval_workout__id');

  $$IntervalWorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$IntervalWorkoutsTableTableManager(
      $_db,
      $_db.intervalWorkouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IntervalBlocksTable _parentIdTable(_$AppDatabase db) => db
      .intervalBlocks
      .createAlias('interval_block__parent_id__interval_block__id');

  $$IntervalBlocksTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$IntervalBlocksTableTableManager(
      $_db,
      $_db.intervalBlocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IntervalBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $IntervalBlocksTable> {
  $$IntervalBlocksTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IntervalBlockKind, IntervalBlockKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<PhaseType?, PhaseType, String> get phaseType =>
      $composableBuilder(
        column: $table.phaseType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnFilters(column),
  );

  $$IntervalWorkoutsTableFilterComposer get workoutId {
    final $$IntervalWorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.intervalWorkouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalWorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.intervalWorkouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IntervalBlocksTableFilterComposer get parentId {
    final $$IntervalBlocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.intervalBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalBlocksTableFilterComposer(
            $db: $db,
            $table: $db.intervalBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $IntervalBlocksTable> {
  $$IntervalBlocksTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseType => $composableBuilder(
    column: $table.phaseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnOrderings(column),
  );

  $$IntervalWorkoutsTableOrderingComposer get workoutId {
    final $$IntervalWorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.intervalWorkouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalWorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.intervalWorkouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IntervalBlocksTableOrderingComposer get parentId {
    final $$IntervalBlocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.intervalBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalBlocksTableOrderingComposer(
            $db: $db,
            $table: $db.intervalBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntervalBlocksTable> {
  $$IntervalBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IntervalBlockKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PhaseType?, String> get phaseType =>
      $composableBuilder(column: $table.phaseType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rounds =>
      $composableBuilder(column: $table.rounds, builder: (column) => column);

  $$IntervalWorkoutsTableAnnotationComposer get workoutId {
    final $$IntervalWorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.intervalWorkouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalWorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.intervalWorkouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IntervalBlocksTableAnnotationComposer get parentId {
    final $$IntervalBlocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.intervalBlocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalBlocksTableAnnotationComposer(
            $db: $db,
            $table: $db.intervalBlocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalBlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntervalBlocksTable,
          IntervalBlock,
          $$IntervalBlocksTableFilterComposer,
          $$IntervalBlocksTableOrderingComposer,
          $$IntervalBlocksTableAnnotationComposer,
          $$IntervalBlocksTableCreateCompanionBuilder,
          $$IntervalBlocksTableUpdateCompanionBuilder,
          (IntervalBlock, $$IntervalBlocksTableReferences),
          IntervalBlock,
          PrefetchHooks Function({bool workoutId, bool parentId})
        > {
  $$IntervalBlocksTableTableManager(
    _$AppDatabase db,
    $IntervalBlocksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntervalBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntervalBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntervalBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<IntervalBlockKind> kind = const Value.absent(),
                Value<PhaseType?> phaseType = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int> rounds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalBlocksCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                workoutId: workoutId,
                parentId: parentId,
                sortOrder: sortOrder,
                kind: kind,
                phaseType: phaseType,
                label: label,
                durationSeconds: durationSeconds,
                rounds: rounds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String workoutId,
                Value<String?> parentId = const Value.absent(),
                required int sortOrder,
                required IntervalBlockKind kind,
                Value<PhaseType?> phaseType = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<int> rounds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalBlocksCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                workoutId: workoutId,
                parentId: parentId,
                sortOrder: sortOrder,
                kind: kind,
                phaseType: phaseType,
                label: label,
                durationSeconds: durationSeconds,
                rounds: rounds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IntervalBlocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutId = false, parentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutId,
                                referencedTable: $$IntervalBlocksTableReferences
                                    ._workoutIdTable(db),
                                referencedColumn:
                                    $$IntervalBlocksTableReferences
                                        ._workoutIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (parentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.parentId,
                                referencedTable: $$IntervalBlocksTableReferences
                                    ._parentIdTable(db),
                                referencedColumn:
                                    $$IntervalBlocksTableReferences
                                        ._parentIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IntervalBlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntervalBlocksTable,
      IntervalBlock,
      $$IntervalBlocksTableFilterComposer,
      $$IntervalBlocksTableOrderingComposer,
      $$IntervalBlocksTableAnnotationComposer,
      $$IntervalBlocksTableCreateCompanionBuilder,
      $$IntervalBlocksTableUpdateCompanionBuilder,
      (IntervalBlock, $$IntervalBlocksTableReferences),
      IntervalBlock,
      PrefetchHooks Function({bool workoutId, bool parentId})
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      required SessionKind kind,
      Value<String?> templateId,
      required SessionStatus status,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<String?> timeZoneId,
      required int utcOffsetMinutes,
      Value<int> pausedSeconds,
      Value<Map<String, Object?>?> templateSnapshot,
      Value<int?> perceivedEffort,
      Value<String?> note,
      Value<int?> checkpointPhaseIndex,
      Value<int?> checkpointElapsedMs,
      Value<DateTime?> checkpointAt,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<SessionKind> kind,
      Value<String?> templateId,
      Value<SessionStatus> status,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String?> timeZoneId,
      Value<int> utcOffsetMinutes,
      Value<int> pausedSeconds,
      Value<Map<String, Object?>?> templateSnapshot,
      Value<int?> perceivedEffort,
      Value<String?> note,
      Value<int?> checkpointPhaseIndex,
      Value<int?> checkpointElapsedMs,
      Value<DateTime?> checkpointAt,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'session__id__session_exercise__session_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'session__id__set_log__session_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager(
      $_db,
      $_db.setLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IntervalPhaseLogsTable, List<IntervalPhaseLog>>
  _intervalPhaseLogsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.intervalPhaseLogs,
        aliasName: 'session__id__interval_phase_log__session_id',
      );

  $$IntervalPhaseLogsTableProcessedTableManager get intervalPhaseLogsRefs {
    final manager = $$IntervalPhaseLogsTableTableManager(
      $_db,
      $_db.intervalPhaseLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _intervalPhaseLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PersonalRecordsTable, List<PersonalRecord>>
  _personalRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalRecords,
    aliasName: 'session__id__personal_record__session_id',
  );

  $$PersonalRecordsTableProcessedTableManager get personalRecordsRefs {
    final manager = $$PersonalRecordsTableTableManager(
      $_db,
      $_db.personalRecords,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personalRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SessionKind, SessionKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get startedAt =>
      $composableBuilder(
        column: $table.startedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get endedAt =>
      $composableBuilder(
        column: $table.endedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pausedSeconds => $composableBuilder(
    column: $table.pausedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get templateSnapshot => $composableBuilder(
    column: $table.templateSnapshot,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkpointPhaseIndex => $composableBuilder(
    column: $table.checkpointPhaseIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get checkpointElapsedMs => $composableBuilder(
    column: $table.checkpointElapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get checkpointAt =>
      $composableBuilder(
        column: $table.checkpointAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> intervalPhaseLogsRefs(
    Expression<bool> Function($$IntervalPhaseLogsTableFilterComposer f) f,
  ) {
    final $$IntervalPhaseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.intervalPhaseLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntervalPhaseLogsTableFilterComposer(
            $db: $db,
            $table: $db.intervalPhaseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> personalRecordsRefs(
    Expression<bool> Function($$PersonalRecordsTableFilterComposer f) f,
  ) {
    final $$PersonalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pausedSeconds => $composableBuilder(
    column: $table.pausedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateSnapshot => $composableBuilder(
    column: $table.templateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkpointPhaseIndex => $composableBuilder(
    column: $table.checkpointPhaseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkpointElapsedMs => $composableBuilder(
    column: $table.checkpointElapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get checkpointAt => $composableBuilder(
    column: $table.checkpointAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get archivedAt =>
      $composableBuilder(
        column: $table.archivedAt,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SessionKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get timeZoneId => $composableBuilder(
    column: $table.timeZoneId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get utcOffsetMinutes => $composableBuilder(
    column: $table.utcOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pausedSeconds => $composableBuilder(
    column: $table.pausedSeconds,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  get templateSnapshot => $composableBuilder(
    column: $table.templateSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perceivedEffort => $composableBuilder(
    column: $table.perceivedEffort,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get checkpointPhaseIndex => $composableBuilder(
    column: $table.checkpointPhaseIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get checkpointElapsedMs => $composableBuilder(
    column: $table.checkpointElapsedMs,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, int> get checkpointAt =>
      $composableBuilder(
        column: $table.checkpointAt,
        builder: (column) => column,
      );

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> intervalPhaseLogsRefs<T extends Object>(
    Expression<T> Function($$IntervalPhaseLogsTableAnnotationComposer a) f,
  ) {
    final $$IntervalPhaseLogsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.intervalPhaseLogs,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IntervalPhaseLogsTableAnnotationComposer(
                $db: $db,
                $table: $db.intervalPhaseLogs,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> personalRecordsRefs<T extends Object>(
    Expression<T> Function($$PersonalRecordsTableAnnotationComposer a) f,
  ) {
    final $$PersonalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool sessionExercisesRefs,
            bool setLogsRefs,
            bool intervalPhaseLogsRefs,
            bool personalRecordsRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<SessionKind> kind = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> timeZoneId = const Value.absent(),
                Value<int> utcOffsetMinutes = const Value.absent(),
                Value<int> pausedSeconds = const Value.absent(),
                Value<Map<String, Object?>?> templateSnapshot =
                    const Value.absent(),
                Value<int?> perceivedEffort = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> checkpointPhaseIndex = const Value.absent(),
                Value<int?> checkpointElapsedMs = const Value.absent(),
                Value<DateTime?> checkpointAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                kind: kind,
                templateId: templateId,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                timeZoneId: timeZoneId,
                utcOffsetMinutes: utcOffsetMinutes,
                pausedSeconds: pausedSeconds,
                templateSnapshot: templateSnapshot,
                perceivedEffort: perceivedEffort,
                note: note,
                checkpointPhaseIndex: checkpointPhaseIndex,
                checkpointElapsedMs: checkpointElapsedMs,
                checkpointAt: checkpointAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required SessionKind kind,
                Value<String?> templateId = const Value.absent(),
                required SessionStatus status,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String?> timeZoneId = const Value.absent(),
                required int utcOffsetMinutes,
                Value<int> pausedSeconds = const Value.absent(),
                Value<Map<String, Object?>?> templateSnapshot =
                    const Value.absent(),
                Value<int?> perceivedEffort = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> checkpointPhaseIndex = const Value.absent(),
                Value<int?> checkpointElapsedMs = const Value.absent(),
                Value<DateTime?> checkpointAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                kind: kind,
                templateId: templateId,
                status: status,
                startedAt: startedAt,
                endedAt: endedAt,
                timeZoneId: timeZoneId,
                utcOffsetMinutes: utcOffsetMinutes,
                pausedSeconds: pausedSeconds,
                templateSnapshot: templateSnapshot,
                perceivedEffort: perceivedEffort,
                note: note,
                checkpointPhaseIndex: checkpointPhaseIndex,
                checkpointElapsedMs: checkpointElapsedMs,
                checkpointAt: checkpointAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionExercisesRefs = false,
                setLogsRefs = false,
                intervalPhaseLogsRefs = false,
                personalRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionExercisesRefs) db.sessionExercises,
                    if (setLogsRefs) db.setLogs,
                    if (intervalPhaseLogsRefs) db.intervalPhaseLogs,
                    if (personalRecordsRefs) db.personalRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (setLogsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          SetLog
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (intervalPhaseLogsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          IntervalPhaseLog
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._intervalPhaseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).intervalPhaseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (personalRecordsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          PersonalRecord
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._personalRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).personalRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool sessionExercisesRefs,
        bool setLogsRefs,
        bool intervalPhaseLogsRefs,
        bool personalRecordsRefs,
      })
    >;
typedef $$SessionExercisesTableCreateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String sessionId,
      required String exerciseId,
      required int sortOrder,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$SessionExercisesTableUpdateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$SessionExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SessionExercisesTable, SessionExercise> {
  $$SessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_exercise__session_id__session__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('session_exercise__exercise_id__exercise__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetLogsTable, List<SetLog>> _setLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.setLogs,
    aliasName: 'session_exercise__id__set_log__session_exercise_id',
  );

  $$SetLogsTableProcessedTableManager get setLogsRefs {
    final manager = $$SetLogsTableTableManager($_db, $_db.setLogs).filter(
      (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_setLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setLogsRefs(
    Expression<bool> Function($$SetLogsTableFilterComposer f) f,
  ) {
    final $$SetLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableFilterComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setLogsRefs<T extends Object>(
    Expression<T> Function($$SetLogsTableAnnotationComposer a) f,
  ) {
    final $$SetLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setLogs,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.setLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExercise,
          $$SessionExercisesTableFilterComposer,
          $$SessionExercisesTableOrderingComposer,
          $$SessionExercisesTableAnnotationComposer,
          $$SessionExercisesTableCreateCompanionBuilder,
          $$SessionExercisesTableUpdateCompanionBuilder,
          (SessionExercise, $$SessionExercisesTableReferences),
          SessionExercise,
          PrefetchHooks Function({
            bool sessionId,
            bool exerciseId,
            bool setLogsRefs,
          })
        > {
  $$SessionExercisesTableTableManager(
    _$AppDatabase db,
    $SessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionExercisesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionId: sessionId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String sessionId,
                required String exerciseId,
                required int sortOrder,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionExercisesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionId: sessionId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, exerciseId = false, setLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (setLogsRefs) db.setLogs],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$SessionExercisesTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$SessionExercisesTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$SessionExercisesTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$SessionExercisesTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (setLogsRefs)
                        await $_getPrefetchedData<
                          SessionExercise,
                          $SessionExercisesTable,
                          SetLog
                        >(
                          currentTable: table,
                          referencedTable: $$SessionExercisesTableReferences
                              ._setLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).setLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExercisesTable,
      SessionExercise,
      $$SessionExercisesTableFilterComposer,
      $$SessionExercisesTableOrderingComposer,
      $$SessionExercisesTableAnnotationComposer,
      $$SessionExercisesTableCreateCompanionBuilder,
      $$SessionExercisesTableUpdateCompanionBuilder,
      (SessionExercise, $$SessionExercisesTableReferences),
      SessionExercise,
      PrefetchHooks Function({
        bool sessionId,
        bool exerciseId,
        bool setLogsRefs,
      })
    >;
typedef $$SetLogsTableCreateCompanionBuilder =
    SetLogsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String sessionExerciseId,
      required String sessionId,
      required String exerciseId,
      required int sortOrder,
      Value<SetType> setType,
      Value<double?> weightValue,
      Value<WeightUnit?> weightUnit,
      Value<int?> weightGrams,
      Value<int?> reps,
      Value<double?> rpe,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<bool> completed,
      Value<DateTime?> loggedAt,
      Value<int> rowid,
    });
typedef $$SetLogsTableUpdateCompanionBuilder =
    SetLogsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> sessionExerciseId,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<SetType> setType,
      Value<double?> weightValue,
      Value<WeightUnit?> weightUnit,
      Value<int?> weightGrams,
      Value<int?> reps,
      Value<double?> rpe,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<bool> completed,
      Value<DateTime?> loggedAt,
      Value<int> rowid,
    });

final class $$SetLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SetLogsTable, SetLog> {
  $$SetLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('set_log__session_exercise_id__session_exercise__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<String>('session_exercise_id')!;

    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('set_log__session_id__session__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('set_log__exercise_id__exercise__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetType, SetType, String> get setType =>
      $composableBuilder(
        column: $table.setType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeightUnit?, WeightUnit, String>
  get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get loggedAt =>
      $composableBuilder(
        column: $table.loggedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetType, String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<double> get weightValue => $composableBuilder(
    column: $table.weightValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeightUnit?, String> get weightUnit =>
      $composableBuilder(
        column: $table.weightUnit,
        builder: (column) => column,
      );

  GeneratedColumn<int> get weightGrams => $composableBuilder(
    column: $table.weightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetLogsTable,
          SetLog,
          $$SetLogsTableFilterComposer,
          $$SetLogsTableOrderingComposer,
          $$SetLogsTableAnnotationComposer,
          $$SetLogsTableCreateCompanionBuilder,
          $$SetLogsTableUpdateCompanionBuilder,
          (SetLog, $$SetLogsTableReferences),
          SetLog,
          PrefetchHooks Function({
            bool sessionExerciseId,
            bool sessionId,
            bool exerciseId,
          })
        > {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> sessionExerciseId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<SetType> setType = const Value.absent(),
                Value<double?> weightValue = const Value.absent(),
                Value<WeightUnit?> weightUnit = const Value.absent(),
                Value<int?> weightGrams = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionExerciseId: sessionExerciseId,
                sessionId: sessionId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                setType: setType,
                weightValue: weightValue,
                weightUnit: weightUnit,
                weightGrams: weightGrams,
                reps: reps,
                rpe: rpe,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                completed: completed,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String sessionExerciseId,
                required String sessionId,
                required String exerciseId,
                required int sortOrder,
                Value<SetType> setType = const Value.absent(),
                Value<double?> weightValue = const Value.absent(),
                Value<WeightUnit?> weightUnit = const Value.absent(),
                Value<int?> weightGrams = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> rpe = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime?> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SetLogsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionExerciseId: sessionExerciseId,
                sessionId: sessionId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                setType: setType,
                weightValue: weightValue,
                weightUnit: weightUnit,
                weightGrams: weightGrams,
                reps: reps,
                rpe: rpe,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                completed: completed,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionExerciseId = false,
                sessionId = false,
                exerciseId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionExerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionExerciseId,
                                    referencedTable: $$SetLogsTableReferences
                                        ._sessionExerciseIdTable(db),
                                    referencedColumn: $$SetLogsTableReferences
                                        ._sessionExerciseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable: $$SetLogsTableReferences
                                        ._sessionIdTable(db),
                                    referencedColumn: $$SetLogsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable: $$SetLogsTableReferences
                                        ._exerciseIdTable(db),
                                    referencedColumn: $$SetLogsTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$SetLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetLogsTable,
      SetLog,
      $$SetLogsTableFilterComposer,
      $$SetLogsTableOrderingComposer,
      $$SetLogsTableAnnotationComposer,
      $$SetLogsTableCreateCompanionBuilder,
      $$SetLogsTableUpdateCompanionBuilder,
      (SetLog, $$SetLogsTableReferences),
      SetLog,
      PrefetchHooks Function({
        bool sessionExerciseId,
        bool sessionId,
        bool exerciseId,
      })
    >;
typedef $$IntervalPhaseLogsTableCreateCompanionBuilder =
    IntervalPhaseLogsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String sessionId,
      required int sortOrder,
      required PhaseType phaseType,
      Value<String?> label,
      Value<int> round,
      required int plannedSeconds,
      required int actualSeconds,
      Value<bool> skipped,
      Value<int> rowid,
    });
typedef $$IntervalPhaseLogsTableUpdateCompanionBuilder =
    IntervalPhaseLogsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> sessionId,
      Value<int> sortOrder,
      Value<PhaseType> phaseType,
      Value<String?> label,
      Value<int> round,
      Value<int> plannedSeconds,
      Value<int> actualSeconds,
      Value<bool> skipped,
      Value<int> rowid,
    });

final class $$IntervalPhaseLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IntervalPhaseLogsTable,
          IntervalPhaseLog
        > {
  $$IntervalPhaseLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('interval_phase_log__session_id__session__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IntervalPhaseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $IntervalPhaseLogsTable> {
  $$IntervalPhaseLogsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PhaseType, PhaseType, String> get phaseType =>
      $composableBuilder(
        column: $table.phaseType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalPhaseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntervalPhaseLogsTable> {
  $$IntervalPhaseLogsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseType => $composableBuilder(
    column: $table.phaseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get skipped => $composableBuilder(
    column: $table.skipped,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalPhaseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntervalPhaseLogsTable> {
  $$IntervalPhaseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PhaseType, String> get phaseType =>
      $composableBuilder(column: $table.phaseType, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get plannedSeconds => $composableBuilder(
    column: $table.plannedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualSeconds => $composableBuilder(
    column: $table.actualSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get skipped =>
      $composableBuilder(column: $table.skipped, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IntervalPhaseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntervalPhaseLogsTable,
          IntervalPhaseLog,
          $$IntervalPhaseLogsTableFilterComposer,
          $$IntervalPhaseLogsTableOrderingComposer,
          $$IntervalPhaseLogsTableAnnotationComposer,
          $$IntervalPhaseLogsTableCreateCompanionBuilder,
          $$IntervalPhaseLogsTableUpdateCompanionBuilder,
          (IntervalPhaseLog, $$IntervalPhaseLogsTableReferences),
          IntervalPhaseLog,
          PrefetchHooks Function({bool sessionId})
        > {
  $$IntervalPhaseLogsTableTableManager(
    _$AppDatabase db,
    $IntervalPhaseLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntervalPhaseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntervalPhaseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntervalPhaseLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<PhaseType> phaseType = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<int> plannedSeconds = const Value.absent(),
                Value<int> actualSeconds = const Value.absent(),
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalPhaseLogsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionId: sessionId,
                sortOrder: sortOrder,
                phaseType: phaseType,
                label: label,
                round: round,
                plannedSeconds: plannedSeconds,
                actualSeconds: actualSeconds,
                skipped: skipped,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String sessionId,
                required int sortOrder,
                required PhaseType phaseType,
                Value<String?> label = const Value.absent(),
                Value<int> round = const Value.absent(),
                required int plannedSeconds,
                required int actualSeconds,
                Value<bool> skipped = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntervalPhaseLogsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                sessionId: sessionId,
                sortOrder: sortOrder,
                phaseType: phaseType,
                label: label,
                round: round,
                plannedSeconds: plannedSeconds,
                actualSeconds: actualSeconds,
                skipped: skipped,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IntervalPhaseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$IntervalPhaseLogsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$IntervalPhaseLogsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IntervalPhaseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntervalPhaseLogsTable,
      IntervalPhaseLog,
      $$IntervalPhaseLogsTableFilterComposer,
      $$IntervalPhaseLogsTableOrderingComposer,
      $$IntervalPhaseLogsTableAnnotationComposer,
      $$IntervalPhaseLogsTableCreateCompanionBuilder,
      $$IntervalPhaseLogsTableUpdateCompanionBuilder,
      (IntervalPhaseLog, $$IntervalPhaseLogsTableReferences),
      IntervalPhaseLog,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String exerciseId,
      required RecordType type,
      required double value,
      Value<String?> sessionId,
      required DateTime achievedAt,
      Value<int> rowid,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> exerciseId,
      Value<RecordType> type,
      Value<double> value,
      Value<String?> sessionId,
      Value<DateTime> achievedAt,
      Value<int> rowid,
    });

final class $$PersonalRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord> {
  $$PersonalRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('personal_record__exercise_id__exercise__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('personal_record__session_id__session__id');

  $$SessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<RecordType, RecordType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get achievedAt =>
      $composableBuilder(
        column: $table.achievedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecordType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get achievedAt =>
      $composableBuilder(
        column: $table.achievedAt,
        builder: (column) => column,
      );

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecord,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (PersonalRecord, $$PersonalRecordsTableReferences),
          PersonalRecord,
          PrefetchHooks Function({bool exerciseId, bool sessionId})
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<RecordType> type = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                exerciseId: exerciseId,
                type: type,
                value: value,
                sessionId: sessionId,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String exerciseId,
                required RecordType type,
                required double value,
                Value<String?> sessionId = const Value.absent(),
                required DateTime achievedAt,
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                exerciseId: exerciseId,
                type: type,
                value: value,
                sessionId: sessionId,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonalRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false, sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$PersonalRecordsTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$PersonalRecordsTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$PersonalRecordsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$PersonalRecordsTableReferences
                                        ._sessionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecord,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (PersonalRecord, $$PersonalRecordsTableReferences),
      PersonalRecord,
      PrefetchHooks Function({bool exerciseId, bool sessionId})
    >;
typedef $$PlanDaysTableCreateCompanionBuilder =
    PlanDaysCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required int weekday,
      required SessionKind kind,
      required String templateId,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$PlanDaysTableUpdateCompanionBuilder =
    PlanDaysCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> weekday,
      Value<SessionKind> kind,
      Value<String> templateId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$PlanDaysTableFilterComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionKind, SessionKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlanDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlanDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanDaysTable> {
  $$PlanDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$PlanDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanDaysTable,
          PlanDay,
          $$PlanDaysTableFilterComposer,
          $$PlanDaysTableOrderingComposer,
          $$PlanDaysTableAnnotationComposer,
          $$PlanDaysTableCreateCompanionBuilder,
          $$PlanDaysTableUpdateCompanionBuilder,
          (PlanDay, BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay>),
          PlanDay,
          PrefetchHooks Function()
        > {
  $$PlanDaysTableTableManager(_$AppDatabase db, $PlanDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<SessionKind> kind = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                weekday: weekday,
                kind: kind,
                templateId: templateId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required int weekday,
                required SessionKind kind,
                required String templateId,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanDaysCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                weekday: weekday,
                kind: kind,
                templateId: templateId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlanDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanDaysTable,
      PlanDay,
      $$PlanDaysTableFilterComposer,
      $$PlanDaysTableOrderingComposer,
      $$PlanDaysTableAnnotationComposer,
      $$PlanDaysTableCreateCompanionBuilder,
      $$PlanDaysTableUpdateCompanionBuilder,
      (PlanDay, BaseReferences<_$AppDatabase, $PlanDaysTable, PlanDay>),
      PlanDay,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required int weekday,
      required int minuteOfDay,
      Value<bool> enabled,
      Value<int> rowid,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> weekday,
      Value<int> minuteOfDay,
      Value<bool> enabled,
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
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

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<int> get minuteOfDay => $composableBuilder(
    column: $table.minuteOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
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
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> minuteOfDay = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                weekday: weekday,
                minuteOfDay: minuteOfDay,
                enabled: enabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required int weekday,
                required int minuteOfDay,
                Value<bool> enabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                weekday: weekday,
                minuteOfDay: minuteOfDay,
                enabled: enabled,
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
typedef $$AdStatesTableCreateCompanionBuilder =
    AdStatesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastInterstitialAt,
      Value<int> sessionsSinceInterstitial,
      Value<ConsentStatus> consentStatus,
      Value<bool> adsRemoved,
      Value<int> rowid,
    });
typedef $$AdStatesTableUpdateCompanionBuilder =
    AdStatesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastInterstitialAt,
      Value<int> sessionsSinceInterstitial,
      Value<ConsentStatus> consentStatus,
      Value<bool> adsRemoved,
      Value<int> rowid,
    });

class $$AdStatesTableFilterComposer
    extends Composer<_$AppDatabase, $AdStatesTable> {
  $$AdStatesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int>
  get lastInterstitialAt => $composableBuilder(
    column: $table.lastInterstitialAt,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get sessionsSinceInterstitial => $composableBuilder(
    column: $table.sessionsSinceInterstitial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ConsentStatus, ConsentStatus, String>
  get consentStatus => $composableBuilder(
    column: $table.consentStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get adsRemoved => $composableBuilder(
    column: $table.adsRemoved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AdStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AdStatesTable> {
  $$AdStatesTableOrderingComposer({
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

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastInterstitialAt => $composableBuilder(
    column: $table.lastInterstitialAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionsSinceInterstitial => $composableBuilder(
    column: $table.sessionsSinceInterstitial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consentStatus => $composableBuilder(
    column: $table.consentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adsRemoved => $composableBuilder(
    column: $table.adsRemoved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AdStatesTable> {
  $$AdStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get lastInterstitialAt =>
      $composableBuilder(
        column: $table.lastInterstitialAt,
        builder: (column) => column,
      );

  GeneratedColumn<int> get sessionsSinceInterstitial => $composableBuilder(
    column: $table.sessionsSinceInterstitial,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ConsentStatus, String> get consentStatus =>
      $composableBuilder(
        column: $table.consentStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get adsRemoved => $composableBuilder(
    column: $table.adsRemoved,
    builder: (column) => column,
  );
}

class $$AdStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AdStatesTable,
          AdState,
          $$AdStatesTableFilterComposer,
          $$AdStatesTableOrderingComposer,
          $$AdStatesTableAnnotationComposer,
          $$AdStatesTableCreateCompanionBuilder,
          $$AdStatesTableUpdateCompanionBuilder,
          (AdState, BaseReferences<_$AppDatabase, $AdStatesTable, AdState>),
          AdState,
          PrefetchHooks Function()
        > {
  $$AdStatesTableTableManager(_$AppDatabase db, $AdStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastInterstitialAt = const Value.absent(),
                Value<int> sessionsSinceInterstitial = const Value.absent(),
                Value<ConsentStatus> consentStatus = const Value.absent(),
                Value<bool> adsRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdStatesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastInterstitialAt: lastInterstitialAt,
                sessionsSinceInterstitial: sessionsSinceInterstitial,
                consentStatus: consentStatus,
                adsRemoved: adsRemoved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastInterstitialAt = const Value.absent(),
                Value<int> sessionsSinceInterstitial = const Value.absent(),
                Value<ConsentStatus> consentStatus = const Value.absent(),
                Value<bool> adsRemoved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AdStatesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastInterstitialAt: lastInterstitialAt,
                sessionsSinceInterstitial: sessionsSinceInterstitial,
                consentStatus: consentStatus,
                adsRemoved: adsRemoved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AdStatesTable,
      AdState,
      $$AdStatesTableFilterComposer,
      $$AdStatesTableOrderingComposer,
      $$AdStatesTableAnnotationComposer,
      $$AdStatesTableCreateCompanionBuilder,
      $$AdStatesTableUpdateCompanionBuilder,
      (AdState, BaseReferences<_$AppDatabase, $AdStatesTable, AdState>),
      AdState,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$StrengthRoutinesTableTableManager get strengthRoutines =>
      $$StrengthRoutinesTableTableManager(_db, _db.strengthRoutines);
  $$RoutineExercisesTableTableManager get routineExercises =>
      $$RoutineExercisesTableTableManager(_db, _db.routineExercises);
  $$RoutineSetTargetsTableTableManager get routineSetTargets =>
      $$RoutineSetTargetsTableTableManager(_db, _db.routineSetTargets);
  $$IntervalWorkoutsTableTableManager get intervalWorkouts =>
      $$IntervalWorkoutsTableTableManager(_db, _db.intervalWorkouts);
  $$IntervalBlocksTableTableManager get intervalBlocks =>
      $$IntervalBlocksTableTableManager(_db, _db.intervalBlocks);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
  $$IntervalPhaseLogsTableTableManager get intervalPhaseLogs =>
      $$IntervalPhaseLogsTableTableManager(_db, _db.intervalPhaseLogs);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$PlanDaysTableTableManager get planDays =>
      $$PlanDaysTableTableManager(_db, _db.planDays);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AdStatesTableTableManager get adStates =>
      $$AdStatesTableTableManager(_db, _db.adStates);
}
