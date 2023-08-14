import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String jobId;
  String? profilePic;
  final String jobTitle;
  final String category;
  final String jobStatus;
  final String address;
  final String employer;
  final String businessName;
  final String mobileNumber;
  String? vacancy;
  final String? salary;
  final String? jobQualification;
  final String? jobDescription;
  final String? date;
  final String? jobFile;

  ViewScreen({
    super.key,
    required this.userId,
    required this.email,
    this.profilePic,
    required this.jobId,
    required this.jobTitle,
    required this.category,
    required this.jobStatus,
    required this.address,
    required this.employer,
    required this.businessName,
    required this.mobileNumber,
    this.vacancy,
    this.salary,
    this.jobQualification,
    this.jobDescription,
    this.date,
    this.jobFile,
  });

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    final qualification =
        widget.jobQualification!.split(",").map((e) => Text("* $e")).toList();
    final h = MediaQuery.of(context).size.height;
    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(
    //         widget.date!.substring(widget.date!.lastIndexOf("=") + 1,
    //             widget.date!.lastIndexOf("0"))) *
    //     1000);
    // String formattedDateTime =
    //     DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    // final date = DateTime.parse(widget.date!);
    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
      int.parse(widget.date!.split('=')[1].split(',')[0]) * 1000 +
          (int.parse(widget.date!.split('=')[2].split(')')[0]) / 1000).round(),
    );
    DateTime dateTime = timestamp.toDate();

    int daysPassed = DateTime.now().difference(dateTime).inDays;
    String displayDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String displayText = daysPassed == 0 ? 'New' : '$daysPassed days ago';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/background.png"),
              //   fit: BoxFit.fill,
              // ),
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(0.5),
                  Colors.blue.withOpacity(0.5),
                ],
                stops: const [0.4, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.yellow,
                              ],
                              stops: [0.4, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(3, 6),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(-3, -6),
                              ),
                            ],
                          ),
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(
                            right: 10.0,
                            left: 10.0,
                            top: 30.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 60.0),
                              const Center(
                                child: Text(
                                  "Employer's Information:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text("Name : ${widget.employer}"),
                                    const SizedBox(height: 5.0),
                                    Text(
                                        "Business Name: ${widget.businessName}"),
                                    const SizedBox(height: 5.0),
                                    Text(
                                        "Mobile Number : 0${widget.mobileNumber}"),
                                    const SizedBox(height: 5.0),
                                    Text("Email : ${widget.email}"),
                                    const SizedBox(height: 15.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(3, 6),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(-2, -3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.profilePic!,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 45),
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      // height: h * 0.5,
                      width: double.maxFinite,
                      color: Colors.blueAccent[300],
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 25.0,
                      ),
                      decoration: BoxDecoration(
                        // color: Colors.blueAccent.withOpacity(0.5),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.yellow,
                          ],
                          stops: [0.4, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(3, 6),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: const Offset(-3, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 25.0),
                          const Center(
                            child: Text(
                              "Job Information:",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(height: 5.0),
                                Text("Position : ${widget.jobTitle}"),
                                const SizedBox(height: 5.0),
                                Text("Vacancy : ${widget.vacancy!}"),
                                const SizedBox(height: 5.0),
                                Text("Job Status : ${widget.jobStatus}"),
                                const SizedBox(height: 5.0),
                                widget.salary != ""
                                    ? Column(
                                        children: [
                                          Text("Salary : ${widget.salary!}"),
                                          const SizedBox(height: 5.0),
                                        ],
                                      )
                                    : const SizedBox(),
                                widget.jobQualification != ""
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Job Qualification:"),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: widget.jobQualification!
                                                .split(",")
                                                .map((e) => Text("\t\t\t*$e"))
                                                .toList(),
                                          ),
                                          const SizedBox(height: 5.0),
                                        ],
                                      )
                                    : const SizedBox(),
                                widget.jobDescription != ""
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Job Description:"),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: widget.jobDescription!
                                                .split(",")
                                                .map((e) => Text("\t\t\t*$e"))
                                                .toList(),
                                          ),
                                          const SizedBox(height: 5.0),
                                        ],
                                      )
                                    : const SizedBox(),
                                DocumentCount(
                                    userId: widget.userId, jobId: widget.jobId),
                                const SizedBox(height: 5.0),
                                Text("Upload Time : $displayText"),
                                const SizedBox(height: 10.0),
                                widget.jobDescription == "" &&
                                        widget.jobQualification == ""
                                    ? Center(
                                        child: ElevatedButton.icon(
                                            onPressed: () {
                                              ConnectionStatus
                                                      .checkInternetConnection()
                                                  .then(
                                                (value) {
                                                  if (value ==
                                                      ConnectivityResult.none) {
                                                    ConnectionStatus
                                                        .showInternetError(
                                                            context);
                                                  } else {
                                                    context.pushNamed(
                                                      "pdfscreen",
                                                      queryParams: {
                                                        "jobFile":
                                                            widget.jobFile!,
                                                      },
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.article_outlined),
                                            label: const Text("More Details")),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          utils.viewScreenFloatingActionButton(widget.userId, widget.jobId),
    );
  }
}

class DocumentCount extends StatelessWidget {
  final String userId;
  final String jobId;
  const DocumentCount({
    super.key,
    required this.userId,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("jobs")
          .doc(jobId)
          .collection("applicants")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.size == 0) {
          return const Text("Number of Applicants: 0");
        }

        final count = snapshot.data!.docs.length;
        return Text("Number of Applicants: $count");
      },
    );
  }
}
