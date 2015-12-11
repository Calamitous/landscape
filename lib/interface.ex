defmodule Interface do
  def bootstrap do
    :encurses.initscr
    :encurses.refresh
    :encurses.getch

  end


end
