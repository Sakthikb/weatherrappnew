import 'package:flutter/material.dart';

import 'package:weatherappnew/ui/api.dart';
import 'package:weatherappnew/ui/weathermodel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              _buildSearchWidget(),
              SizedBox(
                height: 10,
              ),
              if (inProgress)
                CircularProgressIndicator()
              else
                Expanded(
                    child: SingleChildScrollView(child:
                    _buildWeatherWidget())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search any location',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onFieldSubmitted: (value) {
          _getWeatherData(value);
        },
      ),
    );
  }

  Widget _buildWeatherWidget() {
    // return Text(response?.toJson().toString() ?? "");
    if (response == null) {
      return Text(message);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on,
                size: 50,
              ),
              Text(
                response?.location?.name ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                (response?.location?.country ?? ""),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment:CrossAxisAlignment.center ,
            children:[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(
                    (response?.current?.tempC.toString() ?? "") + "°c",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0),
                child: Text(
                  (response?.current?.condition?.text.toString() ?? ""),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          Card(
            elevation: 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Humidity",
                        response?.current?.humidity?.toString() ?? ""),
                    _dataAndTitleWidget(
                        "Wind Speed",
                        (response?.current?.windKph?.toString() ?? "") +
                            " km/h"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget(
                        "UV", response?.current?.uv?.toString() ?? ""),
                    _dataAndTitleWidget(
                        "Percipitation",
                        (response?.current?.precipMm?.toString() ?? "") +
                            " mm"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Local Time",
                        response?.location?.localtime?.split(" ").last ?? ""),
                    _dataAndTitleWidget(
                        "Local Date",
                        (response?.location?.localtime?.split(" ").first ??
                            "")),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(
            data,
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 27),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });
    try {
      response = await WeatherApi().getCurrentWeather(location);
      if (response != null && response?.location != null) {
        print(
            "Location: ${response?.location?.name}, Country: ${response?.location?.country}");
      } else {
        print("No data received for the given location.");
      }
    } catch (e) {
     setState(() {
       message = "Failed to get weather";
       response = null;
     });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }


}
