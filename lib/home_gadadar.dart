import 'package:flutter/material.dart';
import 'dart:convert';
import 'websocket.dart';

class HomePageGadadar extends StatefulWidget {
  final WebSocketService wsService;

  const HomePageGadadar({Key? key, required this.wsService}) : super(key: key);

  @override
  _HomePageGadadarState createState() => _HomePageGadadarState();
}

class _HomePageGadadarState extends State<HomePageGadadar> {
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    widget.wsService.events.listen((event) {
      if (event.type == WebSocketEventType.message) {
        setState(() {
          weatherData = jsonDecode(event.data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UDAWA Gadadar'),
        leading: IconButton(
          icon: const Icon(Icons.menu, semanticLabel: 'menu'),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, semanticLabel: 'search'),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, semanticLabel: 'filter'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGridCardsRelay(4), // Adjust this as necessary
            ),
          ),
          if (weatherData != null) WeatherWidget(weatherData: weatherData!),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

List<Card> _buildGridCardsRelay(int count) {
  List<Card> cards = List.generate(
    count,
    (int index) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18.0 / 11.0,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Title'),
                  SizedBox(height: 8.0),
                  Text('Secondary Text'),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
  return cards;
}

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherWidget({Key? key, required this.weatherData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weatherSensor = weatherData['weatherSensor'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text("Temperature: ${weatherSensor['celc']}°C"),
              Text("Humidity: ${weatherSensor['rh']}%"),
              Text("Altitude: ${weatherSensor['alt']} meters"),
              Text("Pressure: ${weatherSensor['hpa']} hPa"),
            ],
          ),
        ),
      ),
    );
  }
}
