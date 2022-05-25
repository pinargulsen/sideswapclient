import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';

class MnemonicCheckRow extends ConsumerWidget {
  final int wordIndex;
  final List<String> words;
  final void Function(int) onTap;

  const MnemonicCheckRow({
    super.key,
    required this.wordIndex,
    required this.words,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORD_HASH'.tr(args: ['${wordIndex + 1}']),
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF00C5FF),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: SizedBox(
            height: 39.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(
                words.length,
                (int index) {
                  final selectionIndex = ref
                          .read(walletProvider)
                          .backupCheckSelectedWords[wordIndex] ??
                      -1;
                  final isSelected = selectionIndex == index;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.w),
                      onTap: () {
                        onTap(index);
                      },
                      child: Container(
                        width: 109.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF23729D),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          color: isSelected ? Colors.white : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            words[index],
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
