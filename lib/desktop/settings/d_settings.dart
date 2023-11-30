import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_settings_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_delete_wallet.dart';
import 'package:sideswap/desktop/settings/d_settings_jade_device.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_disable_success.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_languages.dart';

class DSettings extends ConsumerWidget {
  const DSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;
    final isPinEnabled = ref.watch(pinAvailableProvider);
    final isJade = ref.watch(isJadeWalletProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('Settings'.tr()),
          onClose: () {
            ref.read(walletProvider).goBack();
          },
        ),
        content: Center(
          child: SizedBox(
            height: 509,
            child: Column(
              children: [
                switch (isJade) {
                  true => const SizedBox(),
                  false => DSettingsButton(
                      title: 'View my recovery phrase'.tr(),
                      onPressed: () {
                        ref.read(walletProvider).settingsViewBackup();
                      },
                      icon: DSettingsButtonIcon.recovery,
                    ),
                },
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DSettingsButton(
                    title: 'About us'.tr(),
                    onPressed: () {
                      ref.read(walletProvider).settingsViewAboutUs();
                    },
                    icon: DSettingsButtonIcon.about,
                  ),
                ),
                switch (isJade) {
                  true => const SizedBox(),
                  false => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DSettingsButton(
                            title: 'PIN protection'.tr(),
                            onPressed: () async {
                              if (isPinEnabled) {
                                final navigator = Navigator.of(context);
                                final ret = await ref
                                    .read(walletProvider)
                                    .disablePinProtection();
                                if (ret) {
                                  ref.read(walletProvider).setRegistered();
                                  navigator.pushAndRemoveUntil(
                                      RawDialogRoute<Widget>(
                                        pageBuilder: (_, __, ___) =>
                                            const DSettingsPinDisableSuccess(),
                                      ),
                                      (route) => route.isFirst);
                                }
                              } else {
                                ref
                                    .read(pinSetupProvider)
                                    .initPinSetupSettings();
                              }
                            },
                            icon: DSettingsButtonIcon.password,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: DSettingsButton(
                            title: 'Network access'.tr(),
                            onPressed: () {
                              ref.read(walletProvider).settingsNetwork();
                            },
                            icon: DSettingsButtonIcon.network,
                          ),
                        ),
                      ],
                    ),
                },
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DSettingsButton(
                    title: 'FAQ'.tr(),
                    onPressed: () async {
                      await openUrl(SettingsAboutUsData.urlFaq);
                    },
                    icon: DSettingsButtonIcon.faq,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: DSettingsButton(
                    title: 'Language'.tr(),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push<void>(
                          DialogRoute(
                              builder: ((context) => const Languages()),
                              context: context));
                    },
                    icon: DSettingsButtonIcon.language,
                  ),
                ),
                switch (isJade) {
                  true => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DSettingsButton(
                        title: 'Jade device',
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push<void>(
                              DialogRoute(
                                  builder: ((context) =>
                                      const DSettingsJadeDevice()),
                                  context: context));
                        },
                      ),
                    ),
                  false => const SizedBox(),
                },
                switch (FlavorConfig.enableLocalEndpoint) {
                  true => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: DSettingsButton(
                        title: 'Use local api server',
                        forward: false,
                        onPressed: () {
                          final enableEndpoint =
                              ref.read(configProvider).enableEndpoint;
                          ref
                              .read(configProvider)
                              .setEnableEndpoint(!enableEndpoint);
                        },
                        child: Consumer(
                          builder: (context, ref, child) {
                            final enableEndpoint =
                                ref.watch(configProvider).enableEndpoint;
                            return IgnorePointer(
                              child: FlutterSwitch(
                                value: enableEndpoint,
                                onToggle: (value) {
                                  if (value) {
                                    ref
                                        .read(configProvider)
                                        .setEnableEndpoint(!true);
                                    return;
                                  }

                                  ref
                                      .read(configProvider)
                                      .setEnableEndpoint(false);
                                },
                                width: 40,
                                height: 22,
                                toggleSize: 18,
                                padding: 2,
                                activeColor: SideSwapColors.brightTurquoise,
                                inactiveColor: const Color(0xFF0B4160),
                                toggleColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  false => const SizedBox(),
                },
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 48),
                  child: DSettingsButton(
                    forward: false,
                    title: 'Delete wallet'.tr(),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil<Widget>(
                          RawDialogRoute(
                              pageBuilder: (_, __, ___) =>
                                  const DSettingsDeleteWallet()),
                          (route) => route.isFirst);
                    },
                    icon: DSettingsButtonIcon.delete,
                  ),
                ),
              ],
            ),
          ),
        ),
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}
