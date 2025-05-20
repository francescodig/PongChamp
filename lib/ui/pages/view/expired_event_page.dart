import 'package:PongChamp/ui/pages/view/create_post_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/expired_view_model.dart';
import 'package:PongChamp/ui/pages/widgets/custom_card_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:PongChamp/ui/pages/widgets/app_bar.dart';
import 'package:PongChamp/ui/pages/widgets/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpiredEventPage extends StatefulWidget {
  const ExpiredEventPage({Key? key}) : super(key: key);

  @override
  State<ExpiredEventPage> createState() => _ExpiredEventPageState();
}

class _ExpiredEventPageState extends State<ExpiredEventPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<ExpiredViewModel>();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      viewModel.loadUserParticipatedEvents(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createPostViewModel = Provider.of<ExpiredViewModel>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: createPostViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : createPostViewModel.expiredUserParticipatedEvents.isEmpty
              ? const Center(child: Text("Nessun evento scaduto trovato."))
              : ListView.builder(
                  itemCount: createPostViewModel.expiredUserParticipatedEvents.length,
                  itemBuilder: (context, index) {
                    final event = createPostViewModel.expiredUserParticipatedEvents[index];
                    return CustomCard(
                      buttonText: "Crea post",
                      buttonColor: Colors.blue,
                      eventId: event.id,
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CreatePostPage(event: event),
                          ),
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
