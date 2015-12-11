defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  test "weather_format/1" do
    assert Weather.weather_format({10, 20, 30 ,:n, 40}) ==
      "It is 10 degrees.  Humidity is 20%.  Wind out of the north at 30MPH.  Cloud coverage is 40%."
  end

  test "base_weather/0" do
    assert Weather.base_weather == {70, 20, 5, :ne, 20}
  end
end
