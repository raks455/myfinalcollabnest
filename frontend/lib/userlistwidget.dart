
import 'package:flutter/material.dart';

class UserListWidget extends StatelessWidget {
  final List<dynamic> users;
  final Function(String) onUpdateUser;
  final Function(String) onDeleteUser;

  UserListWidget({
    required this.users,
    required this.onUpdateUser,
    required this.onDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Text('ID'),
        ),
        DataColumn(
          label: Text('Email'),
        ),
        DataColumn(
          label: Text('UserId'),
        ),
        DataColumn(
          label: Text('Full Name'),
        ),
        DataColumn(
          label: Text('Organization'),
        ),
        DataColumn(
          label: Text('Actions'),
        ),
      ],
      rows: users.map((user) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(user['_id']?.toString() ?? '')),
            DataCell(Text(user['email'] ?? '')),
            DataCell(Text(user['username'] ?? '')),
            DataCell(Text(user['fullname'] ?? '')),
            DataCell(Text(user['organization'] ?? '')),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => onUpdateUser(user['_id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => onDeleteUser(user['_id']),
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
