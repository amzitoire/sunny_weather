
import 'package:intl/intl.dart';
import 'function.dart';

class Meteo{
  late String currentTemp ;
  late String currentCloudCover ;
  late String currentTime ;

  late List<dynamic> cloudCoverHourly;
  late List<dynamic> timeHourly;
  late List<dynamic> tempHourly;

  late List<dynamic> timeDaily;
  late List<dynamic> tempMaxDaily;
  late List<dynamic> tempMinDaily;

  Meteo();

  meteoDaily(List<dynamic> timeDaily, List<dynamic> tempMaxDaily, List<dynamic> tempMinDaily,
      ){
    this.timeDaily = timeDaily;
    this.tempMaxDaily= tempMaxDaily;
    this.tempMinDaily = tempMinDaily;
  }
  meteoHourly(List<dynamic> timeHourly, List<dynamic> tempHourly, List<dynamic> cloudCoverHourly,
      ){
    this.timeHourly = timeHourly;
    this.tempHourly= tempHourly;
    this.cloudCoverHourly = cloudCoverHourly;
  }
  


  factory Meteo.fromJson(Map<String,dynamic> json, [int? offset]) {

    Map<String,dynamic> daily = GetJson(json).dailyJson();
    Map<String,dynamic> hourly = GetJson(json).hourlyJson();

    DateFormat format =  DateFormat("yyyy-MM-ddTHH:mm");
    //var utc_offset_seconds= json["utc_offset_seconds"];

    Meteo meteo = Meteo();
    int offset1 = offset ?? 0;

    //var now = DateTime.now().hour+offset1;
   // var now = DateTime.now().add(Duration(seconds: utc_offset_seconds)).hour;


    meteo.meteoDaily(
      daily['time'],
      daily['temperature_2m_max'],
      daily['temperature_2m_min'],
    );

    meteo.meteoHourly(
      hourly['time'] ,
      hourly['temperature_2m'] ,
      hourly['cloudcover'] ,);

    var now = meteo.timeHourly.indexOf(DateFormat("yyyy-MM-ddTHH:00").format(DateTime.now()))+offset1;

    meteo.currentTemp= meteo.tempHourly[now].toString();


    //var hour = format.parse(meteo.timeHourly[now].toString()).hour;
    var hour = DateFormat("HH").format(format.parse(meteo.timeHourly[now].toString()));
    var weekday = format.parse(meteo.timeHourly[now].toString()).weekday;
    var day = format.parse(meteo.timeHourly[now].toString()).day;
    var month = format.parse(meteo.timeHourly[now].toString()).month;
    var cloudcover = meteo.cloudCoverHourly[now];

    DateFormat formatDaily =  DateFormat("yyyy-MM-dd");
    for(var time in meteo.timeDaily){
      var weekdayD = formatDaily.parse(time.toString()).weekday;
      var dayD = formatDaily.parse(time.toString()).day;
      var monthD = formatDaily.parse(time.toString()).month;

      meteo.timeDaily[meteo.timeDaily.indexOf(time)] = getdailyTime(weekdayD, monthD, dayD);
    }


    meteo.currentTime= getCurrentTime(hour, weekday, month, day);
    meteo.currentCloudCover= getCloudCover(cloudcover);

   return meteo;
 }


}


