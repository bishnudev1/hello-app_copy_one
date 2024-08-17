import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapnil_s_application4/core/utils/color_constant.dart';

class SizeChartScreen extends StatefulWidget {
  const SizeChartScreen({super.key});

  @override
  State<SizeChartScreen> createState() => _SizeChartScreenState();
}

class _SizeChartScreenState extends State<SizeChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? _selectedGender;
  String? _selectedCategory;

  final List<String> _genders = ['Male', 'Female'];
  final List<String> _categories = ['Topwear', 'Bottomwear', 'Footwear'];

  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Image.asset(
                "assets/images/back.png",
                height: 24,
              )),
        ),
        centerTitle: false,
        title: Text(
          'Size chart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        actions: [
          /// View Hello Store Button
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 14, top: 20),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppCol.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              labelColor: AppCol.primary,
              indicatorColor: AppCol.primary,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Standard chart'),
                Tab(text: 'Custom chart'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGender,
                        hint: const Text('Select Gender'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        items: _genders.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Size chart category',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategory,
                        hint: const Text('Select Category'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Image.asset('assets/newIcons/sizechart.png'),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Upload your custom size chart',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          children: [
                            _image != null
                                ? Image.file(
                              File(_image!.path),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                                : Icon(Icons.cloud_upload_outlined, size: 100,color: Colors.grey),
                            SizedBox(height: 20),
                            Text(
                              'Upload',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 18,right: 18),
                              child: Text(
                                'Supported format: PNG, JPG (Max file size: 5mb, Preferred image ratio 1:2)',
                                style: TextStyle(fontSize: 14,color: Colors.grey),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _getImage,
                              child: Text('Upload'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
