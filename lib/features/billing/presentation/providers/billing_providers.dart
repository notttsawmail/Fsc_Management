import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../inventory/domain/entities/inventory_item.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import '../../data/datasources/billing_local_data_source.dart';
import '../../data/repositories/billing_repository_impl.dart';
import '../../domain/entities/billing_enums.dart';
import '../../domain/entities/billing_order.dart';
import '../../domain/entities/billing_order_item.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/billing_repository.dart';
import '../../domain/usecases/cancel_order.dart';
import '../../domain/usecases/create_paid_order.dart';
import '../../domain/usecases/watch_billing_orders.dart';

final billingLocalDataSourceProvider = FutureProvider<BillingLocalDataSource>((
  ref,
) {
  return BillingLocalDataSource.open();
});

final billingRepositoryProvider = FutureProvider<BillingRepository>((
  ref,
) async {
  final dataSource = await ref.watch(billingLocalDataSourceProvider.future);
  return BillingRepositoryImpl(dataSource);
});

final billingSearchQueryProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final billingInventoryItemsProvider =
    StreamProvider.autoDispose<List<InventoryItem>>((ref) async* {
      final repository = await ref.watch(inventoryRepositoryProvider.future);
      final searchQuery = ref.watch(billingSearchQueryProvider);
      yield* repository.watchItems(searchQuery: searchQuery);
    });

final selectedPaymentMethodProvider = StateProvider.autoDispose<PaymentMethod>(
  (ref) => PaymentMethod.cash,
);

final billingMobileTabProvider = StateProvider.autoDispose<int>((ref) => 0);

final billingOrdersProvider = StreamProvider.autoDispose<List<BillingOrder>>((
  ref,
) async* {
  final repository = await ref.watch(billingRepositoryProvider.future);
  yield* WatchBillingOrders(repository)();
});

final nextTokenProvider = FutureProvider.autoDispose<int>((ref) async {
  final repository = await ref.watch(billingRepositoryProvider.future);
  return repository.nextTokenNumber(nepaliDate: nepaliDateToday());
});

final cartProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});

final billingControllerProvider =
    StateNotifierProvider<BillingController, AsyncValue<BillingOrder?>>((ref) {
      return BillingController(ref);
    });

String nepaliDateToday() {
  final nepalNow = DateTime.now().toUtc().add(
    const Duration(hours: 5, minutes: 45),
  );
  final month = nepalNow.month.toString().padLeft(2, '0');
  final day = nepalNow.day.toString().padLeft(2, '0');
  return '${nepalNow.year}-$month-$day';
}

DateTime nepaliNow() {
  return DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 45));
}

class CartToken {
  const CartToken({
    required this.id,
    required this.tokenNumber,
    this.items = const [],
  });

  final String id;
  final int tokenNumber;
  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  double get subtotal => items.fold(0, (total, item) => total + item.lineTotal);

  double get totalAmount => subtotal;

  CartToken copyWith({List<CartItem>? items}) {
    return CartToken(
      id: id,
      tokenNumber: tokenNumber,
      items: items ?? this.items,
    );
  }
}

class CartState {
  const CartState({
    required this.tokens,
    required this.activeTokenId,
    required this.nextTokenNumber,
  });

  factory CartState.initial() {
    const token = CartToken(id: 'token_1', tokenNumber: 1);
    return const CartState(
      tokens: [token],
      activeTokenId: 'token_1',
      nextTokenNumber: 2,
    );
  }

  final List<CartToken> tokens;
  final String activeTokenId;
  final int nextTokenNumber;

  CartToken get activeToken {
    return tokens.firstWhere(
      (token) => token.id == activeTokenId,
      orElse: () => tokens.first,
    );
  }

  List<CartItem> get items => activeToken.items;

  bool get isEmpty => activeToken.isEmpty;

  int get totalItems => activeToken.totalItems;

  double get subtotal => activeToken.subtotal;

  double get totalAmount => activeToken.totalAmount;

  int quantityFor(int inventoryItemId) {
    return tokens
        .expand((token) => token.items)
        .where((item) => item.item.id == inventoryItemId)
        .fold(0, (total, item) => total + item.quantity);
  }

  int activeQuantityFor(int inventoryItemId) {
    return activeToken.items
        .where((item) => item.item.id == inventoryItemId)
        .fold(0, (total, item) => total + item.quantity);
  }

  int availableFor(InventoryItem item) {
    if (!item.isTrackableInventory) {
      return 999999;
    }
    return item.quantity - quantityFor(item.id);
  }
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(CartState.initial());

  void syncNextTokenSeed(int nextSavedToken) {
    if (nextSavedToken < state.nextTokenNumber) {
      return;
    }
    final hasDefaultEmptyToken =
        state.tokens.length == 1 &&
        state.tokens.first.tokenNumber == 1 &&
        state.tokens.first.isEmpty;
    if (hasDefaultEmptyToken && nextSavedToken != 1) {
      final token = CartToken(
        id: 'token_$nextSavedToken',
        tokenNumber: nextSavedToken,
      );
      state = CartState(
        tokens: [token],
        activeTokenId: token.id,
        nextTokenNumber: nextSavedToken + 1,
      );
      return;
    }
    state = CartState(
      tokens: state.tokens,
      activeTokenId: state.activeTokenId,
      nextTokenNumber: nextSavedToken,
    );
  }

  void addToken() {
    final token = CartToken(
      id: 'token_${DateTime.now().microsecondsSinceEpoch}',
      tokenNumber: state.nextTokenNumber,
    );
    state = CartState(
      tokens: [...state.tokens, token],
      activeTokenId: token.id,
      nextTokenNumber: state.nextTokenNumber + 1,
    );
  }

  void selectToken(String tokenId) {
    if (!state.tokens.any((token) => token.id == tokenId)) {
      return;
    }
    state = CartState(
      tokens: state.tokens,
      activeTokenId: tokenId,
      nextTokenNumber: state.nextTokenNumber,
    );
  }

  void addItem(InventoryItem item) {
    if (item.isTrackableInventory && state.availableFor(item) <= 0) {
      throw StateError('Not enough stock for ${item.name}.');
    }

    final items = state.activeToken.items;
    final index = items.indexWhere((cartItem) => cartItem.item.id == item.id);
    if (index == -1) {
      _replaceActiveToken(
        items: [
          ...items,
          CartItem(item: item, quantity: 1),
        ],
      );
      return;
    }

    final nextItems = [...items];
    final existing = nextItems[index];
    nextItems[index] = existing.copyWith(quantity: existing.quantity + 1);
    _replaceActiveToken(items: nextItems);
  }

  void increaseQuantity(InventoryItem item) => addItem(item);

  void decreaseQuantity(int inventoryItemId) {
    final nextItems = state.activeToken.items.map((cartItem) {
      if (cartItem.item.id != inventoryItemId) {
        return cartItem;
      }
      final nextQuantity = cartItem.quantity - 1;
      return cartItem.copyWith(quantity: nextQuantity < 1 ? 1 : nextQuantity);
    }).toList();
    _replaceActiveToken(items: nextItems);
  }

  void removeItem(int inventoryItemId) {
    _replaceActiveToken(
      items: state.activeToken.items
          .where((cartItem) => cartItem.item.id != inventoryItemId)
          .toList(),
    );
  }

  void clear() {
    _replaceActiveToken(items: const []);
  }

  void clearToken(String tokenId) {
    if (!state.tokens.any((token) => token.id == tokenId)) {
      return;
    }
    state = CartState(
      tokens: state.tokens
          .map(
            (token) =>
                token.id == tokenId ? token.copyWith(items: const []) : token,
          )
          .toList(),
      activeTokenId: state.activeTokenId,
      nextTokenNumber: state.nextTokenNumber,
    );
  }

  void closeActiveToken() {
    closeToken(state.activeTokenId);
  }

  void closeToken(String tokenId) {
    if (state.tokens.length == 1) {
      clearToken(tokenId);
      return;
    }
    final remaining = state.tokens
        .where((token) => token.id != tokenId)
        .toList();
    if (remaining.length == state.tokens.length) {
      return;
    }
    final activeTokenId = tokenId == state.activeTokenId
        ? remaining.last.id
        : state.activeTokenId;
    state = CartState(
      tokens: remaining,
      activeTokenId: activeTokenId,
      nextTokenNumber: state.nextTokenNumber,
    );
  }

  void completeActiveToken() {
    if (state.tokens.length == 1) {
      final token = CartToken(
        id: 'token_${DateTime.now().microsecondsSinceEpoch}',
        tokenNumber: state.nextTokenNumber,
      );
      state = CartState(
        tokens: [token],
        activeTokenId: token.id,
        nextTokenNumber: state.nextTokenNumber + 1,
      );
      return;
    }
    closeActiveToken();
  }

  void _replaceActiveToken({required List<CartItem> items}) {
    state = CartState(
      tokens: state.tokens
          .map(
            (token) => token.id == state.activeTokenId
                ? token.copyWith(items: items)
                : token,
          )
          .toList(),
      activeTokenId: state.activeTokenId,
      nextTokenNumber: state.nextTokenNumber,
    );
  }
}

class BillingController extends StateNotifier<AsyncValue<BillingOrder?>> {
  BillingController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<BillingRepository> get _repository =>
      _ref.read(billingRepositoryProvider.future);

  Future<BillingOrder> confirmPayment(PaymentMethod paymentMethod) async {
    final cart = _ref.read(cartProvider).activeToken;
    return _run(() async {
      final repository = await _repository;
      final now = nepaliNow();
      final orderId = 'ORD-${now.microsecondsSinceEpoch}';
      final draft = BillingOrder(
        id: 0,
        orderId: orderId,
        tokenNumber: cart.tokenNumber,
        items: cart.items
            .map(
              (cartItem) => BillingOrderItem(
                inventoryItemId: cartItem.item.id,
                itemName: cartItem.item.name,
                itemCode: cartItem.item.itemCode,
                unitPrice: cartItem.item.price,
                quantity: cartItem.quantity,
                lineTotal: cartItem.lineTotal,
              ),
            )
            .toList(growable: false),
        subtotal: cart.subtotal,
        totalAmount: cart.totalAmount,
        paymentMethod: paymentMethod,
        paymentStatus: PaymentStatus.paid,
        orderStatus: OrderStatus.paid,
        createdAt: now,
        nepaliDate: nepaliDateToday(),
      );

      final saved = await CreatePaidOrder(repository)(draft);
      _ref.read(cartProvider.notifier).completeActiveToken();
      _ref.invalidate(nextTokenProvider);
      return saved;
    });
  }

  Future<void> cancelOrder(int id) async {
    state = const AsyncLoading();
    try {
      final repository = await _repository;
      await CancelOrder(repository)(id);
      _ref.invalidate(nextTokenProvider);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<BillingOrder> _run(Future<BillingOrder?> Function() action) async {
    state = const AsyncLoading();
    try {
      final order = await action();
      state = AsyncData(order);
      if (order == null) {
        throw StateError('Order was not created.');
      }
      return order;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
