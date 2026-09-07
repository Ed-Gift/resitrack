import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'admin_dashboard.dart';
import 'main.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String initialRole;
  final String? userName;
  final String? studentNumber;
  final String? university;
  final String? residence;
  final String? room;

  const HomePage({
    super.key,
    this.initialRole = 'Student',
    this.userName,
    this.studentNumber,
    this.university,
    this.residence,
    this.room,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  late String _userRole;
  late String userName;
  late String studentNumber;
  late String university;
  late String residence;
  late String room;
  List<Map<String, dynamic>> inventoryItems = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _userRole = widget.initialRole;
    _currentIndex = 0; // Default to Home/Updates
    
    // Initialize with passed values or defaults
    userName = widget.userName ?? "Mpumelelo Gumede";
    studentNumber = widget.studentNumber ?? "202488192";
    university = widget.university ?? "University of the Witwatersrand";
    residence = widget.residence ?? "Not Registered";
    room = widget.room ?? "N/A";
    
    // Initialize inventory only if residence is already approved
    if (residence != "Not Registered") {
      applicationStatus = "Approved";
      inventoryItems = [
        {"name": "Bed Frame", "status": "Good", "rating": 5},
        {"name": "Mattress", "status": "Good", "rating": 5},
        {"name": "Study Desk", "status": "Good", "rating": 5},
        {"name": "Office Chair", "status": "Good", "rating": 5},
        {"name": "Wardrobe", "status": "Good", "rating": 5},
        {"name": "Heater", "status": "Good", "rating": 5},
        {"name": "Curtains", "status": "Good", "rating": 5},
        {"name": "Bookshelf", "status": "Good", "rating": 5},
        {"name": "Waste Bin", "status": "Good", "rating": 5},
        {"name": "Study Lamp", "status": "Good", "rating": 5},
        {"name": "Mirror", "status": "Good", "rating": 5},
        {"name": "Door Lock", "status": "Good", "rating": 5},
      ];
    } else {
      inventoryItems = [];
    }
  }
  @override
  void dispose() {
    _chatController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  File? _profileImage;
  String? _documentPath;

  String profileImageUrl = "https://i.pravatar.cc/300";

  // Application State (For Student)
  String applicationStatus = "Not Started"; // Not Started, Pending, Approved, Declined
  String? declineReason;

  // Mock Data
  List<Map<String, dynamic>> maintenanceReports = [
    {
      "id": "REQ001",
      "title": "Broken Window - B Block",
      "residence": "B Block",
      "room": "Hallway",
      "status": "In Progress",
      "date": "2024-03-20",
      "priority": "High"
    },
    {
      "id": "REQ002",
      "title": "Leaking Tap - Room 204",
      "residence": "Main Res",
      "room": "204",
      "status": "Assigned",
      "date": "2024-03-22",
      "priority": "Medium"
    },
  ];

  List<Map<String, dynamic>> laundryMachines = [
    {
      "name": "Washer 1",
      "type": "Washer",
      "status": "Available",
      "timeLeft": 0,
      "bookings": [
        {"user": "Alice", "time": "10:00 AM"},
        {"user": "Bob", "time": "11:00 AM"}
      ],
      "history": [
        {"user": "John", "time": "Yesterday, 4:00 PM"},
        {"user": "Sarah", "time": "Yesterday, 2:00 PM"}
      ]
    },
    {
      "name": "Washer 2",
      "type": "Washer",
      "status": "In Use",
      "timeLeft": 15,
      "bookings": [
        {"user": "Charlie", "time": "09:30 AM"}
      ],
      "history": [
        {"user": "Mike", "time": "Yesterday, 5:00 PM"}
      ]
    },
    {
      "name": "Dryer 1", 
      "type": "Dryer", 
      "status": "Available", 
      "timeLeft": 0, 
      "bookings": [],
      "history": [
        {"user": "Anna", "time": "Today, 8:00 AM"}
      ]
    },
    {
      "name": "Dryer 2", 
      "type": "Dryer", 
      "status": "Available", 
      "timeLeft": 0, 
      "bookings": [],
      "history": []
    },
  ];

  List<Map<String, String>> notifications = [
    {"title": "Welcome to ResiTrack", "body": "Explore your new dashboard to manage your residency.", "time": "Just now", "type": "info"},
    {"title": "Maintenance Update", "body": "Your report REQ001 is now being processed.", "time": "1 hour ago", "type": "maintenance"},
  ];

  List<Map<String, String>> chatMessages = [
    {"sender": "Admin", "message": "The water will be off for maintenance from 10:00 to 12:00.", "time": "09:00 AM"},
    {"sender": "John (Room 102)", "message": "Thanks for the heads up!", "time": "09:15 AM"},
    {"sender": "Sarah (Room 305)", "message": "Is the laundry room open today?", "time": "09:30 AM"},
  ];

  // Mock Data for Blackboard
  List<Map<String, String>> blackboardEntries = [
    {
      "id": "B1",
      "title": "Water Outage Notice",
      "content": "Water will be restored by 6 PM today. Apologies for the inconvenience.",
      "author": "Admin",
      "date": "2024-03-25",
      "residence": "Global"
    },
    {
      "id": "B2",
      "title": "Corridor Meeting - B Block",
      "content": "Meeting in the common room at 7 PM to discuss noise levels and cleaning schedules.",
      "author": "Corridor Rep (Sarah)",
      "date": "2024-03-24",
      "residence": "B Block"
    },
  ];

  // Mock Data for Admin
  List<Map<String, String>> pendingApplications = [
    {"name": "John Doe", "studentNumber": "2023001", "university": "UCT", "status": "Pending"},
    {"name": "Sarah Smith", "studentNumber": "2023002", "university": "Wits", "status": "Pending"},
  ];

  void _editProfile(String label, String currentVal, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentVal);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => onSave(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If the user is an Admin, show the modern Web/Desktop Dashboard
    if (_userRole == 'Administrator') {
      return const AdminDashboard();
    }

    final List<Widget> pages = [
      _buildNotificationsPage(),
      _getManagementPage(),
      _buildChatPage(),
      _buildProfilePage(),
      _buildSettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        centerTitle: true,
        actions: [
          // Role Switcher for Demo
          TextButton(
            onPressed: () {
              final roles = ['Student', 'Staff', 'Corridor Rep', 'Technician', 'Administrator'];
              setState(() {
                int nextIdx = (roles.indexOf(_userRole) + 1) % roles.length;
                _userRole = roles[nextIdx];
              });
            },
            child: Text(_userRole, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          )
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: (_currentIndex == 1 && (_userRole != 'Administrator' && _userRole != 'Corridor Rep'))
          ? FloatingActionButton.extended(
              onPressed: _showNewReportDialog,
              label: const Text("Report Issue"),
              icon: const Icon(Icons.add_comment_rounded),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(_isAdminOrRep() ? Icons.dashboard_customize : Icons.report),
            label: _isAdminOrRep() ? 'Manage' : 'Report',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Chat'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  bool _isAdminOrRep() => _userRole == 'Administrator' || _userRole == 'Corridor Rep';

  Widget _getManagementPage() {
    if (_userRole == 'Administrator') return _buildAdminPanel();
    if (_userRole == 'Corridor Rep') return _buildRepPanel();
    return _buildMaintenancePage();
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Recent Updates';
      case 1:
        if (_userRole == 'Administrator') return 'Admin Dashboard';
        if (_userRole == 'Corridor Rep') return 'Rep Blackboard';
        return 'Maintenance Tracker';
      case 2:
        return 'Community Chat';
      case 3:
        return 'My Profile';
      case 4:
        return 'App Settings';
      default:
        return 'ResiTrack';
    }
  }

  Widget _buildMaintenancePage() {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Active Reports Tracker", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showNewReportDialog,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text("New Report"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (maintenanceReports.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No active reports found.", style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ...maintenanceReports.map((report) => _buildReportTracerCard(report)),
            const SizedBox(height: 30),
            const Text("Laundry Slot Booking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildLaundrySection(),
          ],
        ),
      ),
    );
  }

  void _showNewReportDialog() {
    final titleController = TextEditingController();
    final roomController = TextEditingController(text: room != "N/A" ? room : "");
    final resController = TextEditingController(text: residence != "Not Registered" ? residence : "");
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report an Issue"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "What is the problem?",
                  hintText: "e.g. Broken light in hallway",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: resController,
                decoration: const InputDecoration(
                  labelText: "Residence Name",
                  hintText: "e.g. B Block",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(
                  labelText: "Room Number / Location",
                  hintText: "e.g. Room 204",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  maintenanceReports.insert(0, {
                    "id": "REQ${100 + maintenanceReports.length}",
                    "title": titleController.text,
                    "room": roomController.text,
                    "residence": resController.text,
                    "status": "Logged",
                    "date": DateTime.now().toString().substring(0, 10),
                    "priority": "Medium",
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Maintenance report submitted successfully!")),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _showReportDetailsDialog(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.assignment_late, color: report['priority'] == 'High' ? Colors.red : Colors.orange),
            const SizedBox(width: 10),
            const Text("Report Details"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reference ID: ${report['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            const SizedBox(height: 8),
            const Text("Issue Title:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(report['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Location:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("${report['residence']} - ${report['room']}"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date Logged:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(report['date']),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text("Current Status:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                report['status'],
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Priority:", style: TextStyle(color: Colors.grey, fontSize: 12)),
            Text(
              report['priority'] ?? 'Medium',
              style: TextStyle(
                color: report['priority'] == 'High' ? Colors.red : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _buildReportTracerCard(Map<String, dynamic> report) {
    List<String> statuses = ["Logged", "Assigned", "In Progress", "Completed"];
    int currentIdx = statuses.indexOf(report['status']);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool canUpdateStatus = _userRole == 'Technician' || _userRole == 'Staff' || _userRole == 'Administrator';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _showReportDetailsDialog(report),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(report['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (report['priority'] == 'High' ? Colors.redAccent : Colors.orange).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      report['priority'] ?? 'Low', 
                      style: TextStyle(
                        color: report['priority'] == 'High' ? Colors.redAccent : Colors.orange, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text("ID: ${report['id']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(width: 15),
                  if (report['residence'] != null && report['residence'].isNotEmpty) ...[
                    Icon(Icons.business, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(report['residence'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(width: 15),
                  ],
                  if (report['room'] != null && report['room'].isNotEmpty) ...[
                    Icon(Icons.room, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(report['room'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(statuses.length, (index) {
                  bool isDone = index <= currentIdx;
                  bool isCurrent = index == currentIdx;
                  bool isLast = index == statuses.length - 1;
                  
                  Color stepColor = isDone 
                      ? Theme.of(context).colorScheme.tertiary 
                      : (isDark ? Colors.grey[700]! : Colors.grey[300]!);

                  return Expanded(
                    child: InkWell(
                      onTap: (canUpdateStatus && !isDone && (index == currentIdx + 1))
                        ? () {
                            setState(() {
                              report['status'] = statuses[index];
                            });
                          }
                        : null,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container(height: 3, color: index == 0 ? Colors.transparent : (index <= currentIdx ? stepColor : stepColor.withValues(alpha: 0.3)))),
                              Icon(
                                isDone ? Icons.check_circle : Icons.radio_button_off, 
                                color: stepColor, 
                                size: isCurrent ? 24 : 18
                              ),
                              Expanded(child: Container(height: 3, color: isLast ? Colors.transparent : (index < currentIdx ? stepColor : stepColor.withValues(alpha: 0.3)))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            statuses[index], 
                            style: TextStyle(
                              fontSize: 9, 
                              color: isDone ? Theme.of(context).colorScheme.onSurface : Colors.grey, 
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              if (canUpdateStatus && currentIdx < statuses.length - 1) ...[
                const SizedBox(height: 15),
                Divider(color: Colors.grey.withValues(alpha: 0.2)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        report['status'] = statuses[currentIdx + 1];
                      });
                    },
                    icon: const Icon(Icons.update, size: 16),
                    label: Text("Mark as ${statuses[currentIdx + 1]}", style: const TextStyle(fontSize: 12)),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaundrySection() {
    return Column(
      children: laundryMachines.map((machine) {
        bool isAvailable = machine['status'] == 'Available';
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isAvailable ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              child: Icon(
                machine['type'] == 'Washer' ? Icons.local_laundry_service : Icons.dry, 
                color: isAvailable ? Colors.green : Colors.orange
              ),
            ),
            title: Text(machine['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              isAvailable ? "Ready for use" : "Occupied - ${machine['timeLeft']} mins left",
              style: TextStyle(color: isAvailable ? Colors.green : Colors.orange),
            ),
            trailing: isAvailable 
              ? ElevatedButton(
                  onPressed: () => _bookLaundry(machine),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Book"),
                )
              : IconButton(
                  icon: const Icon(Icons.notification_add_rounded),
                  tooltip: "Notify when free",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("Alert set! We'll notify you when ${machine['name']} is available."),
                      ),
                    );
                  },
                ),
          ),
        );
      }).toList(),
    );
  }

  void _bookLaundry(Map<String, dynamic> machine) {
    List bookings = machine['bookings'] ?? [];
    List history = machine['history'] ?? [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Book ${machine['name']}"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (history.isNotEmpty) ...[
                const Text("Recent History:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...history.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("• ${h['user']} used at ${h['time']}", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                )),
                const Divider(),
              ],
              if (bookings.isNotEmpty) ...[
                const Text("Upcoming Bookings:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...bookings.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("• ${b['user']} at ${b['time']}", style: const TextStyle(fontSize: 13)),
                )),
                const Divider(),
              ],
              const Text("Select your cycle duration:"),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [30, 45, 60].map((mins) => InkWell(
                  onTap: () {
                    setState(() {
                      machine['status'] = 'In Use';
                      machine['timeLeft'] = mins;
                      machine['bookings'].add({"user": userName, "time": "Now"});
                      notifications.insert(0, {
                        "title": "Laundry Started",
                        "body": "Your cycle in ${machine['name']} has started. We'll notify you in $mins mins.",
                        "time": "Just now",
                        "type": "laundry"
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text("${machine['name']} booked! You will be notified when done."),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("$mins m"),
                  ),
                )).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsPage() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          notifications.insert(0, {
            "title": "New Update",
            "body": "Your dashboard has been refreshed.",
            "time": "Just now",
            "type": "info"
          });
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length + blackboardEntries.where((e) => e['residence'] == 'Global' || e['residence'] == residence).length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Back, $userName!", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(residence != "Not Registered" ? "Residency: $residence" : "No residence registered yet", 
                       style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 15),
                  if (applicationStatus == "Approved") _buildQuickInventoryCard(),
                  const SizedBox(height: 10),
                  const Divider(),
                ],
              ),
            );
          }
          
          final filteredBlackboard = blackboardEntries.where((e) => e['residence'] == 'Global' || e['residence'] == residence).toList();

          // Show Blackboard entries first
          if (index <= filteredBlackboard.length) {
            final post = filteredBlackboard[index - 1];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2))),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.campaign)),
                title: Text(post['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(post['content']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Text(post['date']!, style: const TextStyle(fontSize: 10)),
                onTap: () => _showNoticeDetails(post),
              ),
            );
          }

          final note = notifications[index - filteredBlackboard.length - 1];
          IconData icon;
          Color iconColor;
          
          switch (note['type']) {
            case 'laundry':
              icon = Icons.local_laundry_service;
              iconColor = Colors.amber;
              break;
            case 'maintenance':
              icon = Icons.build_circle;
              iconColor = Colors.orange;
              break;
            default:
              icon = Icons.notifications;
              iconColor = Theme.of(context).colorScheme.primary;
          }

          return Dismissible(
            key: Key(note['title']! + note['time']!),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index - 1);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification dismissed')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: iconColor.withValues(alpha: 0.1),
                  child: Icon(icon, color: iconColor),
                ),
                title: Text(note['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(note['body']!),
                trailing: Text(note['time']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNoticeDetails(Map<String, String> post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(post['title']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['content']!),
            const SizedBox(height: 20),
            Text("Posted by: ${post['author']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text("Date: ${post['date']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text("Scope: ${post['residence']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }

  Widget _buildChatPage() {
    final filteredChat = chatMessages.where((msg) => msg['residence'] == null || msg['residence'] == 'Global' || msg['residence'] == residence).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            residence != "Not Registered" ? "Residence Channel: $residence" : "Global Community Chat",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: filteredChat.length,
            itemBuilder: (context, index) {
              final msg = filteredChat[index];
              bool isMe = msg['sender']?.startsWith(userName) ?? false;
              bool isAdmin = msg['sender'] == 'Admin';
              
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe 
                        ? Theme.of(context).colorScheme.primary 
                        : (isAdmin 
                            ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1)
                            : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: Radius.circular(isMe ? 15 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 15),
                    ),
                    border: Border.all(
                      color: isMe 
                          ? Theme.of(context).colorScheme.primary 
                          : (isAdmin 
                              ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)
                              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3))
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['sender']!, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 12, 
                          color: isMe ? Colors.white70 : (isAdmin ? Colors.brown : Colors.orange)
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg['message']!,
                        style: TextStyle(color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          msg['time']!, 
                          style: TextStyle(fontSize: 10, color: isMe ? Colors.white60 : Colors.grey)
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                mini: true,
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      chatMessages.add({
        "sender": "$userName (You)",
        "message": _chatController.text.trim(),
        "time": "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}",
        "residence": residence != "Not Registered" ? residence : "Global",
      });
      _chatController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildAdminPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBlackboardSection(),
        const SizedBox(height: 25),
        const Text("Pending Room Registrations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (pendingApplications.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No pending applications.", style: TextStyle(color: Colors.grey)))),
        ...pendingApplications.asMap().entries.map((entry) {
          int index = entry.key;
          var app = entry.value;
          return Card(
            child: ListTile(
              title: Text(app['name']!),
              subtitle: Text("${app['university']} - ${app['studentNumber']}\nRequested: ${app['requestedResidence']} (Room ${app['requestedRoom']})"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      setState(() {
                        if (app['name'] == userName) {
                          applicationStatus = "Approved";
                          residence = app['requestedResidence']!;
                          room = app['requestedRoom']!;
                          // Initialize inventory upon approval
                          inventoryItems = [
                            {"name": "Bed Frame", "status": "Good", "rating": 5},
                            {"name": "Mattress", "status": "Good", "rating": 5},
                            {"name": "Study Desk", "status": "Good", "rating": 5},
                            {"name": "Office Chair", "status": "Good", "rating": 5},
                            {"name": "Wardrobe", "status": "Good", "rating": 5},
                            {"name": "Heater", "status": "Good", "rating": 5},
                            {"name": "Curtains", "status": "Good", "rating": 5},
                            {"name": "Bookshelf", "status": "Good", "rating": 5},
                            {"name": "Waste Bin", "status": "Good", "rating": 5},
                            {"name": "Study Lamp", "status": "Good", "rating": 5},
                            {"name": "Mirror", "status": "Good", "rating": 5},
                            {"name": "Door Lock", "status": "Good", "rating": 5},
                          ];
                        }
                        pendingApplications.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application Approved and Room Assigned')));
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        if (app['name'] == userName) {
                          applicationStatus = "Declined";
                          declineReason = "Missing valid proof of residence.";
                        }
                        pendingApplications.removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application Declined')));
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 30),
        const Text("System Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
          children: [
            _adminStatCard("Total Users", "1,240", Icons.people, Colors.orange),
            _adminStatCard("Pending Reports", maintenanceReports.length.toString(), Icons.build, Colors.deepOrange),
            _adminStatCard("Active Bookings", "12", Icons.local_laundry_service, Colors.amber),
            _adminStatCard("System Health", "98%", Icons.speed, Colors.brown),
          ],
        ),
      ],
    );
  }

  Widget _buildRepPanel() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Corridor Rep Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Managing: $residence", style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        _buildBlackboardSection(),
        const SizedBox(height: 25),
        const Text("Reported Corridor Issues", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...maintenanceReports
            .where((r) => r['residence'] == residence)
            .map((report) => _buildReportTracerCard(report)),
      ],
    );
  }

  Widget _buildBlackboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Digital Blackboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _showNewBlackboardPostDialog,
              icon: const Icon(Icons.add_comment),
              label: const Text("Post Update"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (blackboardEntries.isEmpty)
          const Center(child: Text("No notices posted.", style: TextStyle(color: Colors.grey)))
        else
          ...blackboardEntries.map((post) => Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(post['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(post['residence']!, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(post['content']!),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By ${post['author']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Text(post['date']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          )),
      ],
    );
  }

  void _showNewBlackboardPostDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String scope = 'Global';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Post to Blackboard"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Notice Title", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: "Details", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: scope,
                items: ['Global', residence].where((s) => s != 'Not Registered').toSet().map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setDialogState(() => scope = v!),
                decoration: const InputDecoration(labelText: "Visibility Scope", border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  setState(() {
                    blackboardEntries.insert(0, {
                      "id": "B${blackboardEntries.length + 1}",
                      "title": titleController.text,
                      "content": contentController.text,
                      "author": "$_userRole ($userName)",
                      "date": DateTime.now().toString().substring(0, 10),
                      "residence": scope,
                    });
                    notifications.insert(0, {
                      "title": "New Blackboard Notice",
                      "body": titleController.text,
                      "time": "Just now",
                      "type": "info"
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Post Notice"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminStatCard(String title, String val, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color.withValues(alpha: 0.2))),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Profile Header
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: CircleAvatar(
                  radius: 62, 
                  backgroundImage: _profileImage != null 
                      ? FileImage(_profileImage!) as ImageProvider
                      : NetworkImage(profileImageUrl)
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: _pickProfileImage,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(university, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          
          const SizedBox(height: 30),
          
          // Identity Details
          _buildInfoCard("Personal Information", [
            _infoTile("Full Name", userName, Icons.person_outline, () => _editProfile("Name", userName, (v) => userName = v)),
            _infoTile("Student Number", studentNumber, Icons.badge_outlined, () => _editProfile("Student Number", studentNumber, (v) => studentNumber = v)),
            _infoTile("Institution", university, Icons.school_outlined, () => _editProfile("University", university, (v) => university = v)),
          ]),

          const SizedBox(height: 20),

          // Residence Details
          if (_userRole == 'Student')
            _buildInfoCard("Residence Details", [
              _infoTile(
                "Residence Name", 
                residence, 
                Icons.business_outlined, 
                // Only allow editing if not yet approved
                applicationStatus == "Approved" ? null : () => _editProfile("Residence", residence, (v) => residence = v)
              ),
              _infoTile(
                "Room / Unit", 
                room, 
                Icons.room_outlined, 
                // Only allow editing if not yet approved
                applicationStatus == "Approved" ? null : () => _editProfile("Room", room, (v) => room = v)
              ),
              if (applicationStatus == "Approved")
                _infoTile("Room Inventory", "${inventoryItems.length} Items", Icons.list_alt_outlined, _showInventoryDialog),
            ]),

          const SizedBox(height: 25),

          // Room Registration Tracker (Only for Students)
          if (_userRole == 'Student') _buildApplicationTracker(),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(15)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value, IconData icon, VoidCallback? onEdit) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: onEdit != null ? const Icon(Icons.chevron_right, size: 20) : null,
      onTap: onEdit,
    );
  }

  Widget _buildApplicationTracker() {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Room Registration Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            // Steps UI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stepItem("Applied", applicationStatus != "Not Started", Icons.description),
                _stepLine(applicationStatus == "Pending" || applicationStatus == "Approved" || applicationStatus == "Declined"),
                _stepItem("Reviewing", applicationStatus == "Approved" || applicationStatus == "Declined", Icons.hourglass_empty),
                _stepLine(applicationStatus == "Approved"),
                _stepItem("Finalized", applicationStatus == "Approved", Icons.verified),
              ],
            ),

            const SizedBox(height: 25),
            
            // Status specific messaging
            if (applicationStatus == "Not Started") ...[
              const Text("You haven't applied for a room yet."),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _showUploadDialog,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Proof of Residence"),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
            ] else if (applicationStatus == "Pending") ...[
              const Center(child: Text("Verification in progress. Please wait for Administrator approval.", textAlign: TextAlign.center, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500))),
            ] else if (applicationStatus == "Approved") ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(child: Text("Application Approved! Room: $residence - $room", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            ] else if (applicationStatus == "Declined") ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(10)),
                child: Text("Declined: ${declineReason ?? 'Invalid document'}", style: const TextStyle(color: Colors.red)),
              ),
              TextButton(onPressed: _showUploadDialog, child: const Text("Re-upload Documents")),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stepItem(String label, bool isDone, IconData icon) {
    Color color = isDone ? Colors.green : Colors.grey;
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isDone ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _stepLine(bool isDone) {
    return Expanded(child: Container(height: 2, color: isDone ? Colors.green : Colors.grey[300], margin: const EdgeInsets.only(bottom: 15)));
  }

  Widget _buildQuickInventoryCard() {
    int totalItems = inventoryItems.length;
    int criticalItems = inventoryItems.where((item) => (item['rating'] ?? 5) <= 2).length;
    
    return Card(
      elevation: 0,
      color: criticalItems > 0 ? Colors.red.withValues(alpha: 0.1) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
        side: BorderSide(color: criticalItems > 0 ? Colors.red : Theme.of(context).colorScheme.primary, width: 0.5)
      ),
      child: ListTile(
        leading: Icon(
          criticalItems > 0 ? Icons.report_problem : Icons.inventory_2_outlined, 
          color: criticalItems > 0 ? Colors.red : Theme.of(context).colorScheme.primary
        ),
        title: const Text("Room Inventory Checklist", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(criticalItems > 0 
            ? "$criticalItems issue(s) reported automatically" 
            : "Review and rate your room furniture"),
        trailing: const Icon(Icons.chevron_right),
        onTap: _showInventoryDialog,
      ),
    );
  }

  void _showInventoryDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Room Inventory Rating"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                final item = inventoryItems[index];
                int rating = item['rating'] ?? 5;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(_getRatingLabel(rating), 
                               style: TextStyle(
                                 color: rating <= 2 ? Colors.red : Colors.green,
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold
                               )),
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (starIndex) {
                            int score = starIndex + 1;
                            return IconButton(
                              icon: Icon(
                                score <= rating ? Icons.star : Icons.star_border,
                                color: rating <= 2 ? Colors.redAccent : Colors.amber,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                String newStatus = _getStatusFromRating(score);
                                setDialogState(() {
                                  item['rating'] = score;
                                  item['status'] = newStatus;
                                });
                                setState(() {
                                  inventoryItems[index]['rating'] = score;
                                  inventoryItems[index]['status'] = newStatus;
                                  if (score <= 2) {
                                    _autoGenerateMaintenanceReport(item['name'], newStatus, score);
                                  }
                                });
                              },
                            );
                          }),
                          const Spacer(),
                          Text(
                            "$rating / 5", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: rating <= 2 ? Colors.red : Colors.grey[700]
                            )
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Done")),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1: return "Missing";
      case 2: return "Bad / Damaged";
      case 3: return "Fair";
      case 4: return "Good";
      case 5: return "Excellent";
      default: return "Unknown";
    }
  }

  String _getStatusFromRating(int rating) {
    if (rating == 1) return "Missing";
    if (rating == 2) return "Damaged";
    return "Good";
  }

  void _autoGenerateMaintenanceReport(String itemName, String status, int rating) {
    // Avoid duplicate reports for the same item if one is already logged
    bool alreadyReported = maintenanceReports.any((r) => 
      r['title'].contains(itemName) && r['status'] == "Logged"
    );
    
    if (alreadyReported) return;

    String urgency = rating == 1 ? "Critical" : "Standard";
    setState(() {
      maintenanceReports.insert(0, {
        "id": "INV${100 + maintenanceReports.length}",
        "title": "Inventory Issue: $itemName ($urgency)",
        "description": "Automatic report generated via inventory check. Item rated $rating/5 ($status).",
        "room": room,
        "residence": residence,
        "status": "Logged",
        "date": DateTime.now().toString().substring(0, 10),
        "priority": rating == 1 ? "High" : "Medium",
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Auto-reported: $itemName is marked as $status"),
        backgroundColor: rating == 1 ? Colors.red : Colors.orange,
      ),
    );
  }

  void _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showUploadDialog() {
    final resNameController = TextEditingController();
    final roomNumController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Register Residence"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("1. Upload Proof of Residence", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png'],
                    );

                    if (result != null) {
                      setDialogState(() {
                        _documentPath = result.files.single.path;
                      });
                    }
                  },
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10),
                      color: _documentPath != null ? Colors.green.shade50 : Colors.grey.shade50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_documentPath != null ? Icons.check_circle : Icons.upload_file, 
                             size: 40, color: _documentPath != null ? Colors.green : Colors.grey),
                        Text(_documentPath != null ? "Document Attached" : "Tap to select document"),
                        if (_documentPath != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _documentPath!.split('/').last, 
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("2. Residence Information", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: resNameController,
                  decoration: const InputDecoration(labelText: "Preferred Residence", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: roomNumController,
                  decoration: const InputDecoration(labelText: "Requested Room Number", border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (_documentPath == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload a document first.")));
                  return;
                }
                setState(() {
                  applicationStatus = "Pending";
                  // Note: residence and room are NOT set here, only upon approval
                  
                  // Add to pending applications for Admin simulation
                  pendingApplications.add({
                    "name": userName,
                    "studentNumber": studentNumber,
                    "university": university,
                    "status": "Pending",
                    "requestedResidence": resNameController.text,
                    "requestedRoom": roomNumController.text,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Residence registration submitted! Waiting for Admin approval.")));
              },
              child: const Text("Submit Registration"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Theme Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (_, mode, __) => SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.brightness_4),
            value: mode == ThemeMode.dark,
            onChanged: (v) => themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
          ),
        ),
      ],
    );
  }
}
