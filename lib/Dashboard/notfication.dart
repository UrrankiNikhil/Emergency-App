// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

//main notification class

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('User not signed in')),
      );
    }

    // Filter the requests by current user's uid
    final notificationsQuery = FirebaseDatabase.instance
        .ref('requests')
        .orderByChild('users')
        .equalTo(currentUser.uid);
//scaffold for the area of dsiplaying the notifications
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  FadeInLeft(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      'Emergency Requests',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notification_important_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: notificationsQuery.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: GoogleFonts.poppins(
                                color: Colors.red[300]),
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Loading requests...',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No emergency requests',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  Map<dynamic, dynamic> requests =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<MapEntry<dynamic, dynamic>> requestList =
                      requests.entries.toList();
                  requestList.sort((a, b) => (b.value['timestamp'] as String)
                      .compareTo(a.value['timestamp'] as String));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: requestList.length,
                    itemBuilder: (context, index) {
                      final request =
                          requestList[index].value as Map<dynamic, dynamic>;
                      final timestamp =
                          DateTime.parse(request['timestamp'] as String);
                      final formattedDate =
                          DateFormat('MMM d, y h:mm a').format(timestamp);

                      Color cardColor;
                      IconData cardIcon;

                      switch (request['requestType']) {
                        case 'SOS Alert':
                          cardColor = const Color(0xFFFF3B30);
                          cardIcon = Icons.warning_rounded;
                          break;
                        case 'Medical':
                          cardColor = const Color(0xFF007AFF);
                          cardIcon = Icons.medical_services_rounded;
                          break;
                        case 'Police':
                          cardColor = const Color(0xFF5856D6);
                          cardIcon = Icons.local_police_rounded;
                          break;
                        case 'Fire':
                          cardColor = const Color(0xFFFF9500);
                          cardIcon = Icons.local_fire_department_rounded;
                          break;
                        default:
                          cardColor = Colors.grey;
                          cardIcon = Icons.emergency;
                      }

                      return FadeInUp(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  cardColor.withOpacity(0.9),
                                  cardColor.withOpacity(0.7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          cardIcon,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request['requestType']
                                                  as String,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              formattedDate,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (request['latitude'] != null &&
                                      request['longitude'] != null)
                                    Text(
                                      'Location: ${request['latitude']?.toStringAsFixed(4)}, ${request['longitude']?.toStringAsFixed(4)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}