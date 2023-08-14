import "package:flutter/material.dart";

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = '/notification-screen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const SizedBox(height: 10),
    
          ],
        ),
      ),
    );
  }

}

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notification Screen"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Text(
//               widget.name,
//               style: const TextStyle(
//                 fontSize: 24,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               widget.description,
//               style: const TextStyle(
//                 fontSize: 24,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
