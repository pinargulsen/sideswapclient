import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class UiStatesListener extends ConsumerWidget {
  const UiStatesListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(uiStateArgsNotifierProvider, (((_, next) {
      final navigationItemEnum = next.navigationItemEnum;

      if (navigationItemEnum != WalletMainNavigationItemEnum.markets) {
        if (ref.read(marketsProvider).subscribedMarket !=
            SubscribedMarket.none) {
          ref.read(marketsProvider).unsubscribeMarket();
        }
      }

      if (navigationItemEnum != WalletMainNavigationItemEnum.markets &&
          navigationItemEnum != WalletMainNavigationItemEnum.swap) {
        if (ref
            .read(marketsProvider)
            .subscribedIndexPriceAssetId()
            .isNotEmpty) {
          ref.read(marketsProvider).unsubscribeIndexPrice();
        }
      }

      if (navigationItemEnum != WalletMainNavigationItemEnum.swap) {
        ref.read(walletProvider).unsubscribeFromPriceStream();
      }
    })));

    return const SizedBox();
  }
}
