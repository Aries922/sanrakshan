import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateIssue extends StatefulWidget {
  final LatLng location;

  const CreateIssue({super.key, required this.location});
  @override
  _CreateIssueState createState() => _CreateIssueState();
}

class _CreateIssueState extends State<CreateIssue> {
  final _firebaseStorage = FirebaseStorage.instance;
  CollectionReference student = FirebaseFirestore.instance.collection('issues');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedDropdownValue;
  TextEditingController _textFieldController = TextEditingController();
  File? _selectedFile;

  // Function to handle file picker
  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedDropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDropdownValue = newValue;
                  });
                },
                items: <String>[
                  'Major Problem',
                  'Minor Problem',
                  'Normal Issue',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select an option',
                ),
              ),
              TextFormField(
                controller: _textFieldController,
                decoration: InputDecoration(labelText: 'Enter text'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Pick a File'),
              ),
              SizedBox(
                height: 5,
              ),
              _selectedFile != null
                  ? SizedBox(height: 200, child: Image.file(_selectedFile!))
                  : SizedBox.shrink(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Validate the form
                      if (_selectedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please Select Image")));
                      }
                      if (_formKey.currentState!.validate()) {
                        //Upload to Firebase
                        var snapshot = await _firebaseStorage
                            .ref()
                            .child(_selectedFile!.path)
                            .putFile(_selectedFile!);
                        var downloadUrl = await snapshot.ref.getDownloadURL();
                        // print(downloadUrl);
                        // String selectedOption = _selectedDropdownValue ?? "";
                        // String enteredText = _textFieldController.text;
                        // Use these values as needed
                        await add(downloadUrl);
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> add(String url) {
    // Calling the collection to add a new user
    return student
        //adding to firebase collection
        .add({
          //Data added in the form of a dictionary into the document.
          'type': _selectedDropdownValue,
          'detail': _textFieldController.text,
          'media': url,
          'lat':widget.location.latitude,
          'long':widget.location.longitude,

        })
        .then((value) => print("Student data Added"))
        .catchError((error) => print("Student couldn't be added."));
  }
}
