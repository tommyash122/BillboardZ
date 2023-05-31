import 'package:billboardz/screens/widgets/listing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (ctx, lstSnapshots) {
        if (lstSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!lstSnapshots.hasData || lstSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No items found'),
          );
        }

        if (lstSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedItems = lstSnapshots.data!.docs;
        

        return ListView.builder(
          itemCount: loadedItems.length,
          itemBuilder: (ctx, index) {
            final itemId = loadedItems[index].data();
            final details = loadedItems[index].data()['details'][0];
            if (details == null || details.length == 0) {
              //TODO: add some nice icon
              return const Center(child: Text('No items found'));
            }

            return ListingWidget(
              details: details,
              itemId: itemId,
            );
          },
        );
      },
    );
  }
}
