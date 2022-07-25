import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';

class WalletLocked extends ConsumerWidget {
  const WalletLocked({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            ref.read(walletProvider).unlockWallet();
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 92),
                    child: SizedBox(
                      width: 158,
                      height: 158,
                      child: SvgPicture.asset('assets/logo.svg'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 236),
                    child: Icon(
                      Icons.fingerprint,
                      size: 46,
                      color: Color(0xFFC6E8FD),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Touch to unlock'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFC6E8FD),
                      ),
                    ),
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
