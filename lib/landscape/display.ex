defmodule Landscape.Display do
  require Landscape.Position

  @reset  IO.ANSI.reset

  def lava(_),         do: "#{IO.ANSI.red_background}#{IO.ANSI.black}"
  def hole(_),         do: "#{IO.ANSI.black_background}#{IO.ANSI.white}"

  def water(:winter),  do: "#{IO.ANSI.cyan_background}#{IO.ANSI.black}"
  def water(_),        do: "#{IO.ANSI.blue_background}#{IO.ANSI.black}"

  def dirt(:winter),   do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def dirt(_),         do: "#{IO.ANSI.magenta_background}#{IO.ANSI.black}"

  def grass(:fall),    do: "#{IO.ANSI.yellow_background}#{IO.ANSI.black}"
  def grass(:winter),  do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def grass(_),        do: "#{IO.ANSI.green_background}#{IO.ANSI.black}"

  def flower(:winter), do: "#{IO.ANSI.white_background}#{IO.ANSI.black}#{IO.ANSI.faint}"
  def flower(_),       do: "#{IO.ANSI.green_background}#{IO.ANSI.yellow}"

  def print_map({{w, h, m}, date}) do
    map_w_index = Enum.with_index(m)
    Enum.each(map_w_index, fn({c, i}) -> print_cell(c, date, Landscape.Position.eol(w, h, i)) end)
    IO.puts Calendar.date_format(date)
    {{w, h, m}, date}
  end

  defp print_cell({c, false, 0}, {_, season, _}, is_eol), do: smart_put("#{dirt(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 1}, {_, season, _}, is_eol), do: smart_put("#{grass(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 2}, {_, season, _}, is_eol), do: smart_put("#{flower(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, true, _},  {_, season, _}, is_eol), do: smart_put("#{water(season)}#{c}#{@reset}", is_eol)

  defp smart_put(str, true), do: IO.puts(str)
  defp smart_put(str, _),    do: IO.write(str)
end
