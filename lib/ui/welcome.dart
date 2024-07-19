import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class City {
  String city;
  bool isSelected;
  bool isDefault;

  City({
    required this.city,
    this.isSelected = false,
    this.isDefault = false,
  });
}


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<City> cities = [
    City(city: 'Madurai'),
    City(city: 'Chennai'),
    City(city: 'Salem', isDefault: true),
    City(city: 'Bangalore'),
    City(city: 'Hyderabad'),
    City(city: 'Kodaikanal'),
    City(city: 'Ooty'),
    City(city: 'Nagerkovil'),
    City(city: 'Kochi'),
    City(city: 'Kannur'),
  ];

  @override
  Widget build(BuildContext context) {
    // List<City> cities = City.citiesList.where((city) => !city.isDefault).toList();
    // List<City> selectedCities = City.getSelectedCities();
    //
    Constants myConstants = Constants();
    Size size = MediaQuery.of(context).size;
    print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${cities}");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myConstants.primaryColor,
        title: Text('Welcome'),
        centerTitle: true,
      ),
      body:
      // cities.isEmpty
      //     ? Center(child: Text('No cities available')) // Show a message if no cities
          ListView.builder(
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              setState(() {
                cities[index].isSelected = !cities[index].isSelected;
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 20, right: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: size.height * .08,
              width: size.width,
              decoration: BoxDecoration(
                border: cities[index].isSelected
                    ? Border.all(
                  color: myConstants.secondaryColor.withOpacity(.6),
                  width: 2,
                )
                    : Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    cities[index].isSelected ? "lib/assets/checked.png" : "lib/assets/unchecked.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    cities[index].city,
                    style: TextStyle(
                      fontSize: 16,
                      color: cities[index].isSelected ? myConstants.primaryColor : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<City> selectedCities = cities.where((City) => City.isSelected).toList();
          print(selectedCities.length);
        },
        child: Icon(Icons.pin_drop),
      ),
    );
  }
}
