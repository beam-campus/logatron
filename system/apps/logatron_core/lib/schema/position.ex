defmodule Logatron.Schema.Position do
  defstruct x: 0, y: 0

  def random(x, y)
      when is_integer(x) and
             is_integer(y) and
             x > 0 and
             y > 0 do
    %Logatron.Schema.Position{
      x: :rand.uniform(x),
      y: :rand.uniform(y)
    }
  end
end
