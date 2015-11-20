defmodule Landscape do
  @width 50
  @height 15

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
    Enum.each(map_w_index, fn({c, i}) -> print_cell(c, eol(i)); end)
    m
  end

  defp print_cell({c, false}, true), do: IO.puts(c)
  defp print_cell({c, false}, _),    do: IO.write(c)
  defp print_cell({c, true},  true), do: IO.puts("#{IO.ANSI.blue}#{c}#{IO.ANSI.reset}")
  defp print_cell({c, true},  _),    do: IO.write("#{IO.ANSI.blue}#{c}#{IO.ANSI.reset}")

  # Progression
  def should_have_water(m, elem) do
    m = List.to_tuple(m)
    neighbors(elem)
    |> Enum.map(fn(e) -> elem(m, e) end)
    |> Enum.filter(fn({lev, _}) -> lev >= get_elevation(m, elem) end)
    |> Enum.map(fn(c) -> elem(c, 1) end)
    |> Enum.reduce(false, fn(c, acc) -> acc || c end)
  end

  def flow_water(m) do
    Enum.map Enum.with_index(m), fn({{elev, has_water}, i}) ->
      {elev, has_water || should_have_water(m, i)}
    end
  end

  def update_map(m), do: m |> flow_water
  defp get_elevation(m, elem), do: elem(elem(m, elem), 0)

  # Generation
  def add_water(m), do: add_water(m, :random.uniform(@width * @height))
  def add_water(m, elem) do
    {elev, _} = hd(Enum.slice(m, elem..elem))
    Enum.slice(m, 0..elem-1) ++ [{elev, true}] ++ Enum.slice(m, elem+1..length(m))
  end

  def build_map,                                  do: build_map([])
  defp build_map(m) when length(m) == @width * @height, do: m
  defp build_map(m) when length(m) < @width * @height,  do: build_map(m ++ elevation())

  defp elevation, do: [{:random.uniform(5), false}]
end
