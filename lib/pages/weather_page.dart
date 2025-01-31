import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../appTheme.dart';
import '../services/weather_services.dart';
import 'package:weather/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  /// api key
  WeatherServices weatherServices = WeatherServices(apiKey: "");

  Weather? _weather;

  /// fetch weather
  fetchweather() async {
    String cityName = await weatherServices.getCurrentCity();

    try {
      final weather = await weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchweather();
  }


  /// weather animations
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return AppTheme.sunnyAnimation;
    switch (mainCondition.toLowerCase()){
      case AppTheme.clouds:
      case AppTheme.mist:
      case AppTheme.haze:
      case AppTheme.smoke:
      case AppTheme.fog:
      case AppTheme.dust:
        return AppTheme.cloudyAnimation;
      case AppTheme.rain:
      case AppTheme.showerRain:
      case AppTheme.drizzle:
      return AppTheme.rainyAnimation;
      case AppTheme.thunderStorm:
        return AppTheme.rainyAnimation;
      case AppTheme.clear:
        return AppTheme.sunnyAnimation;
      default:
        return AppTheme.sunnyAnimation;
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Icon(AppTheme.locationIcon,size: 30,color: AppTheme.colorGrey,),
                Text(_weather?.cityName?? AppTheme.loadingCity,style: GoogleFonts.leagueGothic(color: AppTheme.colorGrey,fontSize:AppTheme.fontSizeLarge,letterSpacing: AppTheme.letterSpacingMedium)),
              ],
            ),

            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            Column(
              children: [
                Text('${_weather?.temperature.round()} ${AppTheme.celsiusSymbol}',style: GoogleFonts.leagueGothic(color: AppTheme.colorGrey,fontSize:AppTheme.fontSizeLarge,),),
                Text('${_weather?.mainCondition}',style: GoogleFonts.leagueGothic(color: AppTheme.colorGrey,fontSize:AppTheme.fontSizeSmall,)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
