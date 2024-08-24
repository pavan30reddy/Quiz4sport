import 'package:flutter/material.dart';
import 'category.dart';
import 'rules.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  int? _age;
  String? _favoriteSport;
  bool _isProfileCreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizCategoryScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Rules'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RulesScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Ensure you have this image in your assets
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: _isProfileCreated
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: $_name', style: TextStyle(fontSize: 18, color: Colors.white)),
                            if (_email != null) Text('Email: $_email', style: TextStyle(fontSize: 18, color: Colors.white)),
                            Text('Age: $_age', style: TextStyle(fontSize: 18, color: Colors.white)),
                            Text('Favorite Sport: $_favoriteSport', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizCategoryScreen()),
                        );
                      },
                      child: Text('Categories'),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Email (optional)'),
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _age = int.tryParse(value!);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Favorite Sport'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your favorite sport';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _favoriteSport = value;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                _isProfileCreated = true;
                              });
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
