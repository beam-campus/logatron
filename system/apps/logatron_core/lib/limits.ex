defmodule Logatron.Limits do
  require Config

  @moduledoc """
  Agrex.Limits is the module that contains the limits for the Life Subsystem
  """

  @max_age 5

  @defaults [
    ticks_per_year: 20
  ]

  def max_regions, do: 1
  def max_farms, do: 2
  def max_lives, do: 5
  def min_lives, do: 2
  def max_robots, do: 3
  def min_robots, do: 2
  def max_age, do: @max_age
  def min_age, do: 1
  def min_weight, do: 50
  def max_weight, do: 750
  def ticks_per_year, do: @defaults[:ticks_per_year]

  def random_age do
    ma = :rand.uniform(min_age())
    res = abs(:rand.uniform(max_age()) - ma)
    if res == 0, do: random_age()
    if res < ma, do: random_age()
    res
  end

  def random_weight do
    res = abs(:rand.uniform(max_weight()) - :rand.uniform(min_weight()))
    mw = min_weight()

    if res == 0, do: random_weight()
    if res < mw, do: random_weight()
    res
  end

  def random_nbr_lives do
    ml = :rand.uniform(min_lives())
    res = abs(:rand.uniform(max_lives()) - ml)

    case res do
      0 -> ml
      _ -> res
    end
  end

  def random_100 do
    :rand.uniform(100)
  end

  def random_pos(max_x, max_y, max_z \\ 1)
      when is_integer(max_x) and
             is_integer(max_y) and
             is_integer(max_z) and
             max_x > 0 and
             max_y > 0 do
    %{
      x: :rand.uniform(max_x),
      y: :rand.uniform(max_y),
      z: :rand.uniform(max_z)
    }
  end
end
