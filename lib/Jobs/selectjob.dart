import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'jobcategory.dart';
import 'package:flutter/material.dart';

class SelectJob extends StatelessWidget {
  final JobCategory job;
  const SelectJob({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // return Neumorphic(
    //   style: NeumorphicStyle(
    //     border: const NeumorphicBorder(
    //       color: Colors.black,
    //       width: 0.5,
    //     ),
    //     shadowDarkColor: Colors.black,
    //     shadowLightColor: Colors.white,
    //     depth: 10,
    //     intensity: 0.6,
    //     color: Colors.grey[300],
    //     boxShape: NeumorphicBoxShape.roundRect(
    //       BorderRadius.circular(10),
    //     ),
    //   ),
    //   child: GestureDetector(
    //     child: Card(
    //       color: Colors.blueGrey,
    //       elevation: 10.0,
    //       child: Center(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             CircleAvatar(
    //               foregroundImage: job.image,
    //               radius: 30,
    //             ),
    //             const SizedBox(
    //               height: 5,
    //             ),
    //             Text(job.title, style: GoogleFonts.poppins(fontSize: 13.0)),
    //           ],
    //         ),
    //       ),
    //     ),
    //     onTap: () {
    //       context.go(job.path);
    //     },
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.5),
          //   spreadRadius: 2,
          //   blurRadius: 2,
          //   offset: const Offset(3, 6),
          // ),
          // BoxShadow(
          //   color: Colors.white.withOpacity(0.5),
          //   spreadRadius: 0.5,
          //   blurRadius: 0.5,
          //   offset: const Offset(-1, -2),
          // ),

          BoxShadow(
            color: Colors.black,
            offset: Offset(2, 3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-2, -2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        child: Card(
          color: Colors.blueGrey,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  foregroundImage: job.image,
                  radius: 30,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(job.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
        onTap: () {
          context.go(job.path);
        },
      ),
    );
  }
}

List<JobCategory> choices = const <JobCategory>[
  JobCategory(
      title: 'Technology',
      image: AssetImage('assets/category/technology.png'),
      path: "/main/technology"),
  JobCategory(
      title: 'Education',
      image: AssetImage('assets/category/educ.png'),
      path: "/main/education"),
  JobCategory(
      title: 'Government',
      image: AssetImage('assets/category/gov.png'),
      path: "/main/government"),
  JobCategory(
      title: 'Health',
      image: AssetImage('assets/category/health.png'),
      path: "/main/health"),
  JobCategory(
      title: 'Service',
      image: AssetImage('assets/category/service.png'),
      path: "/main/service"),
  JobCategory(
      title: 'Transportation',
      image: AssetImage('assets/category/transport.png'),
      path: "/main/transportation"),
  JobCategory(
      title: 'Construction',
      image: AssetImage('assets/category/construction.png'),
      path: "/main/construction"),
  JobCategory(
      title: 'Finance',
      image: AssetImage('assets/category/finance.png'),
      path: "/main/finance"),
  JobCategory(
      title: 'Others',
      image: AssetImage('assets/category/other.png'),
      path: "/main/other"),
];
