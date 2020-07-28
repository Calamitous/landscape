defmodule Calendar do
  use GenServer
  @season_progression %{:spring => :summer, :summer => :fall, :fall => :winter, :winter => :spring}
  @advancement_speed  %{:pause => 0, :minute => 1, :hour => 60, :day => 60 * 24}
  @season_length 30

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: :calendar)

  def init(_) do
    :timer.send_interval(1000, :advance)
    {:ok, {1, :spring, 1, 8, 0, :minute}}
  end

  def handle_info(:advance, state),     do: {:noreply, advance(state)}
  def handle_call(:glance, _, state), do: {:reply, date_format(state), state}

  def glance, do: GenServer.call(:calendar, :glance)

  def notify_watchers(state) do
    # Interface.advance date_format(state)
    state
  end

  def advance(state, 0), do: state
  def advance(state, times), do: state |> next_minute |> advance(times - 1)
  def advance({y, season, d, h, m, speed}) do
    advance({y, season, d, h, m, speed}, @advancement_speed[speed])
    |> notify_watchers
  end

  def next_minute({y, season, d, h, m, speed}) when m >= 59, do: next_hour({y, season, d, h, 0, speed})
  def next_minute({y, season, d, h, m, speed}),              do: {y, season, d, h, m + 1, speed}

  def next_hour({y, season, d, h, m, speed}) when h >= 23, do: next_day({y, season, d, 0, m, speed})
  def next_hour({y, season, d, h, m, speed}),              do: {y, season, d, h + 1, m, speed}

  def next_day({y, season, d, h, m, speed}) when d >= @season_length, do: next_season({y, season, 1, h, m, speed})
  def next_day({y, season, d, h, m, speed}),                          do: {y, season, d + 1, h, m, speed}

  def next_season({y, :winter, d, speed}), do: {y + 1, @season_progression[:winter], d, speed}
  def next_season({y, season, d, speed}),  do: {y, @season_progression[season], d, speed}

  def season_string(season), do: season |> to_string |> String.capitalize

  def day_icon(hour) when hour < 15, do: '☀' #  '\u2600' #
  def day_icon(_),                   do: '☾'

  # def date_format({y, season, d, h, m, _}), do: "#{h}:#{String.rjust(to_string(m), 2, ?0)} #{season_string(season)} #{d}, Year #{y}"
  def date_format({y, season, d, h, m, _}) do
    formatted_hours = String.rjust(to_string(h), 2, ?0)
    formatted_minutes = String.rjust(to_string(m), 2, ?0)
    "#{day_icon(1)} c #{formatted_hours}:#{formatted_minutes} #{season_string(season)} #{d}, Year #{y}"
  end
end
