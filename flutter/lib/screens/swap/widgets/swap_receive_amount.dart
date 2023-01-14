import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:easy_localization/easy_localization.dart';

class SwapReceiveAmount extends HookConsumerWidget {
  const SwapReceiveAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapRecvAssets = ref.watch(swapProvider).swapRecvAssets();
    final swapRecvAsset =
        ref.watch(swapProvider.select((p) => p.swapRecvAsset!));
    final swapRecvWallet =
        ref.watch(swapProvider.select((p) => p.swapRecvWallet));
    final precision = ref
        .watch(walletProvider)
        .getPrecisionForAssetId(assetId: swapRecvAsset.asset);
    final swapRecvAccount = AccountAsset(AccountType.reg, swapRecvAsset.asset);
    final balance =
        ref.watch(balancesProvider.select((p) => p.balances[swapRecvAccount]));
    final balanceStr = amountStr(balance ?? 0, precision: precision);
    final swapType = ref.watch(swapProvider).swapType();
    final swapState = ref.watch(swapStateProvider);

    // Show error in one place only
    final subscribe = ref.watch(swapPriceSubscribeStateNotifierProvider);
    final serverError = subscribe != const SwapPriceSubscribeStateRecv()
        ? ''
        : ref.watch(swapNetworkErrorStateProvider);
    final feeRates = ref.watch(bitcoinFeeRatesProvider).feeRates;
    final addressErrorText = ref.watch(swapAddressErrorStateProvider);
    final showAddressLabel = ref.watch(showAddressLabelStateProvider);

    final swapRecvAmountController = useTextEditingController();
    final swapAddressRecvController = useTextEditingController();
    final receiveFocusNode = useFocusNode();

    ref.listen<SwapRecvAmountProvider>(swapRecvAmountChangeNotifierProvider,
        (previous, next) {
      final newValue = replaceCharacterOnPosition(
        input: next.amount,
      );

      swapRecvAmountController.value = fixCursorPosition(
          controller: swapRecvAmountController, newValue: newValue);
    });

    ref.listen<SwapChangeNotifierProvider>(swapProvider, (_, next) {
      final externalAddress = swapAddressRecvController.text;
      if (externalAddress != next.swapRecvAddressExternal) {
        swapAddressRecvController.text = next.swapRecvAddressExternal;
      }
    });

    return SwapSideAmount(
      text: 'Receive'.tr(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: swapRecvAmountController,
      addressController: swapAddressRecvController,
      isMaxVisible: false,
      readOnly: swapType == SwapType.pegIn || swapState != SwapState.idle,
      hintText: '0.0',
      showHintText: swapType == SwapType.atomic,
      dropdownReadOnly: swapType == SwapType.atomic && swapRecvAssets.length > 1
          ? false
          : true,
      onEditingCompleted: () {
        if (ref.read(swapEnabledStateProvider)) {
          ref.read(swapProvider).swapAccept();
        }
      },
      feeRates: feeRates,
      visibleToggles: false,
      balance: balanceStr,
      dropdownValue: swapRecvAsset,
      availableAssets: swapRecvAssets,
      labelGroupValue: swapRecvWallet,
      addressErrorText: addressErrorText,
      focusNode: receiveFocusNode,
      isAddressLabelVisible: showAddressLabel,
      swapType: swapType,
      showInsufficientFunds: false,
      errorDescription: serverError,
      localLabelOnChanged: (value) =>
          ref.read(swapProvider).setRecvRadioCb(SwapWallet.local),
      externalLabelOnChanged: (value) =>
          ref.read(swapProvider).setRecvRadioCb(SwapWallet.extern),
      onDropdownChanged: ref.read(swapProvider).setReceiveAsset,
      onChanged: (value) {
        ref.read(swapStateProvider.notifier).state = SwapState.idle;
        ref.read(swapSendAmountChangeNotifierProvider.notifier).setAmount('0');

        ref
            .read(swapRecvAmountChangeNotifierProvider.notifier)
            .setAmount(value);

        ref.read(swapPriceSubscribeStateNotifierProvider.notifier).setRecv();
        ref
            .read(priceStreamSubscribeChangeNotifierProvider)
            .subscribeToPriceStream();
      },
      onAddressEditingCompleted: () async {
        ref.read(swapProvider).swapRecvAddressExternal =
            swapAddressRecvController.text;
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onAddressChanged: (text) {
        ref.read(swapProvider).swapRecvAddressExternal = text;
      },
      onAddressLabelClose: () {
        ref.read(showAddressLabelStateProvider.notifier).state = false;
        ref.read(swapProvider).swapRecvAddressExternal = '';
      },
      showAccountsInPopup: true,
    );
  }
}
