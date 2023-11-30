import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'wallet_account_providers.g.dart';

@Riverpod(keepAlive: true)
class DefaultAccountsState extends _$DefaultAccountsState {
  @override
  Set<AccountAsset> build() {
    return <AccountAsset>{};
  }

  void insertAccountAsset({required AccountAsset accountAsset}) {
    state = {...state, accountAsset};
  }
}

@riverpod
List<AccountAsset> predefinedAccountAssets(PredefinedAccountAssetsRef ref) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  return [
    AccountAsset(AccountType.reg, liquidAssetId),
    AccountAsset(AccountType.amp, liquidAssetId),
  ];
}

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///
@riverpod
List<AccountAsset> allAlwaysShowAccountAssets(
    AllAlwaysShowAccountAssetsRef ref) {
  final allAssets = ref.watch(accountAssetTransactionsProvider);
  final assets = ref.watch(assetsStateProvider);
  final predefinedAccountAssets = ref.watch(predefinedAccountAssetsProvider);
  // Use array to show registered on the server assets first
  final allAlwaysShowAccountAssets = <AccountAsset>[];
  allAlwaysShowAccountAssets.addAll(predefinedAccountAssets);

  for (final asset in assets.values) {
    if (asset.swapMarket && asset.alwaysShow) {
      allAlwaysShowAccountAssets
          .add(AccountAsset(AccountType.reg, asset.assetId));
    } else if (asset.ampMarket && asset.alwaysShow) {
      allAlwaysShowAccountAssets
          .add(AccountAsset(AccountType.amp, asset.assetId));
    }
  }

  final remainingAccountAssets =
      allAssets.keys.toSet().difference(allAlwaysShowAccountAssets.toSet());
  for (final account in remainingAccountAssets) {
    allAlwaysShowAccountAssets.add(account);
  }

  return allAlwaysShowAccountAssets;
}

@riverpod
List<AccountAsset> allVisibleAccountAssets(AllVisibleAccountAssetsRef ref) {
  final allAccounts = ref.watch(allAlwaysShowAccountAssetsProvider);
  final defaultAccounts = ref.watch(defaultAccountsStateProvider);
  final balances = ref.watch(balancesProvider);

  final allVisibleAccounts = allAccounts
      .where(
          (e) => defaultAccounts.contains(e) || (balances.balances[e] ?? 0) > 0)
      .toList();

  return allVisibleAccounts;
}

@riverpod
List<AccountAsset> regularVisibleAccountAssets(
    RegularVisibleAccountAssetsRef ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);
  final regularAccounts =
      allVisibleAccounts.where((e) => e.account.isRegular).toList();
  return regularAccounts;
}

@riverpod
List<AccountAsset> ampVisibleAccountAssets(AmpVisibleAccountAssetsRef ref) {
  final allVisibleAccounts = ref.watch(allVisibleAccountAssetsProvider);
  final ampAccounts = allVisibleAccounts.where((e) => e.account.isAmp).toList();
  return ampAccounts;
}

/// Needed by ui parts which want to search assetid over all assets - ex. market
///
@riverpod
List<AccountAsset> allAccountAssets(AllAccountAssetsRef ref) {
  final allAssets = ref.watch(accountAssetTransactionsProvider);
  final assets = ref.watch(assetsStateProvider);
  final predefinedAccountAssets = ref.watch(predefinedAccountAssetsProvider);
  // Use array to show registered on the server assets first
  final allAccountAssets = <AccountAsset>[];
  allAccountAssets.addAll(predefinedAccountAssets);

  for (final asset in assets.values) {
    final accountAsset = switch (asset) {
      Asset(:final ampMarket, :final assetId) when ampMarket =>
        AccountAsset(AccountType.amp, assetId),
      _ => AccountAsset(AccountType.reg, asset.assetId),
    };
    allAccountAssets.add(accountAsset);
  }

  final remainingAccountAssets =
      allAssets.keys.toSet().difference(allAccountAssets.toSet());
  for (final account in remainingAccountAssets) {
    allAccountAssets.add(account);
  }

  return allAccountAssets;
}

@riverpod
List<AccountAsset> regularAccountAssets(RegularAccountAssetsRef ref) {
  final allAccountAssets = ref.watch(allAccountAssetsProvider);
  return allAccountAssets.where((e) => e.account.isRegular).toList();
}

@riverpod
List<AccountAsset> ampAccountAssets(AmpAccountAssetsRef ref) {
  final allAccountAssets = ref.watch(allAccountAssetsProvider);
  return allAccountAssets.where((e) => e.account.isAmp).toList();
}

@riverpod
MarketType marketTypeForAccountAsset(
    MarketTypeForAccountAssetRef ref, AccountAsset? accountAsset) {
  final allAssets = ref.watch(assetsStateProvider);
  final asset = allAssets.values
      .firstWhereOrNull((e) => e.assetId == accountAsset?.assetId);
  return getMarketType(asset);
}
