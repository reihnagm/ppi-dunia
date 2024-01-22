import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class MentionPage extends StatefulWidget {
  const MentionPage({super.key});

  @override
  State<MentionPage> createState() => MentionPageState();
}

class MentionPageState extends State<MentionPage> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();

  List<Map<String, dynamic>> data = [
    {
      'id': 'fdc784c6-d6ee-4409-b24d-cdd54fbb737b',
      'display': 'Fani',
      'photo': 'https://cdn.idntimes.com/content-images/duniaku/post/20191101/roronoa-zoro-smile-0078d7e8a33471cfbb5077358d7d21d5.jpg'
    },
    {
      'id': '6458ed26-40a8-4c61-a162-f5ffa57a32a3',
      'display': 'Udin',
      'photo':'https://media.hitekno.com/thumbs/2022/05/31/82987-one-piece-luffy/730x480-img-82987-one-piece-luffy.jpg'
    },
  ];
  
  @override 
  void initState() {
    super.initState();
  }

  @override 
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            // customSliverAppBar(title: "Mention"),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0
                  ),
                  child: FlutterMentions(
                    key: key,
                    suggestionPosition: SuggestionPosition.Top,
                    onMentionAdd: (Map<String, dynamic> p0) {
                      debugPrint(p0.toString());
                    },
                    maxLines: 5,
                    minLines: 1,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF2F2F2F),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                        )
                      ),
                    ),
                    mentions: [
                      Mention(
                        trigger: '@',
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                        data: data,
                        matchAll: false,
                        suggestionBuilder: (Map<String, dynamic> data) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    data['photo'],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  children: [
                                    Text('@${data['display']}'),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    ]
                  ),
                ),
              )
            )

          ],
        )
      )

    );
  }
}