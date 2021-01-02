class Rover {
  String name;

  String sols;
  String missionTime;
  String solarTime;

  Rover(String name) {
    this.name = name;
  }

  setTimes(String sols, String missionTime, String solarTime) {
    this.sols = sols;
    this.missionTime = missionTime;
    this.solarTime = solarTime;
    return this;
  }

  @override
  String toString() {
    return "${this.name}:\n" +
        "\tMission Sols: ${this.sols}\n" +
        "\tMission Time: ${this.missionTime}\n" +
        "\tLocal True Solar Time: ${this.solarTime}";
  }
}
