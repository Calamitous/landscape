defmodule Landscape do
  @width 50
  @height 15

  @water  "#{IO.ANSI.blue_background}#{IO.ANSI.black}"
  @dirt   "#{IO.ANSI.magenta_background}#{IO.ANSI.black}"
  @grass  "#{IO.ANSI.green_background}#{IO.ANSI.black}"
  @flower "#{IO.ANSI.green_background}#{IO.ANSI.yellow}"
  @reset  IO.ANSI.reset

  # Position
  defmacro top(elem), do: quote do: @width > unquote(elem)
  defmacro bot(elem), do: quote do: @height <= (div(unquote(elem), @width) + 1)
  defmacro bol(elem), do: quote do: rem(unquote(elem), @width) == 0
  defmacro eol(elem), do: quote do: rem(unquote(elem) + 1, @width) == 0

  def elem_to_xy(elem),   do: {div(elem, @width), rem(elem, @width)}
  def xy_to_elem({x, y}), do: (@width * y) + x

  def neighbor(elem, :n)  when not top(elem),                   do: elem - @width
  def neighbor(elem, :e)  when not eol(elem),                   do: elem + 1
  def neighbor(elem, :s)  when not bot(elem),                   do: elem + @width
  def neighbor(elem, :w)  when not bol(elem),                   do: elem - 1
  def neighbor(elem, :ne) when not top(elem) and not eol(elem), do: (elem - @width) + 1
  def neighbor(elem, :se) when not bot(elem) and not eol(elem), do: elem + @width + 1
  def neighbor(elem, :sw) when not bot(elem) and not bol(elem), do: (elem + @width) - 1
  def neighbor(elem, :nw) when not top(elem) and not bol(elem), do: elem - 1 - @width
  def neighbor(elem, _), do: elem

  def neighbors(elem),                               do: neighbors(elem, [:n, :ne, :e, :se, :s, :sw, :w, :nw], [])
  def neighbors(elem, [direction | tail], elements), do: neighbors(elem, tail, [neighbor(elem, direction)| elements])
  def neighbors(elem, [], elements),                 do: Enum.uniq(elements) -- [elem]

  # Display
  def print_map(m) do
    map_w_index = Enum.with_index(m)
    Enum.each(map_w_index, fn({c, i}) -> print_cell(c, eol(i)) end)
    m
  end

  defp print_cell({c, false, 0}, is_eol), do: smart_put("#{@dirt}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 1}, is_eol), do: smart_put("#{@grass}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 2}, is_eol), do: smart_put("#{@flower}#{c}#{@reset}", is_eol)
  defp print_cell({c, true, _},  is_eol), do: smart_put("#{@water}#{c}#{@reset}", is_eol)

  defp smart_put(str, true), do: IO.puts(str)
  defp smart_put(str, _),    do: IO.write(str)

  # Progression
  def should_have_water(m, elem) do
    m = List.to_tuple(m)
    neighbors(elem)
    |> Enum.map(fn(e) -> elem(m, e) end)
    |> Enum.filter(fn({lev, _, _}) -> lev >= get_elevation(m, elem) end)
    |> Enum.map(fn(c) -> elem(c, 1) end)
    |> Enum.reduce(false, fn(c, acc) -> acc || c end)
  end

  def flow_water(m) do
    Enum.map Enum.with_index(m), fn({{elev, has_water, grass}, i}) ->
      {elev, has_water || should_have_water(m, i), grass}
    end
  end

  def update_map(m), do: m |> flow_water
  defp get_elevation(m, elem), do: elem(elem(m, elem), 0)

  # Generation
  def add_water(m), do: add_water(m, :random.uniform(@width * @height))
  def add_water(m, elem) do
    {elev, _, grass} = hd(Enum.slice(m, elem..elem))
    Enum.slice(m, 0..elem-1) ++ [{elev, true, grass}] ++ Enum.slice(m, elem+1..length(m))
  end

  def build_map,                                  do: build_map([])
  defp build_map(m) when length(m) == @width * @height, do: m
  defp build_map(m) when length(m) < @width * @height,  do: build_map(m ++ elevation())

  defp elevation, do: [{:random.uniform(3) - 1, false, :random.uniform(3) - 1}]
end
