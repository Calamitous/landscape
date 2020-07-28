defmodule Interface do
  def start do
    :application.start(:cecho)
    :cecho.noecho

    # May need to change this to :cecho.raw to capture control characters
    :cecho.cbreak

    # Capture non-ASCII keys
    :cecho.keypad(0, true)

    keyloop
  end

  def keyloop, do: handle_key :cecho.getch
  def advance, do: Landscape.Display.print_map

  def handle_key(?d) do
    :cecho.refresh
    keyloop
  end

  def handle_key(?q) do
    :cecho.curs_set(1)
    :cecho.delwin(0)
    :application.stop(:cecho)
  end
end
