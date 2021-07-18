import 'package:flutter/material.dart';
import 'package:pages/widgets/custom_action_bar.dart';

import '../constants.dart';

class SearchTab extends StatelessWidget {
  // const SearchTab({Key? key}) : super(key: key);
//
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(child: Text('Search Tab', style: Constants.regularDarkText)),
          CustomActionBar(
            title: 'Search',
            hasBackArrrow: false,
          ),
        ],
      ),
    );
  }
}
