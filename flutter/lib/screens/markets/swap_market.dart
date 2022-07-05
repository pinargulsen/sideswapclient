import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/swap_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class SwapMarket extends ConsumerStatefulWidget {
  const SwapMarket({super.key});

  @override
  SwapMarketState createState() => SwapMarketState();
}

class SwapMarketState extends ConsumerState<SwapMarket> {
  ScrollController scrollController = ScrollController();

  final headerStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00C5FF),
  );

  final indexPriceStyleDescription = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  void afterBuild(BuildContext context) async {
    subscribeToMarket();
  }

  void subscribeToMarket() {
    final marketAssetId = ref.read(swapMarketProvider).currentProduct.assetId;

    ref.read(marketsProvider).subscribeIndexPrice(marketAssetId);
    ref.read(marketsProvider).subscribeSwapMarket(marketAssetId);
  }

  void openOrder(RequestOrder order) async {
    if (order.own) {
      await ref.read(marketsProvider).onModifyPrice(ref, order);
      return;
    }

    if (order.marketType != MarketType.token) {
      ref.read(walletProvider).linkOrder(order.orderId);
      return;
    }

    Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(
        builder: (context) => TokenMarketOrderDetails(
          requestOrder: order,
        ),
      ),
    );

    // TODO: mockups points here to SwapMarketOrderDetails
    // but that screen display wrong side data
    // consider how to back from Status.orderPopup
    // to markets page
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final swapMarket = ref.watch(swapMarketProvider);
      final wallet = ref.read(walletProvider);
      final markets = ref.watch(marketsProvider);

      final currentProduct = swapMarket.currentProduct;
      final asset = wallet.assets[currentProduct.assetId]!;
      final isAmp = asset.ampMarket;
      final indexPrice = markets.getIndexPriceStr(currentProduct.assetId);
      final lastPrice = markets.getLastPriceStr(currentProduct.assetId);
      final priceIcon = isAmp
          ? wallet.assetImagesSmall[wallet.liquidAssetId()]
          : wallet.assetImagesSmall[currentProduct.assetId];
      final priceTicker = isAmp ? kLiquidBitcoinTicker : currentProduct.ticker;
      final products = swapMarket.getProducts();
      final length = swapMarket.getMaxSwapOrderLength();
      final bidOffers = swapMarket.bidOffers;
      final askOffers = swapMarket.askOffers;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24.h, left: 16.w, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAmp ? 'Last price'.tr() : 'Index price'.tr(),
                      style: headerStyle,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Text(
                                  isAmp ? lastPrice : indexPrice,
                                  style: indexPriceStyleDescription,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: SizedBox(
                                  width: 21.r,
                                  height: 21.r,
                                  child: priceIcon,
                                ),
                              ),
                              Text(
                                priceTicker,
                                style: indexPriceStyleDescription,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ColoredContainer(
                  width: 135.w,
                  height: 39.h,
                  child: DropdownButton<Product>(
                    value: currentProduct,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E6389),
                    underline: Container(),
                    iconSize: 18,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    items: products
                        .map((e) => DropdownMenuItem<Product>(
                              value: e,
                              child: Text(
                                e.displayName,
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      ref.read(swapMarketProvider).currentProduct = value;
                      subscribeToMarket();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
            child: const Divider(
              thickness: 1,
              height: 1,
              color: Color(0xFF2B6F95),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 14.w, right: 14.w),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount'.tr(),
                        style: headerStyle,
                      ),
                      Text(
                        'Bid'.tr(),
                        style: headerStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 11.w,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Offer'.tr(),
                        style: headerStyle,
                      ),
                      Text(
                        'Amount'.tr(),
                        style: headerStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RawScrollbar(
              thumbVisibility: true,
              thickness: 3,
              radius: Radius.circular(2.r),
              controller: scrollController,
              thumbColor: const Color(0xFF78AECC),
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      if (index < bidOffers.length) ...[
                        Padding(
                          padding: EdgeInsets.only(left: 6.w),
                          child: SwapAmountRow(
                            isAmp: isAmp,
                            assetPrecision: asset.precision,
                            requestOrder: bidOffers[index],
                            onTap: openOrder,
                          ),
                        ),
                        const Spacer(),
                      ],
                      if (index < askOffers.length) ...[
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: SwapAmountRow(
                            isAmp: isAmp,
                            assetPrecision: asset.precision,
                            requestOrder: askOffers[index],
                            type: SwapAmountRowType.ask,
                            onTap: openOrder,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}

enum SwapAmountRowType {
  bid,
  ask,
}

class SwapAmountRow extends StatelessWidget {
  SwapAmountRow({
    super.key,
    required this.requestOrder,
    required this.isAmp,
    required this.assetPrecision,
    this.type = SwapAmountRowType.bid,
    this.onTap,
  });

  final RequestOrder requestOrder;
  final SwapAmountRowType type;
  final bool isAmp;
  final int assetPrecision;
  final Function(RequestOrder)? onTap;

  final amountStyle = GoogleFonts.roboto(
    fontSize: 13.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final amountString = isAmp
        ? amountStr(requestOrder.assetAmount, precision: assetPrecision)
        : amountStr(requestOrder.bitcoinAmount);
    final price =
        priceStrForMarket(requestOrder.price, requestOrder.marketType);
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomPaint(
        painter: SwapAmountRowBackground(
          expiresAt: requestOrder.expiresAt,
          createdAt: requestOrder.createdAt,
          type: type,
          radius: Radius.circular(4.r),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!(requestOrder);
              }
            },
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
            child: SizedBox(
              width: 181.w,
              child: Stack(
                children: [
                  if (requestOrder.own) ...[
                    Positioned(
                      right: 5.w,
                      top: 3.h,
                      child: Container(
                        width: 4.r,
                        height: 4.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2CCCBF),
                        ),
                      ),
                    ),
                  ],
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                    child: Builder(builder: (context) {
                      var children = [
                        Text(
                          amountString,
                          style: amountStyle,
                        ),
                        Text(
                          price,
                          style: amountStyle.copyWith(
                            color: type == SwapAmountRowType.bid
                                ? const Color(0xFF2CCCBF)
                                : const Color(0xFFFF7878),
                          ),
                        ),
                      ];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: type == SwapAmountRowType.bid
                            ? children
                            : children.reversed.toList(),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwapAmountRowBackground extends CustomPainter {
  final int expiresAt;
  final int createdAt;
  final SwapAmountRowType type;
  final Radius radius;
  final bool displayTimer = false;

  SwapAmountRowBackground({
    required this.expiresAt,
    required this.createdAt,
    this.type = SwapAmountRowType.bid,
    this.radius = const Radius.circular(0),
  });

  late Color expireColor = type == SwapAmountRowType.bid
      ? const Color(0xFF2CCCBF)
      : const Color(0xFFFF7878);
  Color backgroundColor = const Color(0xFF135579);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = backgroundColor;
    final rect = Offset.zero & size;

    if (!displayTimer) {
      var expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      if (type == SwapAmountRowType.ask) {
        expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      }
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), expirePaint);
      return;
    }

    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), backgroundPaint);

    final expired = DateTime.fromMillisecondsSinceEpoch(expiresAt);
    final created = DateTime.fromMillisecondsSinceEpoch(createdAt);

    final maxSeconds = expired.difference(created).inSeconds;
    final currentSeconds = expired.difference(DateTime.now()).inSeconds;

    var expireWidth = convertToNewRange(
      value: currentSeconds.toDouble(),
      minValue: 0,
      maxValue: maxSeconds.toDouble(),
      newMin: 0,
      newMax: rect.width,
    );

    if (expireWidth < 0) {
      expireWidth = 0;
    }

    if (type == SwapAmountRowType.bid) {
      final expireRect = Rect.fromLTRB(
          rect.right - expireWidth, rect.top, rect.right, rect.bottom);
      final expirePaint = Paint()..color = expireColor.withOpacity(0.14);
      final widthDiff = rect.width - expireWidth;
      if (widthDiff >= radius.x) {
        canvas.drawRRect(
            RRect.fromRectAndCorners(expireRect,
                topRight: radius, bottomRight: radius),
            expirePaint);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(expireRect, radius), expirePaint);
      }
    } else {
      final expireRect = Rect.fromLTRB(
          rect.left, rect.top, rect.left + expireWidth, rect.bottom);
      final expirePaint = Paint()..color = expireColor.withOpacity(0.24);
      final widthDiff = rect.width - expireWidth;
      if (widthDiff >= radius.x) {
        canvas.drawRRect(
            RRect.fromRectAndCorners(expireRect,
                topLeft: radius, bottomLeft: radius),
            expirePaint);
      } else {
        canvas.drawRRect(
            RRect.fromRectAndRadius(expireRect, radius), expirePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
