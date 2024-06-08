import 'package:flutter/material.dart';
import '../../constants.dart';

class UpgradePremiumCard extends StatelessWidget {
  const UpgradePremiumCard({
    required this.onPressed,
    this.backgroundColor,
    super.key,
  });

  final Color? backgroundColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius),
      color: backgroundColor ?? Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 150,
            maxWidth: 250,
            minHeight: 150,
            maxHeight: 250,
          ),
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 80,
                ),
                child: Image.asset(
                  "assets/icons/chat.png",
                  fit: BoxFit.contain,
                ),
              ),
              const _Info(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(),
        const SizedBox(height: 2),
        _subtitle(),
        const SizedBox(height: 10),
        _price(),
      ],
    );
  }

  Widget _title() {
    return const Text(
      "Upgrade your account",
    );
  }

  Widget _subtitle() {
    return const Text(
      "in order to get full access",
      // style: Theme.of(Get.context!).textTheme.caption,
    );
  }

  Widget _price() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.1),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 10,
            color: kPrimaryColor,
            fontWeight: FontWeight.w200,
          ),
          children: [
            TextSpan(text: "3\$ "),
            TextSpan(
              text: "per application",
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}