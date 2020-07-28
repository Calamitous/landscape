defmodule C do
  def start do
    cmd = '/home/eric/Projects/landscape/hic.sh'
    port = Port.open({:spawn, cmd}, [:binary])
    Port.command(port, '')
    receive do
      {^port, {:data, result}} ->
      IO.puts("Elixir got: #{inspect result}")
    end
  end
end

C.start
