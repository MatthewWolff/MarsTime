import 'dart:math' as math;

import 'package:MarsTime/rover.dart';

// https://github.com/jtauber/mars-clock/blob/gh-pages/index.html

cos(deg) {
  return math.cos(deg * math.pi / 180);
}

sin(deg) {
  return math.sin(deg * math.pi / 180);
}

hToHMS(h) {
  var x = h * 3600;
  var hh = (x / 3600).floor();
  if (hh < 10) hh = "0" + hh.toString();
  var y = x % 3600;
  var mm = (y / 60).floor();
  if (mm < 10) mm = "0" + mm.toString();
  var ss = (y % 60).round();
  if (ss < 10) ss = "0" + ss.toString();
  return hh.toString() + ":" + mm.toString() + ":" + ss.toString();
}

within_24(n) {
  if (n < 0) {
    n += 24;
  } else if (n >= 24) {
    n -= 24;
  }
  return n;
}

Map<String, Rover> getTimes() {
  // Difference between TAI and UTC. This value should be
  // updated each time the IERS announces a leap second.
  var taiOffset = 37;

  // Last time the above value changed.
  var lastLeapSecond = "1 January 2017";

  var millis = DateTime.now().millisecondsSinceEpoch;
  var jdUt = 2440587.5 + (millis / 8.64E7);
  var jdTt = jdUt + (taiOffset + 32.184) / 86400;
  var j2000 = jdTt - 2451545.0;
  var m = (19.3870 + 0.52402075 * j2000) % 360;
  var alphaFms = (270.3863 + 0.52403840 * j2000) % 360;
  var pbs = 0.0071 * cos((0.985626 * j2000 / 2.2353) + 49.409) +
      0.0057 * cos((0.985626 * j2000 / 2.7543) + 168.173) +
      0.0039 * cos((0.985626 * j2000 / 1.1177) + 191.837) +
      0.0037 * cos((0.985626 * j2000 / 15.7866) + 21.736) +
      0.0021 * cos((0.985626 * j2000 / 2.1354) + 15.704) +
      0.0020 * cos((0.985626 * j2000 / 2.4694) + 95.528) +
      0.0018 * cos((0.985626 * j2000 / 32.8493) + 49.095);
  var nuM = (10.691 + 3.0E-7 * j2000) * sin(m) +
      0.623 * sin(2 * m) +
      0.050 * sin(3 * m) +
      0.005 * sin(4 * m) +
      0.0005 * sin(5 * m) +
      pbs;
  var lS = (alphaFms + nuM) % 360;
  var eot =
      2.861 * sin(2 * lS) - 0.071 * sin(4 * lS) + 0.002 * sin(6 * lS) - nuM;
  var msd = (((j2000 - 4.5) / 1.027491252) + 44796.0 - 0.00096);
  var mtc = (24 * msd) % 24;

  var curiosityLambda = 360 - 137.4;
  int curiositySol = (msd - curiosityLambda / 360).floor() - 49268;
  double curiosityLmst = within_24(mtc - curiosityLambda * 24 / 360);
  double curiosityLtst = within_24(curiosityLmst + eot * 24 / 360);

  var opportunitySolDate = msd - 46235 - 0.042431;
  int opportunitySol = opportunitySolDate.floor();
  double opportunityMission = (24 * opportunitySolDate) % 24;
  double opportunityLtst = within_24(opportunityMission + eot * 24 / 360);

  return {
    "Opportunity": new Rover("Opportunity").setTimes(
      opportunitySol.toString(),
      hToHMS(opportunityMission),
      hToHMS(opportunityLtst),
    ),
    "Curiosity": new Rover("Curiosity").setTimes(
      curiositySol.toString(),
      hToHMS(curiosityLmst),
      hToHMS(curiosityLtst),
    ),
  };
}

// testing
main() {
  getTimes().forEach((name, rover) => print(rover));
}
