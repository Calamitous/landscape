defmodule Landscape.Display do
  require Landscape.Position

  @reset  IO.ANSI.reset

  def bol,             do: IO.ANSI.Cursor.cursor_to_column(1)

  def lava(_),         do: "#{IO.ANSI.red_background}#{IO.ANSI.black}"
  def hole(_),         do: "#{IO.ANSI.black_background}#{IO.ANSI.white}"

  def water(:winter),  do: "#{IO.ANSI.cyan_background}#{IO.ANSI.black}"
  def water(_),        do: "#{IO.ANSI.color_background(1, 1, 5)}#{IO.ANSI.black}"

  def dirt(:winter),   do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def dirt(_),         do: "#{IO.ANSI.color_background(1, 1, 0)}"

  def grass(:fall),    do: [IO.ANSI.yellow_background, IO.ANSI.black]
  def grass(:winter),  do: "#{IO.ANSI.white_background}#{IO.ANSI.black}"
  def grass(_),        do: "#{IO.ANSI.green_background}#{IO.ANSI.black}"

  def flower(:winter), do: "#{IO.ANSI.white_background}#{IO.ANSI.black}#{IO.ANSI.faint}"
  def flower(_),       do: "#{IO.ANSI.green_background}#{IO.ANSI.yellow}"

  def topleft(h),      do: IO.ANSI.Cursor.cursor_to(1, h)

  def print_map({{w, h, m}, date}) do
    IO.puts topleft(h)
    # if date != {1, :spring, 1, 8, 0, :pause}, do: :cecho.move(0, 0)
    m
    |> Enum.with_index
    |> Enum.each(fn({c, i}) -> print_cell(c, date, Landscape.Position.eol(w, h, i)) end)

    IO.puts bol <> Calendar.date_format(date)
    {{w, h, m}, date}
  end

  defp print_cell({c, false, 0}, {_, season, _, _, _, _}, is_eol), do: smart_put("#{IO.ANSI.Cursor.cursor_up}#{dirt(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 1}, {_, season, _, _, _, _}, is_eol), do: smart_put("#{IO.ANSI.Cursor.cursor_up}#{grass(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, false, 2}, {_, season, _, _, _, _}, is_eol), do: smart_put("#{IO.ANSI.Cursor.cursor_up}#{flower(season)}#{c}#{@reset}", is_eol)
  defp print_cell({c, true, _},  {_, season, _, _, _, _}, is_eol), do: smart_put("#{IO.ANSI.Cursor.cursor_up}#{water(season)}#{c}#{@reset}", is_eol)

  defp smart_put(str, true), do: IO.puts(str)
  defp smart_put(str, _),    do: IO.write(str)
end
