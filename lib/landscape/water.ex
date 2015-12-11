defmodule Landscape.Water do
  # Water doesn't flow in the winter!
  def flow({{w, h, m}, {d, :winter, y}}), do: {{w, h, m}, {d, :winter, y}}

  def flow({{w, h, m}, date}) do
    {{w, h, Enum.map(Enum.with_index(m), fn({{elev, has_water, grass}, i}) ->
      {elev, has_water || should_have_water({w, h, m}, i), grass}
    end)}, date}
  end

  defp should_have_water({w, h, m}, elem) do
    m = List.to_tuple(m)
    Landscape.Position.neighbors(w, h, elem)
    |> Enum.map(fn(e) -> elem(m, e) end)
    |> Enum.filter(fn({lev, _, _}) -> lev >= get_elevation(m, elem) end)
    |> Enum.map(fn(c) -> elem(c, 1) end)
    |> Enum.reduce(false, fn(c, acc) -> acc || c end)
  end

  defp get_elevation(m, elem), do: elem(elem(m, elem), 0)
end
