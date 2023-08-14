import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/Jobs/category/search.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';
import 'package:intl/intl.dart';

class Technology extends StatefulWidget {
  const Technology({super.key});

  @override
  State<Technology> createState() => _TechnologyState();
}

class _TechnologyState extends State<Technology> {
  String category = "technology";
  Utils utils = Utils();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();
  List<String> searchResults = [
    "IT",
    "Encoder",
    "Programmer",
    "Computer support specialist",
    "Computer systems analyst",
    "Software developer",
    "Web developer",
    "Network engineer",
  ];

  bool _descending = true;
  String _selectedOption = 'date';
  List<String> _menuOptions = ['date', 'jobTitle', 'jobStatus'];

  void _handleOptionTap(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Technology"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(
                  searchResults: searchResults,
                  category: category,
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_outlined),
            onSelected: _handleOptionTap,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    setState(() {
                      _descending = true;
                    });
                  },
                  value: _menuOptions[0],
                  child: const Text("sort by date"),
                ),
                PopupMenuItem(
                  onTap: () {
                    setState(() {
                      _descending = false;
                    });
                  },
                  value: _menuOptions[1],
                  child: const Text("sort by name"),
                ),
                PopupMenuItem(
                  onTap: () {
                    setState(() {
                      _descending = false;
                    });
                  },
                  value: _menuOptions[2],
                  child: const Text("sort by jobstatus"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collectionGroup('jobs')
              .where("category", isEqualTo: "technology")
              .orderBy(_selectedOption, descending: _descending)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text('No posted job'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                Map<String, dynamic> document =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                DateTime documentDate = document['date'].toDate();
                int daysPassed = now.difference(documentDate).inDays;
                String displayDate =
                    DateFormat('yyyy-MM-dd').format(documentDate);
                String displayText =
                    daysPassed == 0 ? 'New' : '$daysPassed days ago';

                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: Colors.grey[300],
                  tileColor: Colors.amberAccent,
                  onTap: () {
                    context.pushNamed("view", queryParams: {
                      "userId": document["userId"],
                      "email": document["email"],
                      "profilePic": document["profilePic"],
                      "jobId": document["jobId"],
                      "jobTitle": document["jobTitle"],
                      "category": document["category"],
                      "jobStatus": document["jobStatus"],
                      "address": document["address"],
                      "employer": document["employer"],
                      "businessName": document["businessName"],
                      "mobileNumber": document["mobileNumber"].toString(),
                      "vacancy": document["vacancy"],
                      "salary": document["salary"],
                      "jobQualification": document["jobQualification"],
                      "jobDescription": document["jobDescription"],
                      "date": document["date"].toString(),
                      "jobFile": document["jobFile"],
                    });
                  },

                  leading: CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: document["profilePic"],
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, size: 45),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  // leading: const Icon(Icons.people),
                  title: Text(Utils.pascalCase(document["jobTitle"])),
                  subtitle: Text("Vacancy: ${document["vacancy"]}",
                      overflow: TextOverflow.ellipsis),
                  trailing: utils.showOptions(displayText, document),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: utils.floatingButton(category),
    );
  }
}
