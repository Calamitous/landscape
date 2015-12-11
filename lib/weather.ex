defmodule Weather do
  @season_base_temp %{:spring => 70, :summer => 80, :fall => 50, :winter => 20}
  @direction_str %{
    :n => 'North',
    :ne => 'Northeast',
    :e => 'East',
    :se => 'Southeast',
    :s => 'South',
    :sw => 'Southwest',
    :w => 'West',
    :nw => 'Northwest'
  }

  # {temp(-60..120), humidity(0..100), windspeed(0..250), wind_direction([:n, :ne...]), cloud_cover(0..100)}
  def base_weather(), do:  {70, 20, 3, :ne, 20}

  def weather_format({temp, hum, spd, dir, cov}) do
    "It is #{temp} degrees.  Humidity is #{hum}%.  Wind out of the #{@direction_str[dir]} at #{spd}MPH.  Cloud coverage is #{cov}%. "
  end
end
