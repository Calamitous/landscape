defmodule Calendar do
  @season_progression %{:spring => :summer, :summer => :fall, :fall => :winter, :winter => :spring}
  @season_length 30

  def first_day(), do:  {1, :spring, 1}

  def next_day({map, cal}),                                     do: {map, next_day(cal)}
  def next_day({year, season, day}) when day >= @season_length, do: next_season({year, season, 1})
  def next_day({year, season, day}),                            do: {year, season, day + 1}

  def next_season({year, :winter, day}), do: {year + 1, @season_progression[:winter], day}
  def next_season({year, season, day}),  do: {year, @season_progression[season], day}

  def season_string(season) do
    season
    |> to_string
    |> String.capitalize
  end

  def date_format({year, season, day}), do: "#{season_string(season)} #{day}, Year #{year}"
end
