defmodule Sim do
  def run do
    Landscape.build_map
    |> Landscape.add_water
    |> run(false)
  end

  def run(map, false) do
    map = map
    |> Landscape.print_map
    |> Landscape.update_map
    |> run(should_stop(IO.getn('--------- q to quit: ')))
  end

  def run(map, true), do: IO.puts 'Bye!'
  def should_stop(key), do: key == "q"
end