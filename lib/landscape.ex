defmodule Landscape do
  @width 10
  @height 10

  def run_sim do
    build_map
    |> create_elevations
    |> add_random_water
    |> run_sim
  end

  def run_sim(map) do
    :timer.sleep(100)
    map = map
    |> update_map
    |> print_map
    # |> run_sim
    IO.puts("------")

    map
  end

  def elem_to_xy(elem), do: {div(elem, @width) - 1, rem(elem, @height) - 1}

  def neighbors(ma, {x, y}, distance \\ 1) do
    x = x + 1
    y = y + 1
    [x1, y1, x2, y2] = boundary(x - distance, y - distance, x + distance, y + distance)
    m = Enum.chunk(ma, @width)
    Enum.map(Enum.slice(m, x1..x2), fn(row) -> Enum.slice(row, y1..y2) end)
  end

  def print_map(m, w \\ @width) do
    flat_map = Enum.with_index(List.flatten(m))
    Enum.each(flat_map, fn({c, i}) -> print_cell({c, rem(i + 1, w)}); end)
    m
  end

  def update_map(m), do: m |> flow_water

  def has_potential_water(m, elem) do
    {elev, _} = elem(List.to_tuple(m), elem)
    m
    |> neighbors(elem_to_xy(elem))
    |> List.flatten()
    |> Enum.filter(fn({lev, _}) -> lev >= elev end)
    |> Enum.map(fn(c) -> elem(c, 1) end)
    |> Enum.reduce(false, fn(c, acc) -> acc || c end)
  end

  def flow_water(m) do
    Enum.map Enum.with_index(m), fn({{elev, has_water}, i}) ->
      {elev, has_water || has_potential_water(m, i)}
    end
  end

  defp print_cell({{c, false}, 0}), do: IO.puts(c)
  defp print_cell({{c, false}, _}), do: IO.write(c)
  defp print_cell({{c, true},  0}), do: IO.puts("#{IO.ANSI.blue}#{c}#{IO.ANSI.reset}")
  defp print_cell({{c, true},  _}), do: IO.write("#{IO.ANSI.blue}#{c}#{IO.ANSI.reset}")

  def add_water(m, elem) do
    {elev, _} = hd(Enum.slice(m, elem..elem))
    Enum.slice(m, 0..elem-1) ++ [{elev, true}] ++ Enum.slice(m, elem+1..length(m))
  end

  def add_random_water(m), do: add_water(m, :random.uniform(@width * @height))

  def create_elevations([_ | rest]), do: elevation() ++ create_elevations(rest)
  def create_elevations([]),         do: []

  defp elevation, do: [{:random.uniform(5), false}]

  def build_map,                                  do: build_map([])
  defp build_map(m) when length(m) == @width * @height, do: m
  defp build_map(m) when length(m) < @width * @height,  do: build_map(m ++ [nil])

  defp boundary(x, max), do: Enum.min([Enum.max([x, 0]), max])
  defp boundary(x1, y1, x2, y2) do
    [boundary(x1, @width), boundary(y1, @height), boundary(x2, @width), boundary(y2, @height)]
  end
end
