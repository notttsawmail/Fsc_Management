// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_order_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBillingOrderModelCollection on Isar {
  IsarCollection<BillingOrderModel> get billingOrderModels => this.collection();
}

const BillingOrderModelSchema = CollectionSchema(
  name: r'BillingOrderModel',
  id: 6687249217810410969,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'items': PropertySchema(
      id: 1,
      name: r'items',
      type: IsarType.objectList,
      target: r'BillingOrderItemModel',
    ),
    r'nepaliDate': PropertySchema(
      id: 2,
      name: r'nepaliDate',
      type: IsarType.string,
    ),
    r'orderId': PropertySchema(id: 3, name: r'orderId', type: IsarType.string),
    r'orderStatus': PropertySchema(
      id: 4,
      name: r'orderStatus',
      type: IsarType.string,
    ),
    r'paymentMethod': PropertySchema(
      id: 5,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'paymentStatus': PropertySchema(
      id: 6,
      name: r'paymentStatus',
      type: IsarType.string,
    ),
    r'subtotal': PropertySchema(
      id: 7,
      name: r'subtotal',
      type: IsarType.double,
    ),
    r'tokenNumber': PropertySchema(
      id: 8,
      name: r'tokenNumber',
      type: IsarType.long,
    ),
    r'totalAmount': PropertySchema(
      id: 9,
      name: r'totalAmount',
      type: IsarType.double,
    ),
  },
  estimateSize: _billingOrderModelEstimateSize,
  serialize: _billingOrderModelSerialize,
  deserialize: _billingOrderModelDeserialize,
  deserializeProp: _billingOrderModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'orderId': IndexSchema(
      id: -6176610178429382285,
      name: r'orderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'tokenNumber_nepaliDate': IndexSchema(
      id: 7834577834406045331,
      name: r'tokenNumber_nepaliDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tokenNumber',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'nepaliDate',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'nepaliDate': IndexSchema(
      id: -2644117338530766751,
      name: r'nepaliDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nepaliDate',
          type: IndexType.hash,
          caseSensitive: false,
        ),
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'BillingOrderItemModel': BillingOrderItemModelSchema},
  getId: _billingOrderModelGetId,
  getLinks: _billingOrderModelGetLinks,
  attach: _billingOrderModelAttach,
  version: '3.1.0+1',
);

int _billingOrderModelEstimateSize(
  BillingOrderModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.items.length * 3;
  {
    final offsets = allOffsets[BillingOrderItemModel]!;
    for (var i = 0; i < object.items.length; i++) {
      final value = object.items[i];
      bytesCount += BillingOrderItemModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  bytesCount += 3 + object.nepaliDate.length * 3;
  bytesCount += 3 + object.orderId.length * 3;
  bytesCount += 3 + object.orderStatus.length * 3;
  bytesCount += 3 + object.paymentMethod.length * 3;
  bytesCount += 3 + object.paymentStatus.length * 3;
  return bytesCount;
}

void _billingOrderModelSerialize(
  BillingOrderModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeObjectList<BillingOrderItemModel>(
    offsets[1],
    allOffsets,
    BillingOrderItemModelSchema.serialize,
    object.items,
  );
  writer.writeString(offsets[2], object.nepaliDate);
  writer.writeString(offsets[3], object.orderId);
  writer.writeString(offsets[4], object.orderStatus);
  writer.writeString(offsets[5], object.paymentMethod);
  writer.writeString(offsets[6], object.paymentStatus);
  writer.writeDouble(offsets[7], object.subtotal);
  writer.writeLong(offsets[8], object.tokenNumber);
  writer.writeDouble(offsets[9], object.totalAmount);
}

BillingOrderModel _billingOrderModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BillingOrderModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.items =
      reader.readObjectList<BillingOrderItemModel>(
        offsets[1],
        BillingOrderItemModelSchema.deserialize,
        allOffsets,
        BillingOrderItemModel(),
      ) ??
      [];
  object.nepaliDate = reader.readString(offsets[2]);
  object.orderId = reader.readString(offsets[3]);
  object.orderStatus = reader.readString(offsets[4]);
  object.paymentMethod = reader.readString(offsets[5]);
  object.paymentStatus = reader.readString(offsets[6]);
  object.subtotal = reader.readDouble(offsets[7]);
  object.tokenNumber = reader.readLong(offsets[8]);
  object.totalAmount = reader.readDouble(offsets[9]);
  return object;
}

P _billingOrderModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readObjectList<BillingOrderItemModel>(
                offset,
                BillingOrderItemModelSchema.deserialize,
                allOffsets,
                BillingOrderItemModel(),
              ) ??
              [])
          as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _billingOrderModelGetId(BillingOrderModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _billingOrderModelGetLinks(
  BillingOrderModel object,
) {
  return [];
}

void _billingOrderModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  BillingOrderModel object,
) {
  object.id = id;
}

extension BillingOrderModelQueryWhereSort
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QWhere> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhere>
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension BillingOrderModelQueryWhere
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QWhereClause> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
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

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
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

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  orderIdEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'orderId', value: [orderId]),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  orderIdNotEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [],
                upper: [orderId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [orderId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [orderId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'orderId',
                lower: [],
                upper: [orderId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberEqualToAnyNepaliDate(int tokenNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tokenNumber_nepaliDate',
          value: [tokenNumber],
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberNotEqualToAnyNepaliDate(int tokenNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [],
                upper: [tokenNumber],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [],
                upper: [tokenNumber],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberGreaterThanAnyNepaliDate(int tokenNumber, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tokenNumber_nepaliDate',
          lower: [tokenNumber],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberLessThanAnyNepaliDate(int tokenNumber, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tokenNumber_nepaliDate',
          lower: [],
          upper: [tokenNumber],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberBetweenAnyNepaliDate(
    int lowerTokenNumber,
    int upperTokenNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'tokenNumber_nepaliDate',
          lower: [lowerTokenNumber],
          includeLower: includeLower,
          upper: [upperTokenNumber],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberNepaliDateEqualTo(int tokenNumber, String nepaliDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'tokenNumber_nepaliDate',
          value: [tokenNumber, nepaliDate],
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  tokenNumberEqualToNepaliDateNotEqualTo(int tokenNumber, String nepaliDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber],
                upper: [tokenNumber, nepaliDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber, nepaliDate],
                includeLower: false,
                upper: [tokenNumber],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber, nepaliDate],
                includeLower: false,
                upper: [tokenNumber],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'tokenNumber_nepaliDate',
                lower: [tokenNumber],
                upper: [tokenNumber, nepaliDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  nepaliDateEqualTo(String nepaliDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'nepaliDate', value: [nepaliDate]),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  nepaliDateNotEqualTo(String nepaliDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nepaliDate',
                lower: [],
                upper: [nepaliDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nepaliDate',
                lower: [nepaliDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nepaliDate',
                lower: [nepaliDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nepaliDate',
                lower: [],
                upper: [nepaliDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterWhereClause>
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BillingOrderModelQueryFilter
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QFilterCondition> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
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

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
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

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
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

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', length, true, length, true);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, true, 0, true);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, false, 999999, true);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', 0, true, length, include);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'items', length, include, 999999, true);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'items',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nepaliDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nepaliDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nepaliDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nepaliDate', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  nepaliDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nepaliDate', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orderId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'orderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'orderId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderId', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'orderId', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orderStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'orderStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'orderStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderStatus', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  orderStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'orderStatus', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentMethod',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentMethod',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentMethod',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentMethod', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paymentStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paymentStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paymentStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paymentStatus', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  paymentStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paymentStatus', value: ''),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  subtotalEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'subtotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  subtotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'subtotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  subtotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'subtotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  subtotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'subtotal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  tokenNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tokenNumber', value: value),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  tokenNumberGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tokenNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  tokenNumberLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tokenNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  tokenNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tokenNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  totalAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalAmount',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalAmount',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalAmount',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension BillingOrderModelQueryObject
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QFilterCondition> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterFilterCondition>
  itemsElement(FilterQuery<BillingOrderItemModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'items');
    });
  }
}

extension BillingOrderModelQueryLinks
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QFilterCondition> {}

extension BillingOrderModelQuerySortBy
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QSortBy> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByNepaliDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nepaliDate', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByNepaliDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nepaliDate', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByOrderStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderStatus', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByOrderStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderStatus', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByTokenNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenNumber', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByTokenNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenNumber', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension BillingOrderModelQuerySortThenBy
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QSortThenBy> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByNepaliDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nepaliDate', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByNepaliDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nepaliDate', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByOrderStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderStatus', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByOrderStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderStatus', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByPaymentStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByPaymentStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentStatus', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenBySubtotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subtotal', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByTokenNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenNumber', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByTokenNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenNumber', Sort.desc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QAfterSortBy>
  thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension BillingOrderModelQueryWhereDistinct
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct> {
  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByNepaliDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nepaliDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByOrderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByOrderStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentMethod',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByPaymentStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paymentStatus',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctBySubtotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subtotal');
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByTokenNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenNumber');
    });
  }

  QueryBuilder<BillingOrderModel, BillingOrderModel, QDistinct>
  distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }
}

extension BillingOrderModelQueryProperty
    on QueryBuilder<BillingOrderModel, BillingOrderModel, QQueryProperty> {
  QueryBuilder<BillingOrderModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BillingOrderModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BillingOrderModel, List<BillingOrderItemModel>, QQueryOperations>
  itemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'items');
    });
  }

  QueryBuilder<BillingOrderModel, String, QQueryOperations>
  nepaliDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nepaliDate');
    });
  }

  QueryBuilder<BillingOrderModel, String, QQueryOperations> orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<BillingOrderModel, String, QQueryOperations>
  orderStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderStatus');
    });
  }

  QueryBuilder<BillingOrderModel, String, QQueryOperations>
  paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<BillingOrderModel, String, QQueryOperations>
  paymentStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentStatus');
    });
  }

  QueryBuilder<BillingOrderModel, double, QQueryOperations> subtotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subtotal');
    });
  }

  QueryBuilder<BillingOrderModel, int, QQueryOperations> tokenNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenNumber');
    });
  }

  QueryBuilder<BillingOrderModel, double, QQueryOperations>
  totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const BillingOrderItemModelSchema = Schema(
  name: r'BillingOrderItemModel',
  id: -3388075711647799293,
  properties: {
    r'inventoryItemId': PropertySchema(
      id: 0,
      name: r'inventoryItemId',
      type: IsarType.long,
    ),
    r'itemCode': PropertySchema(
      id: 1,
      name: r'itemCode',
      type: IsarType.string,
    ),
    r'itemName': PropertySchema(
      id: 2,
      name: r'itemName',
      type: IsarType.string,
    ),
    r'lineTotal': PropertySchema(
      id: 3,
      name: r'lineTotal',
      type: IsarType.double,
    ),
    r'quantity': PropertySchema(id: 4, name: r'quantity', type: IsarType.long),
    r'unitPrice': PropertySchema(
      id: 5,
      name: r'unitPrice',
      type: IsarType.double,
    ),
  },
  estimateSize: _billingOrderItemModelEstimateSize,
  serialize: _billingOrderItemModelSerialize,
  deserialize: _billingOrderItemModelDeserialize,
  deserializeProp: _billingOrderItemModelDeserializeProp,
);

int _billingOrderItemModelEstimateSize(
  BillingOrderItemModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.itemCode.length * 3;
  bytesCount += 3 + object.itemName.length * 3;
  return bytesCount;
}

void _billingOrderItemModelSerialize(
  BillingOrderItemModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.inventoryItemId);
  writer.writeString(offsets[1], object.itemCode);
  writer.writeString(offsets[2], object.itemName);
  writer.writeDouble(offsets[3], object.lineTotal);
  writer.writeLong(offsets[4], object.quantity);
  writer.writeDouble(offsets[5], object.unitPrice);
}

BillingOrderItemModel _billingOrderItemModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BillingOrderItemModel();
  object.inventoryItemId = reader.readLong(offsets[0]);
  object.itemCode = reader.readString(offsets[1]);
  object.itemName = reader.readString(offsets[2]);
  object.lineTotal = reader.readDouble(offsets[3]);
  object.quantity = reader.readLong(offsets[4]);
  object.unitPrice = reader.readDouble(offsets[5]);
  return object;
}

P _billingOrderItemModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension BillingOrderItemModelQueryFilter
    on
        QueryBuilder<
          BillingOrderItemModel,
          BillingOrderItemModel,
          QFilterCondition
        > {
  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
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
    BillingOrderItemModel,
    BillingOrderItemModel,
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
    BillingOrderItemModel,
    BillingOrderItemModel,
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
    BillingOrderItemModel,
    BillingOrderItemModel,
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
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemCode', value: ''),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemCode', value: ''),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemName', value: ''),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  itemNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemName', value: ''),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  lineTotalEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lineTotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  lineTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lineTotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  lineTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lineTotal',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  lineTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lineTotal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  quantityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quantity', value: value),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  quantityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  quantityLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quantity',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  quantityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quantity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  unitPriceEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unitPrice',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  unitPriceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unitPrice',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  unitPriceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unitPrice',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    BillingOrderItemModel,
    BillingOrderItemModel,
    QAfterFilterCondition
  >
  unitPriceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unitPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension BillingOrderItemModelQueryObject
    on
        QueryBuilder<
          BillingOrderItemModel,
          BillingOrderItemModel,
          QFilterCondition
        > {}
