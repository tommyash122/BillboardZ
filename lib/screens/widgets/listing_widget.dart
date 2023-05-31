import 'package:billboardz/screens/widgets/image_circle.dart';
import 'package:flutter/material.dart';

class ListingWidget extends StatefulWidget {
  final Map<String, dynamic> details;
  final Map<String, dynamic> itemId;

  const ListingWidget({Key? key, required this.details, required this.itemId})
      : super(key: key);

  @override
  ListingWidgetState createState() => ListingWidgetState();
}

class ListingWidgetState extends State<ListingWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final borderTitle = widget.details['board title'];
    final imageUrl = widget.itemId['fileDownload'];

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Row(
              children: [
                if (imageUrl != '') ImageCircle(imageUrl: imageUrl),
                if (imageUrl == '')
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.add_a_photo_outlined),
                  ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borderTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (isExpanded) ..._buildDetails(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetails() {
    final details = widget.details;
    final firstName = details['contact\'s first name'];
    final lastName = details['contact\'s last name'];
    final phoneNumber = details['contact\'s phone number'].toString();
    final country = details['country'];
    final city = details['city'];
    final street = details['street'];
    final streetNumber = details['streetNumber'].toString();
    final price = details['price'].toString();
    final screenTime = details['screenTime'].toString();
    final resolution1 = details['board\'s resolution'][0].toString();
    final resolution2 = details['board\'s resolution'][1].toString();
    final description = details['description'];

    const labelStyle = TextStyle(color: Colors.black);
    final valueStyle = TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 17);

    return [
      const SizedBox(height: 8),
      _buildRichText('First Name: ', firstName, labelStyle, valueStyle),
      _buildRichText('Last Name: ', lastName, labelStyle, valueStyle),
      _buildRichText('Phone Number: ', phoneNumber, labelStyle, valueStyle),
      _buildRichText('Country: ', country, labelStyle, valueStyle),
      _buildRichText('City: ', city, labelStyle, valueStyle),
      _buildRichText('Street:', street, labelStyle, valueStyle),
      _buildRichText('Street Number: ', streetNumber, labelStyle, valueStyle),
      _buildRichText('Price: ', price, labelStyle, valueStyle),
      _buildRichText('Screen Time: ', screenTime, labelStyle, valueStyle),
      _buildRichText('Resolution: ', '$resolution1 X $resolution2', labelStyle,
          valueStyle),
      _buildRichText('Description: ', description, labelStyle, valueStyle),
    ];
  }

  Widget _buildRichText(
      String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return RichText(
      text: TextSpan(
        text: label,
        style: labelStyle,
        children: [
          TextSpan(
            text: value,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}
