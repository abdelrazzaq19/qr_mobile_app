import 'package:flutter/material.dart';

class TicketTile extends StatelessWidget {
  const TicketTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: Icon(Icons.confirmation_num_outlined),
      title: Text('Event Name'),
      titleTextStyle: Theme.of(context).textTheme.titleMedium,
      subtitle: Text('2080-80-90'),
      subtitleTextStyle: Theme.of(context).textTheme.labelMedium,
      trailing: Icon(Icons.chevron_right),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary.withAlpha(50),
        ),
      ),
    );
  }
}
