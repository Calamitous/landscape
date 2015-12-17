defmodule Interface do
  def bootstrap do
    :application.start(:cecho)
    :cecho.noecho

    # May need to change this to :cecho.raw to capture control characters
    :cecho.cbreak

    # Capture non-ASCII keys
    :cecho.keypad(0, true)

    :cecho.move(1, 1)

    color_flag = :cecho.has_colors

    # Hide the cursor
    :cecho.curs_set(0)
    {y, x, cy, cx} = size

    # Make winders
    top    = :cecho.newwin cy-1, x-1, 1, 1
    bottom = :cecho.newwin cy-1, x-1, cy, 1
    wins = {top, bottom}

    :cecho.refresh
    keyloop(wins)
  end

  def size() do
    :cecho.getmaxyx()
    |> center_of
  end

  def center_of({y, x}), do: {y, x, div(y, 2), div(x, 2)}

  def keyloop(wins), do: handle_key :cecho.getch, wins

  def handle_key(?b, {top, bot}) do
    :cecho.border(0, 0, 0, 0, 0, 0, 0, 0)
    :cecho.wborder(top, 0, 0, 0, 0, 0, 0, 0, 0)
    :cecho.wborder(bot, 0, 0, 0, 0, 0, 0, 0, 0)
    :cecho.wrefresh(top)
    :cecho.wrefresh(bot)
    # :cecho.refresh
    keyloop({top, bot})
  end

  def handle_key(?q, {top, bot}) do
    :cecho.curs_set(1)
    :cecho.delwin(top)
    :cecho.delwin(bot)
    :cecho.delwin(0)
    :application.stop(:cecho)
  end

  def handle_key(key, {top, bot}) do
    :cecho.wborder(top, 0, 0, 0, 0, 0, 0, 0, 0)
    :cecho.wborder(bot, 0, 0, 0, 0, 0, 0, 0, 0)
    :cecho.wmove(top, 1, 1)
    :cecho.wmove(bot, 1, 1)
    :cecho.waddch top, key
    :cecho.waddstr bot, [key]
    :cecho.wrefresh(top)
    :cecho.wrefresh(bot)
    # :cecho.refresh
    keyloop({top, bot})
  end

end
