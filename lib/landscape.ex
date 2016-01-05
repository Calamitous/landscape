defmodule Landscape do
  def start(:normal, _) do
    # IO.inspect(:lists.keyfind(:encoding, 1, :io.getopts())) # yup, unicode
    c = Calendar.start
    i = Interface.start
    l = Landscape.make
    Supervisor.start_link [], strategy: :one_for_one
  end

  def make() do
    Landscape.build_map(1, 15)
    |> Landscape.add_water
    # |> add_calendar
    |> Landscape.Display.print_map
    |> Landscape.update
  end

  def update(world), do: world |> Landscape.Water.flow

  # Generation
  def add_water({w, h, m}), do: add_water({w, h, m}, :random.uniform(w * h))
  def add_water({w, h, m}, ele) do
    {elev, _, grass} = hd(Enum.slice(m, ele..ele))
    {w, h, Enum.slice(m, 0..ele-1) ++ [{elev, true, grass}] ++ Enum.slice(m, ele+1..length(m))}
  end

  def build_map(w, h),                               do: build_map({w, h, []})
  defp build_map({w, h, m}) when length(m) == w * h, do: {w, h, m}
  defp build_map({w, h, m}) when length(m) < w * h,  do: build_map({w, h, m ++ elevation()})

  defp elevation, do: [{:random.uniform(3) - 1, false, :random.uniform(3) - 1}]
end
