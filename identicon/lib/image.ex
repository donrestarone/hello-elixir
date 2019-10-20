defmodule Identicon.Image do
  @moduledoc """
    a simple struct which takes a list of 16 hexidecimal values, 3 rgb colors, a grid & pixel map
  """

  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
