import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';

class UrlLinkButton extends StatelessWidget {
  const UrlLinkButton({
    super.key,
    required this.text,
    this.url = '',
    this.icon,
    this.onPressed,
  });

  final String url;
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      width: double.maxFinite,
      height: 56.h,
      child: TextButton(
        onPressed: () async {
          if (url.isNotEmpty) {
            await openUrl(url);
            return;
          }
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: const Color(0xFF135579),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
            ),
          ),
          side: const BorderSide(
            color: Color(0xFF135579),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: icon,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF00C5FF),
                  textStyle: TextStyle(
                    decoration: url.isNotEmpty
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
