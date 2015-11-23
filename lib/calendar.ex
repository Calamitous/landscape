defmodule Calendar do
  @seasons %{:spring => :summer, :summer => :fall, :fall => :winter, :winter => :spring}
  @season_length 30

  def first_day(), do:  {1, :spring, 1}

  def next_day({year, season, day}) when day >= @season_length, do: next_season({year, season, 1})
  def next_day({year, season, day}),                             do: {year, season, day + 1}

  def next_season({year, :winter, day}), do: {year + 1, @seasons[:winter], day}
  def next_season({year, season, day}), do: {year, @seasons[season], day}
end