// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_stock_notification_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLowStockNotificationModelCollection on Isar {
  IsarCollection<LowStockNotificationModel> get lowStockNotificationModels =>
      this.collection();
}

const LowStockNotificationModelSchema = CollectionSchema(
  name: r'LowStockNotificationModel',
  id: 5197828273300731186,
  properties: {
    r'inventoryItemId': PropertySchema(
      id: 0,
      name: r'inventoryItemId',
      type: IsarType.long,
    ),
    r'lastQuantity': PropertySchema(
      id: 1,
      name: r'lastQuantity',
      type: IsarType.long,
    ),
    r'lowStockLimit': PropertySchema(
      id: 2,
      name: r'lowStockLimit',
      type: IsarType.long,
    ),
    r'notifiedAt': PropertySchema(
      id: 3,
      name: r'notifiedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _lowStockNotificationModelEstimateSize,
  serialize: _lowStockNotificationModelSerialize,
  deserialize: _lowStockNotificationModelDeserialize,
  deserializeProp: _lowStockNotificationModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'inventoryItemId': IndexSchema(
      id: -8922134744435378615,
      name: r'inventoryItemId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'inventoryItemId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _lowStockNotificationModelGetId,
  getLinks: _lowStockNotificationModelGetLinks,
  attach: _lowStockNotificationModelAttach,
  version: '3.1.0+1',
);

int _lowStockNotificationModelEstimateSize(
  LowStockNotificationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _lowStockNotificationModelSerialize(
  LowStockNotificationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.inventoryItemId);
  writer.writeLong(offsets[1], object.lastQuantity);
  writer.writeLong(offsets[2], object.lowStockLimit);
  writer.writeDateTime(offsets[3], object.notifiedAt);
}

LowStockNotificationModel _lowStockNotificationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LowStockNotificationModel();
  object.id = id;
  object.inventoryItemId = reader.readLong(offsets[0]);
  object.lastQuantity = reader.readLong(offsets[1]);
  object.lowStockLimit = reader.readLong(offsets[2]);
  object.notifiedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _lowStockNotificationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lowStockNotificationModelGetId(LowStockNotificationModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lowStockNotificationModelGetLinks(
  LowStockNotificationModel object,
) {
  return [];
}

void _lowStockNotificationModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  LowStockNotificationModel object,
) {
  object.id = id;
}

extension LowStockNotificationModelQueryWhereSort
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QWhere
        > {
  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhere
  >
  anyInventoryItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'inventoryItemId'),
      );
    });
  }
}

extension LowStockNotificationModelQueryWhere
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QWhereClause
        > {
  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  idBetween(
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

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  inventoryItemIdEqualTo(int inventoryItemId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'inventoryItemId',
          value: [inventoryItemId],
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  inventoryItemIdNotEqualTo(int inventoryItemId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'inventoryItemId',
                lower: [],
                upper: [inventoryItemId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'inventoryItemId',
                lower: [inventoryItemId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'inventoryItemId',
                lower: [inventoryItemId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'inventoryItemId',
                lower: [],
                upper: [inventoryItemId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  inventoryItemIdGreaterThan(int inventoryItemId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'inventoryItemId',
          lower: [inventoryItemId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  inventoryItemIdLessThan(int inventoryItemId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'inventoryItemId',
          lower: [],
          upper: [inventoryItemId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterWhereClause
  >
  inventoryItemIdBetween(
    int lowerInventoryItemId,
    int upperInventoryItemId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'inventoryItemId',
          lower: [lowerInventoryItemId],
          includeLower: includeLower,
          upper: [upperInventoryItemId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LowStockNotificationModelQueryFilter
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QFilterCondition
        > {
  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  inventoryItemIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'inventoryItemId', value: value),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  inventoryItemIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'inventoryItemId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  inventoryItemIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'inventoryItemId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  inventoryItemIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'inventoryItemId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lastQuantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastQuantity', value: value),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lastQuantityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastQuantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lastQuantityLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastQuantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lastQuantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastQuantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lowStockLimitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lowStockLimit', value: value),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lowStockLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lowStockLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lowStockLimitLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lowStockLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  lowStockLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lowStockLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  notifiedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notifiedAt', value: value),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  notifiedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notifiedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  notifiedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notifiedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterFilterCondition
  >
  notifiedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notifiedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LowStockNotificationModelQueryObject
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QFilterCondition
        > {}

extension LowStockNotificationModelQueryLinks
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QFilterCondition
        > {}

extension LowStockNotificationModelQuerySortBy
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QSortBy
        > {
  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByInventoryItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inventoryItemId', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByInventoryItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inventoryItemId', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByLastQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByLastQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByLowStockLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockLimit', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByLowStockLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockLimit', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByNotifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifiedAt', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  sortByNotifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifiedAt', Sort.desc);
    });
  }
}

extension LowStockNotificationModelQuerySortThenBy
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QSortThenBy
        > {
  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByInventoryItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inventoryItemId', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByInventoryItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'inventoryItemId', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByLastQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastQuantity', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByLastQuantityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastQuantity', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByLowStockLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockLimit', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByLowStockLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lowStockLimit', Sort.desc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByNotifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifiedAt', Sort.asc);
    });
  }

  QueryBuilder<
    LowStockNotificationModel,
    LowStockNotificationModel,
    QAfterSortBy
  >
  thenByNotifiedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifiedAt', Sort.desc);
    });
  }
}

extension LowStockNotificationModelQueryWhereDistinct
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QDistinct
        > {
  QueryBuilder<LowStockNotificationModel, LowStockNotificationModel, QDistinct>
  distinctByInventoryItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'inventoryItemId');
    });
  }

  QueryBuilder<LowStockNotificationModel, LowStockNotificationModel, QDistinct>
  distinctByLastQuantity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastQuantity');
    });
  }

  QueryBuilder<LowStockNotificationModel, LowStockNotificationModel, QDistinct>
  distinctByLowStockLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lowStockLimit');
    });
  }

  QueryBuilder<LowStockNotificationModel, LowStockNotificationModel, QDistinct>
  distinctByNotifiedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifiedAt');
    });
  }
}

extension LowStockNotificationModelQueryProperty
    on
        QueryBuilder<
          LowStockNotificationModel,
          LowStockNotificationModel,
          QQueryProperty
        > {
  QueryBuilder<LowStockNotificationModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LowStockNotificationModel, int, QQueryOperations>
  inventoryItemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'inventoryItemId');
    });
  }

  QueryBuilder<LowStockNotificationModel, int, QQueryOperations>
  lastQuantityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastQuantity');
    });
  }

  QueryBuilder<LowStockNotificationModel, int, QQueryOperations>
  lowStockLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lowStockLimit');
    });
  }

  QueryBuilder<LowStockNotificationModel, DateTime, QQueryOperations>
  notifiedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifiedAt');
    });
  }
}
