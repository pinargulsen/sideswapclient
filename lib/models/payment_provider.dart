import 'package:fixnum/fixnum.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

final paymentProvider = Provider((ref) => PaymentProvider(ref.read));

class PaymentProvider with ChangeNotifier {
  final Reader read;

  PaymentProvider(this.read);

  bool _insufficientFunds = false;
  bool get insufficientFunds => _insufficientFunds;
  set insufficientFunds(bool insufficientFunds) {
    _insufficientFunds = insufficientFunds;
    notifyListeners();
  }

  String _sendAddrParsed = '';
  String get sendAddrParsed => _sendAddrParsed;
  set sendAddrParsed(String sendAddrParsed) {
    _sendAddrParsed = sendAddrParsed;
    notifyListeners();
  }

  int _sendAmountParsed = 0;
  int get sendAmountParsed => _sendAmountParsed;
  set sendAmountParsed(int sendAmountParsed) {
    _sendAmountParsed = sendAmountParsed;
    notifyListeners();
  }

  int _sendNetworkFee = 0;
  int get sendNetworkFee => _sendNetworkFee;
  set sendNetworkFee(int sendNetworkFee) {
    _sendNetworkFee = sendNetworkFee;
    notifyListeners();
  }

  PaymentAmountPageArguments paymentAmountPageArguments =
      PaymentAmountPageArguments();

  void selectPaymentAmountPage(PaymentAmountPageArguments arguments) {
    paymentAmountPageArguments = arguments;
    read(walletProvider).status = Status.paymentAmountPage;
    notifyListeners();
  }

  void selectPaymentSend(String amount, AccountAsset accountAsset,
      {Friend? friend, String? address}) {
    // TODO: handle friend payment send
    if (address == null) {
      logger.e('Address is null');
      return;
    }

    read(walletProvider).selectedWalletAsset = accountAsset;
    if (!read(walletProvider).isAddrValid(address, AddrType.elements)) {
      logger.e('Invalid address $address');
      return;
    }

    final precision = read(walletProvider)
        .getPrecisionForAssetId(assetId: accountAsset.asset);
    final _amount =
        read(walletProvider).parseAssetAmount(amount, precision: precision);
    final balance = read(balancesProvider)
        .balances[read(walletProvider).selectedWalletAsset];
    if (balance == null) {
      logger.e('Wrong balance for selected wallet asset');
      return;
    }

    if (_amount == null || _amount <= 0 || _amount > balance) {
      logger.e('Incorrect amount $_amount');
      return;
    }

    sendAddrParsed = address;
    sendAmountParsed = _amount;

    final createTx = To_CreateTx();
    createTx.addr = sendAddrParsed;
    createTx.balance = Balance();
    createTx.balance.amount = Int64(sendAmountParsed);
    createTx.balance.assetId = read(walletProvider).selectedWalletAsset!.asset;
    createTx.account = getAccount(accountAsset.account);
    read(walletProvider).createTx(createTx);

    notifyListeners();
  }
}
