import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/settings/settings_custom_host.dart';
import 'package:sideswap/screens/settings/widgets/settings_network_button.dart';

class SettingsNetwork extends StatefulWidget {
  const SettingsNetwork({Key? key}) : super(key: key);

  @override
  _SettingsNetworkState createState() => _SettingsNetworkState();
}

class _SettingsNetworkState extends State<SettingsNetwork> {
  void showRestartDialog() {
    context.read(utilsProvider).settingsErrorDialog(
          title: 'Network changes will take effect on restart'.tr(),
          buttonText: 'RESTART APP'.tr(),
          onPressed: (context) {},
          secondButtonText: 'CANCEL'.tr(),
          onSecondPressed: (context) {
            Navigator.of(context).pop();
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Network access'.tr(),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
                  child: Consumer(
                    builder: (context, watch, child) {
                      final networkType =
                          watch(networkAccessProvider).networkType;
                      return Column(
                        children: [
                          // SettingsNetworkButton(
                          //   value: networkType == SettingsNetworkType.sideswap,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       context
                          //           .read(networkAccessProvider)
                          //           .networkType = SettingsNetworkType.sideswap;
                          //     });
                          //   },
                          //   title: Padding(
                          //     padding: EdgeInsets.only(left: 10.w),
                          //     child: Text(
                          //       'SideSwap'.tr(),
                          //       style: GoogleFonts.roboto(
                          //         fontSize: 16.sp,
                          //         fontWeight: FontWeight.normal,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: SettingsNetworkButton(
                              value: networkType ==
                                  SettingsNetworkType.blockstream,
                              onChanged: (value) {
                                setState(() {
                                  context
                                          .read(networkAccessProvider)
                                          .networkType =
                                      SettingsNetworkType.blockstream;
                                  context
                                      .read(walletProvider)
                                      .applyNetworkChange();
                                });
                              },
                              title: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  'Blockstream'.tr(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: SettingsNetworkButton(
                              trailingIconVisible: true,
                              value: networkType == SettingsNetworkType.custom,
                              onChanged: (value) {
                                Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsCustomHost(),
                                  ),
                                );
                              },
                              title: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  'Custom'.tr(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
