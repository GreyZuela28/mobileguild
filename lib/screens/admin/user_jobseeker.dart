import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';

class JobseekerScreen extends StatefulWidget {
  final String id;
  String? profilePic;
  final String name;
  final String userType;
  final String address;
  final String email;
  String? loginTime;
  final String mobileNumber;
  String? education;

  JobseekerScreen({
    super.key,
    required this.id,
    this.profilePic,
    required this.name,
    required this.userType,
    required this.address,
    required this.email,
    required this.mobileNumber,
    this.loginTime,
    this.education,
  });

  @override
  State<JobseekerScreen> createState() => _JobseekerScreenPageState();
}

class _JobseekerScreenPageState extends State<JobseekerScreen> {
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
      int.parse(widget.loginTime!.split('=')[1].split(',')[0]) * 1000 +
          (int.parse(widget.loginTime!.split('=')[2].split(')')[0]) / 1000)
              .round(),
    );
    DateTime dateTime = timestamp.toDate();

    //education
    final educ = widget.education!.split(',');
    final level = educ[0].substring(1);
    final category = educ[1];
    final course = educ[2].substring(0, educ[2].indexOf('}'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Page"),
      ),
      // body: Center(
      //   child: Stack(children: [
      //     Container(
      //       decoration: const BoxDecoration(
      //         image: DecorationImage(
      //           image: AssetImage("assets/background.png"),
      //           fit: BoxFit.fill,
      //         ),
      //       ),
      //     ),
      //     Center(
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(
      //           horizontal: 15.0,
      //           vertical: 15.0,
      //         ),
      //         decoration: BoxDecoration(
      //           image: const DecorationImage(
      //             image: AssetImage("assets/background.png"),
      //             fit: BoxFit.fill,
      //           ),
      //           borderRadius: BorderRadius.circular(10.0),
      //           color: Colors.white,
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.black.withOpacity(0.5),
      //               spreadRadius: 2,
      //               blurRadius: 5,
      //               offset: const Offset(3, 6),
      //             ),
      //             BoxShadow(
      //               color: Colors.white.withOpacity(0.5),
      //               spreadRadius: 2,
      //               blurRadius: 5,
      //               offset: const Offset(-3, -6),
      //             ),
      //           ],
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             const SizedBox(height: 35),
      //             widget.profilePic == ""
      //                 ? const CircleAvatar(
      //                     backgroundImage: AssetImage("assets/pita.png"),
      //                     radius: 60,
      //                   )
      //                 : CircleAvatar(
      //                     radius: 60,
      //                     child: ClipOval(
      //                       child: CachedNetworkImage(
      //                         imageUrl: widget.profilePic!,
      //                         placeholder: (context, url) =>
      //                             const CircularProgressIndicator(),
      //                         errorWidget: (context, url, error) =>
      //                             const Icon(Icons.error, size: 45),
      //                         fit: BoxFit.cover,
      //                         width: 120,
      //                         height: 120,
      //                       ),
      //                     ),
      //                   ),
      //             const SizedBox(height: 10),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text("User ID : ${widget.id}", style: style()),
      //                 SizedBox(height: 10),
      //                 Text("UserName : ${widget.name}", style: style()),
      //                 SizedBox(height: 10),
      //                 Text("UserType : ${widget.userType}", style: style()),
      //                 SizedBox(height: 10),
      //                 Text("Address : ${widget.address}", style: style()),
      //                 SizedBox(height: 10),
      //                 Text("Email : ${widget.email}", style: style()),
      //                 SizedBox(height: 10),
      //                 Text("$DateTime : ${dateTime.toString()}",
      //                     style: style()),
      //                 SizedBox(height: 10),
      //                 Text("Mobile Number : ${widget.mobileNumber.toString()}",
      //                     style: style()),
      //                 SizedBox(height: 10),
      //                 const Text("Educational Attainment: "),
      //                 Text("\t\t${level.toString()}", style: style()),
      //                 Text("\t\t $category", style: style()),
      //                 Text("\t\t$course", style: style()),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ]),
      // ),

      body: Center(
        child: Stack(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 45),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        "Personal Information:",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Text("ID: ${userData["id"]}",
                                          //     style: userTextStyle()),
                                          const SizedBox(height: 5),
                                          Text("Name: ${widget.name}"),
                                          const SizedBox(height: 5),
                                          Text("Address: ${widget.address}"),
                                          const SizedBox(height: 5),
                                          Text(
                                              "Mobile Number: 0${widget.mobileNumber}"),
                                          const SizedBox(height: 5),
                                          Text("Email: ${widget.email}"),

                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            // top: 0,
                            left: 0,
                            // bottom: 0,
                            right: 0,
                            child: widget.profilePic != ""
                                ? CircleAvatar(
                                    radius: 35,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(3, 6),
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(-3, -5),
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
                                          width: 70,
                                          height: 70,
                                        ),
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    // foregroundImage:
                                    //     AssetImage("assets/icon.png"),
                                    radius: 35,
                                    child: ClipOval(
                                      child: Image.asset("assets/icon.png"),
                                    ),
                                  ),
                            // widget.profilePic != ""
                            //     ? Positioned(
                            //         bottom: 0,
                            //         right: 0,
                            //         child: Container(
                            //           width: 25,
                            //           height: 25,
                            //           decoration: const BoxDecoration(
                            //             color: Colors.white,
                            //             shape: BoxShape.circle,
                            //           ),
                            //           child: IconButton(
                            //             alignment: Alignment.center,
                            //             iconSize: 13,
                            //             icon: const Icon(Icons
                            //                 .check_circle_outlined),
                            //             onPressed: () {
                            //               // do something when the icon button is pressed
                            //               // _showPicker(context);
                            //             },
                            //           ),
                            //         ),
                            //       )
                            //     : Positioned(
                            //         bottom: 0,
                            //         right: 0,
                            //         child: Container(
                            //           width: 25,
                            //           height: 25,
                            //           decoration: const BoxDecoration(
                            //             color: Colors.white,
                            //             shape: BoxShape.circle,
                            //           ),
                            //           child: IconButton(
                            //             alignment: Alignment.center,
                            //             iconSize: 13,
                            //             icon: const Icon(
                            //               Icons.add_a_photo_rounded,
                            //             ),
                            //             onPressed: () {
                            //               // do something when the icon button is pressed
                            //               // _showPicker(context);
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
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
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                "Educational Attainment:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(Utils.pascalCase(category.trim())),
                                  const SizedBox(height: 5),
                                  Text(Utils.pascalCase(
                                      level.trim().toString())),
                                  const SizedBox(height: 5),
                                  Text(Utils.pascalCase(course.trim())),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
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
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                "Login Information:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("UserType: ${widget.userType}"),
                                  const SizedBox(height: 10),
                                  Text("Login Time: ${dateTime.toString()}"),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle style() => const TextStyle(
      fontSize: 15,
    );
