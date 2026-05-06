// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsModelCollection on Isar {
  IsarCollection<AppSettingsModel> get appSettingsModels => this.collection();
}

const AppSettingsModelSchema = CollectionSchema(
  name: r'AppSettingsModel',
  id: -638838212012723081,
  properties: {
    r'currencySymbol': PropertySchema(
      id: 0,
      name: r'currencySymbol',
      type: IsarType.string,
    ),
    r'dailyLowStockSummaryEnabled': PropertySchema(
      id: 1,
      name: r'dailyLowStockSummaryEnabled',
      type: IsarType.bool,
    ),
    r'defaultPaymentMethod': PropertySchema(
      id: 2,
      name: r'defaultPaymentMethod',
      type: IsarType.string,
    ),
    r'lastDailyLowStockSummaryAt': PropertySchema(
      id: 3,
      name: r'lastDailyLowStockSummaryAt',
      type: IsarType.dateTime,
    ),
    r'latestBackupAt': PropertySchema(
      id: 4,
      name: r'latestBackupAt',
      type: IsarType.dateTime,
    ),
    r'latestBackupPath': PropertySchema(
      id: 5,
      name: r'latestBackupPath',
      type: IsarType.string,
    ),
    r'lowStockAlertThreshold': PropertySchema(
      id: 6,
      name: r'lowStockAlertThreshold',
      type: IsarType.long,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 7,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'shopAddress': PropertySchema(
      id: 8,
      name: r'shopAddress',
      type: IsarType.string,
    ),
    r'shopName': PropertySchema(
      id: 9,
      name: r'shopName',
      type: IsarType.string,
    ),
    r'taxPercentage': PropertySchema(
      id: 10,
      name: r'taxPercentage',
      type: IsarType.double,
    ),
    r'taxesEnabled': PropertySchema(
      id: 11,
      name: r'taxesEnabled',
      type: IsarType.bool,
    ),
    r'tokenResetRule': PropertySchema(
      id: 12,
      name: r'tokenResetRule',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'useNepaliTimezone': PropertySchema(
      id: 14,
      name: r'useNepaliTimezone',
      type: IsarType.bool,
    ),
  },
  estimateSize: _appSettingsModelEstimateSize,
  serialize: _appSettingsModelSerialize,
  deserialize: _appSettingsModelDeserialize,
  deserializeProp: _appSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsModelGetId,
  getLinks: _appSettingsModelGetLinks,
  attach: _appSettingsModelAttach,
  version: '3.1.0+1',
);

int _appSettingsModelEstimateSize(
  AppSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currencySymbol.length * 3;
  bytesCount += 3 + object.defaultPaymentMethod.length * 3;
  {
    final value = object.latestBackupPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.shopAddress.length * 3;
  bytesCount += 3 + object.shopName.length * 3;
  bytesCount += 3 + object.tokenResetRule.length * 3;
  return bytesCount;
}

void _appSettingsModelSerialize(
  AppSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currencySymbol);
  writer.writeBool(offsets[1], object.dailyLowStockSummaryEnabled);
  writer.writeString(offsets[2], object.defaultPaymentMethod);
  writer.writeDateTime(offsets[3], object.lastDailyLowStockSummaryAt);
  writer.writeDateTime(offsets[4], object.latestBackupAt);
  writer.writeString(offsets[5], object.latestBackupPath);
  writer.writeLong(offsets[6], object.lowStockAlertThreshold);
  writer.writeBool(offsets[7], object.notificationsEnabled);
  writer.writeString(offsets[8], object.shopAddress);
  writer.writeString(offsets[9], object.shopName);
  writer.writeDouble(offsets[10], object.taxPercentage);
  writer.writeBool(offsets[11], object.taxesEnabled);
  writer.writeString(offsets[12], object.tokenResetRule);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeBool(offsets[14], object.useNepaliTimezone);
}

AppSettingsModel _appSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsModel();
  object.currencySymbol = reader.readString(offsets[0]);
  object.dailyLowStockSummaryEnabled = reader.readBool(offsets[1]);
  object.defaultPaymentMethod = reader.readString(offsets[2]);
  object.id = id;
  object.lastDailyLowStockSummaryAt = reader.readDateTimeOrNull(offsets[3]);
  object.latestBackupAt = reader.readDateTimeOrNull(offsets[4]);
  object.latestBackupPath = reader.readStringOrNull(offsets[5]);
  object.lowStockAlertThreshold = reader.readLong(offsets[6]);
  object.notificationsEnabled = reader.readBool(offsets[7]);
  object.shopAddress = reader.readString(offsets[8]);
  object.shopName = reader.readString(offsets[9]);
  object.taxPercentage = reader.readDouble(offsets[10]);
  object.taxesEnabled = reader.readBool(offsets[11]);
  object.tokenResetRule = reader.readString(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  object.useNepaliTimezone = reader.readBool(offsets[14]);
  return object;
}

P _appSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsModelGetId(AppSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsModelGetLinks(AppSettingsModel object) {
  return [];
}

void _appSettingsModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppSettingsModel object,
) {
  object.id = id;
}

extension AppSettingsModelQueryWhereSort
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhere> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsModelQueryWhere
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhereClause> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AppSettingsModelQueryFilter
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currencySymbol',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currencySymbol',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currencySymbol',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currencySymbol', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  currencySymbolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currencySymbol', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  dailyLowStockSummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dailyLowStockSummaryEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'defaultPaymentMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'defaultPaymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'defaultPaymentMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'defaultPaymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  defaultPaymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'defaultPaymentMethod',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastDailyLowStockSummaryAt'),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(
          property: r'lastDailyLowStockSummaryAt',
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastDailyLowStockSummaryAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastDailyLowStockSummaryAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastDailyLowStockSummaryAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lastDailyLowStockSummaryAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastDailyLowStockSummaryAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'latestBackupAt'),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'latestBackupAt'),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'latestBackupAt', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latestBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latestBackupAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latestBackupAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'latestBackupPath'),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'latestBackupPath'),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latestBackupPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'latestBackupPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'latestBackupPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'latestBackupPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  latestBackupPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'latestBackupPath', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lowStockAlertThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lowStockAlertThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lowStockAlertThresholdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lowStockAlertThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lowStockAlertThresholdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lowStockAlertThreshold',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  lowStockAlertThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lowStockAlertThreshold',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  notificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notificationsEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shopAddress',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shopAddress',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shopAddress',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shopAddress', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shopAddress', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shopName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'shopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'shopName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shopName', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  shopNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'shopName', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  taxPercentageEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'taxPercentage',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  taxPercentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taxPercentage',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  taxPercentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taxPercentage',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  taxPercentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taxPercentage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  taxesEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taxesEnabled', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tokenResetRule',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tokenResetRule',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tokenResetRule',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tokenResetRule', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  tokenResetRuleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tokenResetRule', value: ''),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
  useNepaliTimezoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'useNepaliTimezone', value: value),
      );
    });
  }
}

extension AppSettingsModelQueryObject
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQueryLinks
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQuerySortBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByDailyLowStockSummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLowStockSummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByDailyLowStockSummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLowStockSummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByDefaultPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByDefaultPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLastDailyLowStockSummaryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailyLowStockSummaryAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLastDailyLowStockSummaryAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailyLowStockSummaryAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLatestBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLatestBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLatestBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupPath', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLatestBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupPath', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLowStockAlertThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockAlertThreshold', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByLowStockAlertThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockAlertThreshold', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByShopAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByShopAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTaxesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxesEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTaxesEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxesEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTokenResetRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenResetRule', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByTokenResetRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenResetRule', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByUseNepaliTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useNepaliTimezone', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  sortByUseNepaliTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useNepaliTimezone', Sort.desc);
    });
  }
}

extension AppSettingsModelQuerySortThenBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortThenBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByCurrencySymbol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByCurrencySymbolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencySymbol', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByDailyLowStockSummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLowStockSummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByDailyLowStockSummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLowStockSummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByDefaultPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByDefaultPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultPaymentMethod', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLastDailyLowStockSummaryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailyLowStockSummaryAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLastDailyLowStockSummaryAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailyLowStockSummaryAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLatestBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLatestBackupAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLatestBackupPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupPath', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLatestBackupPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latestBackupPath', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLowStockAlertThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockAlertThreshold', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByLowStockAlertThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockAlertThreshold', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByShopAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByShopAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxPercentage', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTaxesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxesEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTaxesEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxesEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTokenResetRule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenResetRule', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByTokenResetRuleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenResetRule', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByUseNepaliTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useNepaliTimezone', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
  thenByUseNepaliTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useNepaliTimezone', Sort.desc);
    });
  }
}

extension AppSettingsModelQueryWhereDistinct
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByCurrencySymbol({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'currencySymbol',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByDailyLowStockSummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyLowStockSummaryEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByDefaultPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'defaultPaymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByLastDailyLowStockSummaryAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDailyLowStockSummaryAt');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByLatestBackupAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latestBackupAt');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByLatestBackupPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'latestBackupPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByLowStockAlertThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowStockAlertThreshold');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationsEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByShopAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByShopName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxPercentage');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByTaxesEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxesEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByTokenResetRule({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'tokenResetRule',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
  distinctByUseNepaliTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useNepaliTimezone');
    });
  }
}

extension AppSettingsModelQueryProperty
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QQueryProperty> {
  QueryBuilder<AppSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsModel, String, QQueryOperations>
  currencySymbolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencySymbol');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
  dailyLowStockSummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyLowStockSummaryEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, String, QQueryOperations>
  defaultPaymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultPaymentMethod');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime?, QQueryOperations>
  lastDailyLowStockSummaryAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDailyLowStockSummaryAt');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime?, QQueryOperations>
  latestBackupAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latestBackupAt');
    });
  }

  QueryBuilder<AppSettingsModel, String?, QQueryOperations>
  latestBackupPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latestBackupPath');
    });
  }

  QueryBuilder<AppSettingsModel, int, QQueryOperations>
  lowStockAlertThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowStockAlertThreshold');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
  notificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationsEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, String, QQueryOperations>
  shopAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopAddress');
    });
  }

  QueryBuilder<AppSettingsModel, String, QQueryOperations> shopNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopName');
    });
  }

  QueryBuilder<AppSettingsModel, double, QQueryOperations>
  taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxPercentage');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
  taxesEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxesEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, String, QQueryOperations>
  tokenResetRuleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenResetRule');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
  useNepaliTimezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useNepaliTimezone');
    });
  }
}
