defmodule Landscape.Position do
  defmacro top(w, _, elem), do: quote do: unquote(w) > unquote(elem)
  defmacro bot(w, h, elem), do: quote do: unquote(h) <= (div(unquote(elem), unquote(w)) + 1)
  defmacro bol(w, _, elem), do: quote do: rem(unquote(elem), unquote(w)) == 0
  defmacro eol(w, _, elem), do: quote do: rem(unquote(elem) + 1, unquote(w)) == 0

  def elem_to_xy(w, elem),   do: {div(elem, w), rem(elem, w)}
  def xy_to_elem(w, {x, y}), do: (w * y) + x

  def neighbor(w, _, elem, :n)  when not top(w, h, elem),                         do: elem - w
  def neighbor(w, h, elem, :e)  when not eol(w, h, elem),                         do: elem + 1
  def neighbor(w, h, elem, :s)  when not bot(w, h, elem),                         do: elem + w
  def neighbor(w, h, elem, :w)  when not bol(w, h, elem),                         do: elem - 1
  def neighbor(w, h, elem, :ne) when not top(w, h, elem) and not eol(w, h, elem), do: (elem - w) + 1
  def neighbor(w, h, elem, :se) when not bot(w, h, elem) and not eol(w, h, elem), do: elem + w + 1
  def neighbor(w, h, elem, :sw) when not bot(w, h, elem) and not bol(w, h, elem), do: (elem + w) - 1
  def neighbor(w, h, elem, :nw) when not top(w, h, elem) and not bol(w, h, elem), do: elem - 1 - w
  def neighbor(_, _, elem, _), do: elem

  def neighbors(w, h, elem),                               do: neighbors(w, h, elem, [:n, :ne, :e, :se, :s, :sw, :w, :nw], [])
  def neighbors(w, h, elem, [direction | tail], elements), do: neighbors(w, h, elem, tail, [neighbor(w, h, elem, direction)| elements])
  def neighbors(_, _, elem, [], elements),                 do: Enum.uniq(elements) -- [elem]
end
