defmodule Sim do
  def run do
    Landscape.build_map(50, 15)
    |> Landscape.add_water
    |> run(false)
  end

  def run(map, false) do
    map
    |> Landscape.Display.print_map
    |> Landscape.update
    |> run(should_stop(IO.getn('--------- q to quit: ')))
  end

  def run(_, true), do: IO.puts 'Bye!'
  def should_stop(key), do: key == "q"
end
