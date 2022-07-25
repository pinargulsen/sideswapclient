import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/wallet.dart';

class AssetSearchTextField extends ConsumerWidget {
  const AssetSearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: TextField(
        onChanged: (value) =>
            ref.read(walletProvider).setToggleAssetFilter(value),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.normal,
          color: Color(0xFF055271),
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: SizedBox(
            width: 41,
            child: Center(
              child: SvgPicture.asset(
                'assets/search.svg',
                width: 19,
                height: 19,
                color: const Color(0xFF055271),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: 'Search'.tr(),
          hintStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Color(0xFF84ADC6),
          ),
        ),
      ),
    );
  }
}
