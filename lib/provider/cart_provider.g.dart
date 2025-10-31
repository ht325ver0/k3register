// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regularCartTotalHash() => r'7accd4541aa951e09981d829f6bfb59c4dac9f75';

/// カート内の商品の定価合計金額を計算するProvider
///
/// Copied from [regularCartTotal].
@ProviderFor(regularCartTotal)
final regularCartTotalProvider = AutoDisposeProvider<int>.internal(
  regularCartTotal,
  name: r'regularCartTotalProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regularCartTotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegularCartTotalRef = AutoDisposeProviderRef<int>;
String _$cartTotalHash() => r'660944169ac96cdb32cc9ac3267119e274927e8a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// カート内の商品の合計金額を計算するProvider
/// cartProviderの状態が変更されると、このProviderも自動的に再計算される
///
/// Copied from [cartTotal].
@ProviderFor(cartTotal)
const cartTotalProvider = CartTotalFamily();

/// カート内の商品の合計金額を計算するProvider
/// cartProviderの状態が変更されると、このProviderも自動的に再計算される
///
/// Copied from [cartTotal].
class CartTotalFamily extends Family<int> {
  /// カート内の商品の合計金額を計算するProvider
  /// cartProviderの状態が変更されると、このProviderも自動的に再計算される
  ///
  /// Copied from [cartTotal].
  const CartTotalFamily();

  /// カート内の商品の合計金額を計算するProvider
  /// cartProviderの状態が変更されると、このProviderも自動的に再計算される
  ///
  /// Copied from [cartTotal].
  CartTotalProvider call(
    List<String> requiredParts,
  ) {
    return CartTotalProvider(
      requiredParts,
    );
  }

  @override
  CartTotalProvider getProviderOverride(
    covariant CartTotalProvider provider,
  ) {
    return call(
      provider.requiredParts,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cartTotalProvider';
}

/// カート内の商品の合計金額を計算するProvider
/// cartProviderの状態が変更されると、このProviderも自動的に再計算される
///
/// Copied from [cartTotal].
class CartTotalProvider extends AutoDisposeProvider<int> {
  /// カート内の商品の合計金額を計算するProvider
  /// cartProviderの状態が変更されると、このProviderも自動的に再計算される
  ///
  /// Copied from [cartTotal].
  CartTotalProvider(
    List<String> requiredParts,
  ) : this._internal(
          (ref) => cartTotal(
            ref as CartTotalRef,
            requiredParts,
          ),
          from: cartTotalProvider,
          name: r'cartTotalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cartTotalHash,
          dependencies: CartTotalFamily._dependencies,
          allTransitiveDependencies: CartTotalFamily._allTransitiveDependencies,
          requiredParts: requiredParts,
        );

  CartTotalProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requiredParts,
  }) : super.internal();

  final List<String> requiredParts;

  @override
  Override overrideWith(
    int Function(CartTotalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CartTotalProvider._internal(
        (ref) => create(ref as CartTotalRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requiredParts: requiredParts,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _CartTotalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartTotalProvider && other.requiredParts == requiredParts;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requiredParts.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CartTotalRef on AutoDisposeProviderRef<int> {
  /// The parameter `requiredParts` of this provider.
  List<String> get requiredParts;
}

class _CartTotalProviderElement extends AutoDisposeProviderElement<int>
    with CartTotalRef {
  _CartTotalProviderElement(super.provider);

  @override
  List<String> get requiredParts => (origin as CartTotalProvider).requiredParts;
}

String _$cartHash() => r'48d2b14457d5bae68dc55ce707658784d6f4e7e7';

/// See also [Cart].
@ProviderFor(Cart)
final cartProvider =
    AutoDisposeNotifierProvider<Cart, List<CartProduct>>.internal(
  Cart.new,
  name: r'cartProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Cart = AutoDisposeNotifier<List<CartProduct>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
