defmodule Landscape do
  require Landscape.Water

  @width 50
  @height 15

  def update(m), do: m |> Landscape.Water.flow

  # Generation
  def add_water(m), do: add_water(m, :random.uniform(@width * @height))
  def add_water(m, elem) do
    {elev, _, grass} = hd(Enum.slice(m, elem..elem))
    Enum.slice(m, 0..elem-1) ++ [{elev, true, grass}] ++ Enum.slice(m, elem+1..length(m))
  end

  def build_map,                                        do: build_map([])
  defp build_map(m) when length(m) == @width * @height, do: m
  defp build_map(m) when length(m) < @width * @height,  do: build_map(m ++ elevation())

  defp elevation, do: [{:random.uniform(3) - 1, false, :random.uniform(3) - 1}]
end
