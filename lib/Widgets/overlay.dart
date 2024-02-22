import 'package:flutter/material.dart';

class OverLay extends StatelessWidget {
  const OverLay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black54,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 150,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                Text(
                  'Loading ...',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).secondaryHeaderColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
