defmodule Interface do
  def bootstrap do
    # :cecho.initscr

    :application.start(:cecho)
    :cecho.noecho
    :cecho.move(1, 1)

    color_flag = :cecho.has_colors

    # Hide the cursor
    :cecho.curs_set(0)

    # :cecho.addstr(color_flag)

    :cecho.refresh
    keyloop
  end

  def keyloop, do: handle_key :cecho.getch

  def handle_key(?q) do
    :cecho.curs_set(1)
    :application.stop(:cecho)
  end

  def handle_key(key) do
    :cecho.move(1, 1)
    :cecho.addch key
    # :cecho.addstr [key]
    :cecho.refresh
    keyloop
  end

end
