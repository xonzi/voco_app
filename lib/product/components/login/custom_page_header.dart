// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:voco_app/product/utility/assets_manager.dart';

// ignore: camel_case_types, unused_field
enum _images { logo, logo_white }

class CustomPageHeader {
  static Stack customPageHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
        )),
        Positioned(
          right: 0,
          left: 0,
          top: 100,
          child: AssetManager.getPngImageSizedNFilled(
            _images.logo_white.name,
            alignment: Alignment.center,
            fit: BoxFit.scaleDown,
            height: 150,
          ),
        ),
      ],
    );
  }
}
