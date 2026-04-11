import 'package:flutter/material.dart';
import 'package:qr_app/widgets/ticket_tile.dart';

class MyTicketsTab extends StatelessWidget {
  const MyTicketsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.confirmation_num),
                    SizedBox(width: 8),
                    Text(
                      'My Tickets!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24),
                ExpansionTile(
                  title: Text('Active Tickets'),
                  initiallyExpanded: true,
                  childrenPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TicketTile();
                      },
                    ),
                  ], //
                ),
                ExpansionTile(
                  title: Text('Active Tickets'),
                  initiallyExpanded: true,
                  childrenPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return TicketTile();
                      },
                    ),
                  ], //video ke 5 34m 10d
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
