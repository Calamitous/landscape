defmodule Sim do
  def add_calendar(map), do: {map, {1, :spring, 1, :pause}}

  def run do
    Landscape.build_map(50, 15)
    |> Landscape.add_water
    |> add_calendar
    |> run(false)
  end

  def run(world, false) do
    world
    |> Landscape.Display.print_map
    |> Landscape.update
    |> run(should_stop(IO.getn('--------- q to quit: ')))
  end

  def run(_, true), do: IO.puts 'Bye!'
  def should_stop(key), do: key == "q"
end
