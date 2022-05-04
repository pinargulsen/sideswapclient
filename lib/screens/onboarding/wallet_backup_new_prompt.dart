import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';
import 'package:sideswap/screens/onboarding/widgets/wallet_backup_new_prompt_dialog.dart';

class WalletBackupNewPrompt extends ConsumerWidget {
  const WalletBackupNewPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // clear pin new wallet state
    ref.read(pinSetupProvider).isNewWallet = false;

    return SideSwapScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 56.h),
                    child: SvgPicture.asset(
                      'assets/shield_big.svg',
                      width: 182.w,
                      height: 202.h,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 113.h),
                    child: SvgPicture.asset(
                      'assets/locker.svg',
                      width: 54.w,
                      height: 73.h,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Do you wish to backup your wallet?'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
              child: Text(
                'Protect your assets by ensuring you save the 12 work recovery phrase which can restore your wallet'
                    .tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: PageDots(
                maxSelectedDots:
                    FlavorConfig.enableOnboardingUserFeatures ? 1 : 4,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomBigButton(
                width: double.infinity,
                height: 54.h,
                text: 'YES'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: () {
                  ref.read(walletProvider).backupNewWalletEnable();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54.h,
                  text: 'NOT NOW'.tr(),
                  textColor: const Color(0xFF00C5FF),
                  backgroundColor: Colors.transparent,
                  onPressed: () async {
                    showWalletBackupDialog(ref, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
