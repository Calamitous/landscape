defmodule Sim do
  def run do
    Landscape.build_map
    |> Landscape.create_elevations
    |> Landscape.add_random_water
    |> run(false)
  end

  def run(map, false) do
    # :timer.sleep(1000)

    map = map
    |> Landscape.print_map
    |> Landscape.update_map
    |> run(should_stop(IO.getn('--------- q to quit: ')))

    map
  end

  def run(map, true) do
    IO.puts 'Bye!'
  end

  def should_stop(foo) do
    foo == "q"
  end
end
