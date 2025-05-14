import 'package:PongChamp/ui/pages/widgets/notification_card.dart';

import '/ui/pages/viewmodel/notification_view_model.dart';
import '/ui/pages/widgets/app_bar.dart';
import '/ui/pages/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget{
  const NotificationsPage({Key? key}) : super (key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      context.read<NotificationViewModel>().fetchUserNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();
    return Scaffold(
      appBar: CustomAppBar(),
      body: 
        viewModel.isLoading ? Center(child: CircularProgressIndicator(color: Colors.black,))
        : viewModel.notifications.isEmpty ? Center(child: Text('Nessun evento disponibile'))
        : Expanded( //serve ad evitare problemi nello scroll della ListView
            child: 
            ListView.builder(
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
              final notification = viewModel.notifications[index];
              return NotificationCard(notification: notification);
              },
            ),
        ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}