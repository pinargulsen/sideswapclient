import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/payment_requests_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';
import 'package:sideswap/screens/markets/confirm_request_payment.dart';

class RequestPaymentItem extends ConsumerWidget {
  const RequestPaymentItem(
      {super.key, required this.request, required this.onCancelPressed});

  final PaymentRequest request;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = 158.0;
    var header = 'Sent'.tr();
    final dateFormat = DateFormat('dd MMMM yyyy');

    if (request.type == PaymentRequestType.received) {
      height = 214;
      header = 'Received'.tr();
    }

    return Container(
      width: double.maxFinite,
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFF1D6389),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$header - ${dateFormat.format(request.dateTime)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Color(0xFF709EBA),
              ),
            ),
            FriendWidget(
              friend: request.friend,
              showTrailingIcon: false,
              contentPadding: EdgeInsets.zero,
              customDescription: Row(
                children: [
                  Text(
                    request.amount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ref
                            .read(walletProvider)
                            .assetImagesSmall[request.assetId] ??
                        Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      ref
                              .read(walletProvider)
                              .assets[request.assetId]
                              ?.ticker ??
                          '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                request.message ?? '',
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            if (request.type == PaymentRequestType.received) ...[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBigButton(
                      width: 151,
                      height: 36,
                      text: 'CANCEL'.tr(),
                      onPressed: onCancelPressed,
                      backgroundColor: Colors.transparent,
                      side:
                          const BorderSide(color: Color(0xFF00C5FF), width: 2),
                    ),
                    CustomBigButton(
                      width: 151,
                      height: 36,
                      text: 'SEND'.tr(),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push<void>(
                          MaterialPageRoute(
                            builder: (context) => ConfirmRequestPayment(
                              request: request,
                            ),
                          ),
                        );
                      },
                      backgroundColor: const Color(0xFF00C5FF),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
