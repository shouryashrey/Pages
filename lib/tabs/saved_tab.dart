import 'package:flutter/material.dart';
import 'package:pages/widgets/custom_action_bar.dart';

import '../constants.dart';

class SavedTab extends StatelessWidget {
  // const SavedTab({Key? key}) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(child: Text('Saved Tab', style: Constants.regularDarkText)),
          CustomActionBar(
            title: 'Saved',
            hasBackArrrow: false,
          ),
        ],
      ),
    );
  }
}
