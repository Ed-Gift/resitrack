import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum AdminView { board, reports, analytics }

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  AdminView _currentView = AdminView.board;

  // Mock data for the Kanban board with detailed reports
  final Map<String, List<Map<String, dynamic>>> kanbanData = {
    "New Requests": [
      {
        "id": "REQ101",
        "title": "Broken Window",
        "user": "John D.",
        "residence": "Sunset Heights",
        "room": "B-204",
        "priority": "High",
        "label": "Maintenance",
        "description": "Large crack in the main window pane due to heavy wind. Requires glass replacement.",
        "date": "2023-10-25",
        "technician": null,
      },
      {
        "id": "REG205",
        "title": "Room Registration",
        "user": "Sarah S.",
        "residence": "Ocean View",
        "room": "A-102",
        "priority": "Medium",
        "label": "Admin",
        "description": "New student registration for Semester 2.",
        "date": "2023-10-26",
        "technician": null,
      },
      {
        "id": "REQ105",
        "title": "Leaking Tap",
        "user": "Mike T.",
        "residence": "Valley Lodge",
        "room": "C-305",
        "priority": "Medium",
        "label": "Plumbing",
        "description": "Kitchen tap is dripping constantly, wasting water.",
        "date": "2023-10-27",
        "technician": null,
      },
    ],
    "In Progress": [
      {
        "id": "REQ098",
        "title": "Elevator Service",
        "user": "Maintenance Dept",
        "residence": "Sunset Heights",
        "room": "Block A",
        "priority": "Critical",
        "label": "Urgent",
        "description": "Elevator stuck between floor 2 and 3. Emergency maintenance required.",
        "date": "2023-10-24",
        "technician": "Eng. Robert",
      },
    ],
    "Pending Review": [
      {
        "id": "REG201",
        "title": "Room 302 Move-in",
        "user": "Anna L.",
        "residence": "Ocean View",
        "room": "302",
        "priority": "Medium",
        "label": "Inventory",
        "description": "Inventory check passed with minor marks on walls.",
        "date": "2023-10-22",
        "technician": "Inspector Gadget",
      },
    ],
    "Completed": [
      {
        "id": "REQ085",
        "title": "Light Bulb Replacement",
        "user": "Common Area",
        "residence": "Valley Lodge",
        "room": "Lounge",
        "priority": "Low",
        "label": "Electrical",
        "description": "Replaced 3 LED bulbs in the main lounge.",
        "date": "2023-10-20",
        "technician": "Electrician Sam",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                _buildBoardHeader(),
                Expanded(child: _buildMainView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    switch (_currentView) {
      case AdminView.board:
        return _buildKanbanBoard();
      case AdminView.reports:
        return _buildDetailedReportsList();
      case AdminView.analytics:
        return _buildAnalyticsView();
    }
  }

  Widget _buildSidebar() {
    return Container(
      width: 70,
      color: const Color(0xFFEBEBEB),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _sidebarIcon(Icons.business, isSelected: true),
          _sidebarIcon(Icons.notifications_none),
          _sidebarIcon(Icons.chat_bubble_outline),
          _sidebarIcon(Icons.people_outline),
          _sidebarIcon(Icons.calendar_today_outlined),
          _sidebarIcon(Icons.folder_open),
          const Spacer(),
          _sidebarIcon(Icons.help_outline),
          _sidebarIcon(Icons.settings_outlined),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool isSelected = false}) {
    const Color activeColor = Color(0xFF4B4C7B);
    const Color inactiveColor = Color(0xFF5F5F5F);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: isSelected ? const BoxDecoration(
        border: Border(left: BorderSide(color: activeColor, width: 3))
      ) : null,
      child: IconButton(
        icon: Icon(icon, color: isSelected ? activeColor : inactiveColor),
        onPressed: () {},
      ),
    );
  }

  Widget _buildTopBar() {
    const Color textColor = Color(0xFF5F5F5F);
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.menu, color: textColor),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F2F1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18, color: textColor),
                  SizedBox(width: 10),
                  Text("Search ResiTrack Admin", style: TextStyle(color: textColor, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          const CircleAvatar(radius: 15, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=admin")),
        ],
      ),
    );
  }

  Widget _buildBoardHeader() {
    const Color primaryColor = Color(0xFF4B4C7B);
    const Color textColor = Color(0xFF5F5F5F);
    const Color headingColor = Color(0xFF374151);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard_outlined, color: primaryColor),
              const SizedBox(width: 10),
              const Text("General Board", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: headingColor)),
              const SizedBox(width: 20),
              _tabButton("Board", AdminView.board),
              const SizedBox(width: 20),
              _tabButton("Detailed Reports", AdminView.reports),
              const SizedBox(width: 20),
              _tabButton("Analytics", AdminView.analytics),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _showAddTaskDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Add Task"),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard("Total Requests", "${_getTotalRequests()}", Icons.assignment),
              const SizedBox(width: 15),
              _buildStatCard("High Priority", "${_getPriorityCount('High') + _getPriorityCount('Critical')}", Icons.warning_amber_rounded, color: const Color(0xFFB91C1C)),
              const SizedBox(width: 15),
              _buildStatCard("In Progress", "${kanbanData['In Progress']?.length ?? 0}", Icons.sync, color: const Color(0xFF4B4C7B)),
              const Spacer(),
              const Icon(Icons.filter_list, size: 20, color: textColor),
              const SizedBox(width: 15),
              const Icon(Icons.sort, size: 20, color: textColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String text, AdminView view) {
    bool isSelected = _currentView == view;
    const Color primaryColor = Color(0xFF4B4C7B);
    const Color textColor = Color(0xFF5F5F5F);

    return InkWell(
      onTap: () => setState(() => _currentView = view),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: isSelected ? const BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor, width: 2))) : null,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? primaryColor : textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 12),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  Widget _buildKanbanBoard() {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: kanbanData.keys.map((column) => _buildKanbanColumn(column)).toList(),
    );
  }

  Widget _buildKanbanColumn(String title) {
    final tasks = kanbanData[title]!;
    const Color iconColor = Color(0xFF5F5F5F);
    const Color headingColor = Color(0xFF374151);
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: headingColor)),
                const Icon(Icons.add, size: 18, color: iconColor),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    Color priorityColor = const Color(0xFF9CA3AF);
    if (task['priority'] == 'High') priorityColor = const Color(0xFFD97706);
    if (task['priority'] == 'Critical') priorityColor = const Color(0xFFB91C1C);
    
    const Color subTextColor = Color(0xFF5F5F5F);
    const Color titleColor = Color(0xFF374151);

    return InkWell(
      onTap: () => _showTaskDetails(task),
      child: Card(
        elevation: 0.5,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 3, height: 15, color: priorityColor),
                  const SizedBox(width: 8),
                  Text(task['id'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: subTextColor)),
                  const Spacer(),
                  const Icon(Icons.more_horiz, size: 16, color: subTextColor),
                ],
              ),
              const SizedBox(height: 8),
              Text(task['title'], style: const TextStyle(fontWeight: FontWeight.w600, color: titleColor, fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 12, color: subTextColor),
                  const SizedBox(width: 4),
                  Text("${task['residence']} - ${task['room']}", style: const TextStyle(fontSize: 11, color: subTextColor)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text(task['label'], style: const TextStyle(fontSize: 10, color: subTextColor)),
                  ),
                  const Spacer(),
                  if (task['technician'] != null)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.build_circle_outlined, size: 16, color: Color(0xFF4B4C7B)),
                    ),
                  CircleAvatar(radius: 12, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${task['user']}")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedReportsList() {
    final List<Map<String, dynamic>> allReports = [];
    for (var list in kanbanData.values) {
      allReports.addAll(list);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Residence')),
              DataColumn(label: Text('Room')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Priority')),
              DataColumn(label: Text('Technician')),
              DataColumn(label: Text('Actions')),
            ],
            rows: allReports.map((report) => DataRow(cells: [
              DataCell(Text(report['id'])),
              DataCell(Text(report['residence'])),
              DataCell(Text(report['room'])),
              DataCell(Text(report['title'])),
              DataCell(Text(report['priority'], style: TextStyle(color: _getPriorityColor(report['priority'])))),
              DataCell(Text(report['technician'] ?? "Unassigned")),
              DataCell(IconButton(icon: const Icon(Icons.analytics_outlined), onPressed: () => _showTaskDetails(report))),
            ])).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Residence Health & Maintenance Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildChartCard("Maintenance by Residence", _buildBarChart())),
              const SizedBox(width: 20),
              Expanded(child: _buildChartCard("Report Status Distribution", _buildPieChart())),
            ],
          ),
          const SizedBox(height: 20),
          _buildChartCard("Average Response Time (Days)", _buildLineChart()),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5F5F5F))),
          const SizedBox(height: 20),
          Expanded(child: chart),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    // Dynamically calculate counts per residence
    final Map<String, int> resCounts = {};
    for (var list in kanbanData.values) {
      for (var task in list) {
        final res = task['residence'] ?? 'Other';
        resCounts[res] = (resCounts[res] ?? 0) + 1;
      }
    }
    final residences = resCounts.keys.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (resCounts.values.isEmpty ? 10 : resCounts.values.reduce((a, b) => a > b ? a : b) + 5).toDouble(),
        barGroups: residences.asMap().entries.map((e) {
          return BarChartGroupData(x: e.key, barRods: [BarRodData(toY: resCounts[e.value]!.toDouble(), color: const Color(0xFF4B4C7B))]);
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < residences.length) {
                  return Text(residences[value.toInt()].split(' ')[0], style: const TextStyle(fontSize: 9));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChart() {
    int total = _getTotalRequests();
    if (total == 0) return const Center(child: Text("No Data"));
    
    int newCount = kanbanData["New Requests"]?.length ?? 0;
    int progressCount = kanbanData["In Progress"]?.length ?? 0;
    int pendingCount = kanbanData["Pending Review"]?.length ?? 0;
    int doneCount = kanbanData["Completed"]?.length ?? 0;

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: newCount.toDouble(), color: const Color(0xFF4B4C7B), title: 'New', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: progressCount.toDouble(), color: const Color(0xFFD97706), title: 'Active', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: pendingCount.toDouble(), color: Colors.blueGrey, title: 'Review', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
          PieChartSectionData(value: doneCount.toDouble(), color: Colors.green, title: 'Done', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true, rightTitles: AxisTitles(), topTitles: AxisTitles()),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 1),
              const FlSpot(2, 4),
              const FlSpot(3, 2),
              const FlSpot(4, 5),
            ],
            isCurved: true,
            color: const Color(0xFF4B4C7B),
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: const Color(0xFF4B4C7B).withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final residenceController = TextEditingController();
    final roomController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = "Medium";
    String selectedLabel = "Maintenance";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Task/Report"),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: "Task Title")),
                TextField(controller: residenceController, decoration: const InputDecoration(labelText: "Residence")),
                TextField(controller: roomController, decoration: const InputDecoration(labelText: "Room/Location")),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: selectedPriority,
                  items: ["Low", "Medium", "High", "Critical"].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (val) => selectedPriority = val!,
                  decoration: const InputDecoration(labelText: "Priority"),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedLabel,
                  items: ["Maintenance", "Admin", "Plumbing", "Electrical", "Inventory"].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (val) => selectedLabel = val!,
                  decoration: const InputDecoration(labelText: "Category"),
                ),
                TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B4C7B), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                kanbanData["New Requests"]!.add({
                  "id": "REQ${100 + kanbanData["New Requests"]!.length + 1}",
                  "title": titleController.text,
                  "user": "Staff Admin",
                  "residence": residenceController.text,
                  "room": roomController.text,
                  "priority": selectedPriority,
                  "label": selectedLabel,
                  "description": descController.text,
                  "date": DateTime.now().toString().split(' ')[0],
                  "technician": null,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Create Task"),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text("Report Detail: ${task['id']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ],
        ),
        content: SizedBox(
          width: 550,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailItem("Title", task['title']),
                _detailItem("Residence", task['residence']),
                _detailItem("Room", task['room']),
                _detailItem("Reported By", task['user']),
                _detailItem("Date", task['date']),
                _detailItem("Priority", task['priority'], color: _getPriorityColor(task['priority'])),
                _detailItem("Category", task['label']),
                const Divider(height: 30),
                const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(task['description'] ?? "No description provided.", style: const TextStyle(color: Colors.black87)),
                const Divider(height: 30),
                const Text("Assignment & Actions:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text("Assign Technician:"),
                    const SizedBox(width: 15),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: task['technician'],
                        hint: const Text("Select Specialist"),
                        decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                        items: ["Eng. Robert", "Electrician Sam", "Plumber Joe", "Inspector Gadget"]
                            .map((name) => DropdownMenuItem(value: name, child: Text(name)))
                            .toList(),
                        onChanged: (val) {
                          setState(() => task['technician'] = val);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4B4C7B), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Task successfully assigned and updated.")));
            },
            child: const Text("Apply Changes"),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value, style: TextStyle(color: color, fontWeight: color != null ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  int _getTotalRequests() {
    int count = 0;
    for (var list in kanbanData.values) {
      count += list.length;
    }
    return count;
  }

  int _getPriorityCount(String priority) {
    int count = 0;
    for (var list in kanbanData.values) {
      count += list.where((task) => task['priority'] == priority).length;
    }
    return count;
  }

  Color _getPriorityColor(String priority) {
    if (priority == 'High') return const Color(0xFFD97706);
    if (priority == 'Critical') return const Color(0xFFB91C1C);
    return const Color(0xFF9CA3AF);
  }
}
