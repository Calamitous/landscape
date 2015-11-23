defmodule Landscape.Position do
  @width 50
  @height 15

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
end
