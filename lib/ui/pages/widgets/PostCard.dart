import 'package:PongChamp/domain/models/event_model.dart';
import 'package:PongChamp/domain/models/match_model.dart';
import 'package:PongChamp/domain/models/user_models.dart';
import 'package:PongChamp/ui/pages/view/likes_page.dart';
import 'package:PongChamp/ui/pages/view/map_page.dart';
import 'package:PongChamp/ui/pages/view/profile_page.dart';
import 'package:PongChamp/ui/pages/viewmodel/events_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/map_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/match_view_model.dart';
import 'package:PongChamp/ui/pages/viewmodel/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '/ui/pages/viewmodel/post_view_model.dart';
import '/domain/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:PongChamp/domain/functions/utility.dart';


class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({required this.post, Key? key}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final PostViewModel _postViewModel;
  late final MatchViewModel _matchViewModel;
  late final UserViewModel _userViewModel;
  late final EventViewModel _eventViewModel;
  late final MapViewModel _mapViewModel;
  late final String _userId;

  // Streams
  late final Stream<AppUser?> _creatorStream;
  late final Future<PongMatch?> _matchFuture;
  late final Future<Event?> _eventFuture;
  String? _creatorProfileImageUrl;

  // Match players data
  late final Stream<AppUser?> _player1Stream;
  late final Stream<AppUser?> _player2Stream;

  @override
  void initState() {
    super.initState();
    //In this phase we set listen: false to avoid unnecessary rebuilds
    // and to ensure that the streams are initialized only once.
    _postViewModel = Provider.of<PostViewModel>(context, listen: false);
    _matchViewModel = Provider.of<MatchViewModel>(context, listen: false);
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _eventViewModel = Provider.of<EventViewModel>(context, listen: false);
    _mapViewModel = Provider.of<MapViewModel>(context, listen: false);
    _userId = FirebaseAuth.instance.currentUser!.uid;

    // Initialize streams and futures
    _creatorStream = _userViewModel.getUserStreamById(widget.post.idCreator);
    _matchFuture = _matchViewModel.fetchMatchById(widget.post.idMatch);
    _eventFuture = _matchFuture.then((match) { //Quando match è disponibile, carica l'evento
      if (match != null) {
        // Make sure PongMatch has an eventId property
        return _eventViewModel.getEventById(match.eventId);
      }
      return Future.value(null); //Alla fine restituisce un future null, cioè che è già stato risolto 
    });

    // Load creator profile image once
    _loadCreatorProfileImage();

    // Initialize player streams after getting match data
    _initializePlayerStreams();
  }

  Future<void> _loadCreatorProfileImage() async {
    final url = await _postViewModel.getCreatorProfileImageUrl(
      widget.post.idCreator,
    );
    if (mounted) {
      setState(() {
        _creatorProfileImageUrl = url;
      });
    }
  }

  Future<void> _initializePlayerStreams() async {
    final match = await _matchFuture;
    if (match != null && mounted) {
      setState(() {
        _player1Stream = _userViewModel.getUserStreamById(
          match.matchPlayers[0],
        );
        _player2Stream = _userViewModel.getUserStreamById(
          match.matchPlayers[1],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLiked = widget.post.likedBy.contains(_userId);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intestazione con avatar e nickname
            _creatorHeader(),
            const SizedBox(height: 30),
            // Match details
            LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder<PongMatch?>(
                  future: _matchFuture,
                  builder: (context, matchSnapshot) {
                    if (matchSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (matchSnapshot.hasError || !matchSnapshot.hasData) {
                      return const Text('Errore nel caricamento del match');
                    }

                    final match = matchSnapshot.data!;
                    return _buildMatchRow(match, constraints.maxWidth);
                  },
                );
              },
            ),

            // Post image if available
            if (widget.post.image != null && widget.post.image!.isNotEmpty)
              _postImage(),
            const SizedBox(height: 6),
            FutureBuilder<Event?>(
                  future: _eventFuture,
                  builder: (context, eventSnapshot) {
                    if (eventSnapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        '...',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    }
                    if (eventSnapshot.hasError || !eventSnapshot.hasData) {
                      return const Text(
                        'Location non disponibile',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    }

                    final event = eventSnapshot.data!;
                   return GestureDetector(
                    onTap: () {

                      navigateTo(context, MapPage(targetPosition: _mapViewModel.getCoordinatesByPlaceName(_eventViewModel.getLocationNameById(event.locationId)!)), '/map');

    
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _eventViewModel.getLocationNameById(event.locationId) ?? 'Location non disponibile',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            decoration: TextDecoration.underline, // opzionale, per indicare che è cliccabile
                          ),
                        ),
                      ],
                    ),
                  );
                  },
                ),
            // Like actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _likeAction(hasLiked),
                const SizedBox(height: 4),
                Text(
                  formatTimestamp(widget.post.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _creatorHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _navigateToProfile(widget.post.idCreator),
          child: CircleAvatar(
            radius: 24,
            backgroundImage:
                _creatorProfileImageUrl != null
                    ? NetworkImage(_creatorProfileImageUrl!)
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTap: () => _navigateToProfile(widget.post.idCreator),
            child: StreamBuilder<AppUser?>(
              stream: _creatorStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Errore nel caricamento utente');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Utente non trovato');
                }

                final user = snapshot.data!;
                return Flexible(       
                  child: Text(
                    user.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchRow(PongMatch match, double maxWidth) {
    final availableWidth = maxWidth - 100;
    final nicknameWidth = availableWidth / 2 - 16;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Giocatore 1
        Flexible(
          child: GestureDetector(
            onTap: () => _navigateToProfile(match.matchPlayers[0]),
            child: StreamBuilder<AppUser?>(
              stream: _player1Stream,
              builder: (context, snapshot) {
                return _buildPlayerWidget(
                  snapshot: snapshot,
                  nicknameWidth: nicknameWidth,
                  isPlayer1: true,
                );
              },
            ),
          ),
        ),
        // Punteggio
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                match.score1.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '-',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                match.score2.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        // Giocatore 2
        Flexible(
          child: GestureDetector(
            onTap: () => _navigateToProfile(match.matchPlayers[1]),
            child: StreamBuilder<AppUser?>(
              stream: _player2Stream,
              builder: (context, snapshot) {
                return _buildPlayerWidget(
                  snapshot: snapshot,
                  nicknameWidth: nicknameWidth,
                  isPlayer1: false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerWidget({
    required AsyncSnapshot<AppUser?> snapshot,
    required double nicknameWidth,
    required bool isPlayer1,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children:
            isPlayer1
                ? [
                  CircleAvatar(
                    radius: 12,
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: nicknameWidth,
                    height: 16,
                    child: Container(color: Colors.grey[300]),
                  ),
                ]
                : [
                  SizedBox(
                    width: nicknameWidth,
                    height: 16,
                    child: Container(color: Colors.grey[300]),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 12,
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ],
      );
    }

    if (snapshot.hasError || !snapshot.hasData) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children:
            isPlayer1
                ? [
                  CircleAvatar(radius: 12, child: Icon(Icons.error)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: nicknameWidth,
                    child: Text(
                      'Errore',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ]
                : [
                  SizedBox(
                    width: nicknameWidth,
                    child: Text(
                      'Errore',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(radius: 12, child: Icon(Icons.error)),
                ],
      );
    }

    final user = snapshot.data!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          isPlayer1
              ? [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(user.profileImage),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: nicknameWidth,
                  child: Text(
                    user.nickname,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]
              : [
                SizedBox(
                  width: nicknameWidth,
                  child: Text(
                    user.nickname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(user.profileImage),
                ),
              ],
    );
  }

  Widget _postImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
         child: Image.network(
          widget.post.image!,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 40));
          },
        ),
      ),
    );
  }

  Widget _likeAction(bool hasLiked) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              hasLiked ? Icons.favorite : Icons.favorite_border,
              color: hasLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (hasLiked) {
                _postViewModel.removeLikeFromPost(
                  widget.post.id,
                  widget.post.likes,
                );
              } else {
                _postViewModel.addLikeToPost(widget.post.id, widget.post.likes);
              }
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LikesPage(postId: widget.post.id),
                ),
              );
            },
            child: Text(
              '${widget.post.likes} likes',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile(String userId) {
    if (ModalRoute.of(context)?.settings.name != '/profile_$userId') {
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: RouteSettings(name: '/profile_$userId'),
          builder: (_) => ProfilePage(userId: userId),
        ),
      );
    }
  }
}
