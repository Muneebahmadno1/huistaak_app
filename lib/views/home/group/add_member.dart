import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_widgets.dart';
import '../widgets/add_members_widget.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  List<int> selectedIndex = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: CustomAppBar(
          pageTitle: "Add Member",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () {
                        if (selectedIndex.contains(i)) {
                          selectedIndex.remove(i);
                        } else {
                          selectedIndex.add(i);
                        }
                        setState(() {});
                      },
                      child: AddMemberWidget(
                        suffixIcon: "assets/images/man1.jpg",
                        isActive: selectedIndex.contains(i),
                        title: "Wade Warren",
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
