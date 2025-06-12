import 'package:PongChamp/ui/pages/widgets/custom_snackBar.dart';
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
      print("SIZE: ${context.size}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){markAllAsRead(viewModel);}, icon: Icon(Icons.mark_as_unread_outlined)
                ),
                TextButton(
                  style: ButtonStyle(),
                  onPressed: (){clearNotifications(viewModel);}, 
                  child: Text("Rimuovi tutte"),

                ),
              ],
            ),
            
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
          ],),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }



  Future<void> markAllAsRead(NotificationViewModel viewModel) async {
    final success = await viewModel.markAllAsRead();
    if(success) {
      CustomSnackBar.show(
        context, 
        message: "Tutte le notifiche segnate come lette",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
        );
    }
    else {
      CustomSnackBar.show(
        context, 
        message: "Errore nell'esecuzione dell'operazione",
        backgroundColor: Colors.red,
        icon: Icons.close_rounded);
    }
  }
  Future<void> clearNotifications(NotificationViewModel viewModel) async {
    final success = await viewModel.clearNotifications();
    if(success) {
      CustomSnackBar.show(
        context, 
        message: "Notifiche eliminate con successo",
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
        );
    }
    else {
      CustomSnackBar.show(
        context, 
        message: "Errore nell'esecuzione dell'operazione",
        backgroundColor: Colors.red,
        icon: Icons.close_rounded);
    }
  }
}