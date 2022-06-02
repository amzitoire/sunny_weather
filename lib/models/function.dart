import 'package:intl/intl.dart';

class GetJson{
  Map<String,dynamic> json ;

  GetJson(this.json);

  dailyJson(){
    return json['daily'];
  }
  hourlyJson(){
    return  json['hourly'];
  }
}

getCurrentTime(String hour, int weekday ,int month ,int day){
  var weekday1 = 1 == weekday ? "Monday"
      : weekday == 2
      ? "Tuesday"
      : weekday == 3
      ? "Wednesday"
      : weekday == 4
      ? "Thursday"
      : weekday == 5
      ?  "Friday"
      : weekday == 6
      ? "Saturday" : "Sunday";

  var month1 = 1 == month ? "JAN"
      : month == 2
      ? "FEB"
      : month == 3
      ? "MARS"
      : month == 4
      ? "APRIL"
      : month== 5
      ? "MAY"
      : month == 6
      ? "JUNE"
      : month == 7
      ? "JULY"
      : month == 8
      ? "AUG"
      : month == 9
      ? "SEPT"
      : month == 10
      ? "OCT"
      : month == 11
      ? "NOV" : "DEC";


  var currentTime = weekday1+','+day.toString()+' '+month1+', '+hour.toString()+':'+DateFormat("mm").format(DateTime.now()).toString();
  return currentTime;
}
getdailyTime(int weekday ,int month ,int day){
  var weekday1 = 1 == weekday ? "Monday"
      : weekday == 2
      ? "Tuesday"
      : weekday == 3
      ? "Wednesday"
      : weekday == 4
      ? "Thursday"
      : weekday == 5
      ?  "Friday"
      : weekday == 6
      ? "Saturday" : "Sunday";

  var month1 = 1 == month ? "JAN"
      : month == 2
      ? "FEB"
      : month == 3
      ? "MARS"
      : month == 4
      ? "APRIL"
      : month== 5
      ? "MAY"
      : month == 6
      ? "JUNE"
      : month == 7
      ? "JULY"
      : month == 8
      ? "AUG"
      : month == 9
      ? "SEPT"
      : month == 10
      ? "OCT"
      : month == 11
      ? "NOV" : "DEC";

  var currentTime = weekday1+', '+day.toString()+' '+month1;
  return currentTime;
}

getCloudCover(int cloudCover){
  /*
  *
  * 	Clear sky
1, 2, 3	Mainly clear, partly cloudy, and overcast
45, 48	Fog and depositing rime fog
51, 53, 55	Drizzle: Light, moderate, and dense intensity
56, 57	Freezing Drizzle: Light and dense intensity
61, 63, 65	Rain: Slight, moderate and heavy intensity
66, 67	Freezing Rain: Light and heavy intensity
71, 73, 75	Snow fall: Slight, moderate, and heavy intensity
77	Snow grains
80, 81, 82	Rain showers: Slight, moderate, and violent
85, 86	Snow showers slight and heavy
95 *	Thunderstorm: Slight or moderate
96, 99 *	Thunderstorm with slight and heavy hail
  *
  * */

  var cloudcover  = 0 == cloudCover ? "clear sky"
      : cloudCover == 1
      ? "mainly clear"
      : cloudCover == 2
      ? "partly cloudy"
      : cloudCover >= 3 && cloudCover <= 44
      ? "overcast"
      : cloudCover >= 45 && cloudCover <= 47
      ? "fog"
      : cloudCover >= 48 && cloudCover <= 50
      ? "depositing rime fog"
      : cloudCover >= 51 && cloudCover <= 60
      ? "drizzle"
      : cloudCover >= 61 && cloudCover <= 70
      ? "rain"
      : cloudCover >= 71 && cloudCover <= 79
      ? "rainy cloudy"
      :cloudCover >= 80 && cloudCover <= 84
      ? "rain showers"
      :cloudCover >= 85 && cloudCover <= 94
      ? "showers"
      :cloudCover >= 95
      ? "largely cloudy"
      :cloudCover >= 100
      ? "Cloudy"
      : "no data avalaible";
  return cloudcover;
}

getWeekday(int weekday){
  weekday++ ;
  var weekday1 = 1 == weekday ? "Monday"
      : weekday == 2
      ? "Tuesday"
      : weekday == 3
      ? "Wednesday"
      : weekday == 4
      ? "Thursday"
      : weekday == 5
      ?  "Friday"
      : weekday == 6
      ? "Saturday" : "Sunday";
  return weekday1;

}