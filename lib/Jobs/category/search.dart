import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults;
  final String category;

  MySearchDelegate({required this.searchResults, required this.category});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Utils utils = Utils();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('jobs')
          .where("category", isEqualTo: category)
          .where("jobTitle", isEqualTo: query.toLowerCase())
          // .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            Map<String, dynamic> document =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            DateTime documentDate = document['date'].toDate();
            int daysPassed = DateTime.now().difference(documentDate).inDays;
            String displayDate = DateFormat('yyyy-MM-dd').format(documentDate);
            String displayText =
                daysPassed == 0 ? 'New' : '$daysPassed days ago';
            return ListTile(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
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
              splashColor: Colors.grey[300],
              tileColor: Colors.amberAccent,
              // leading: const Icon(Icons.people),
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
              title: Text(document["jobTitle"]),
              subtitle: Text("Vacancy: ${document["vacancy"]}",
                  overflow: TextOverflow.ellipsis),
              trailing: utils.showOptions(displayText, document),
            );
          },
        );
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   List<String> suggestions = searchResults.where((searchResult) {
  //     final result = searchResult.toLowerCase();
  //     final input = query.toLowerCase();

  //     return result.contains(input);
  //   }).toList();

  //   return ListView.builder(
  //     itemCount: suggestions.length,
  //     itemBuilder: (context, index) {
  //       final suggestion = suggestions[index];

  //       return ListTile(
  //         title: Text(suggestion),
  //         onTap: () {
  //           query = suggestion;

  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('jobs')
          .where("category", isEqualTo: category)
          .where("jobTitle", isGreaterThanOrEqualTo: query.toLowerCase())
          .where("jobTitle", isLessThan: query.toLowerCase() + "z")
          // .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final suggestions =
            snapshot.data!.docs.map((doc) => doc['jobTitle']).toSet().toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(suggestions[index]),
              onTap: () {
                query = suggestions[index];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
