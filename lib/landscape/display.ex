defmodule Landscape.Display do
  require Landscape.Position
  @width 50
  @height 15

  @water  "#{IO.ANSI.blue_background}#{IO.ANSI.black}"
  @dirt   "#{IO.ANSI.magenta_background}#{IO.ANSI.black}"
  @grass  "#{IO.ANSI.green_background}#{IO.ANSI.black}"
  @flower "#{IO.ANSI.green_background}#{IO.ANSI.yellow}"
  @reset  IO.ANSI.reset

  def print_map(m) do
    map_w_index = Enum.with_index(m)
    Enum.each(map_w_index, fn({c, i}) -> print_cell(c, Landscape.Position.eol(i)) end)
    m
  end

  defp print_cell({c, false, 0}, is_eol), do: smart_put("#{@dirt}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 1}, is_eol), do: smart_put("#{@grass}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 2}, is_eol), do: smart_put("#{@flower}#{c}#{@reset}", is_eol)
  defp print_cell({c, true, _},  is_eol), do: smart_put("#{@water}#{c}#{@reset}", is_eol)

  defp smart_put(str, true), do: IO.puts(str)
  defp smart_put(str, _),    do: IO.write(str)

end
