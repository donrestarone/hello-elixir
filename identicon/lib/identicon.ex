require IEx
defmodule Identicon do
  alias Identicon.Image
  @moduledoc """
  When given a string, Identicon generates random images for default profile images.
  """

  @doc """
  accepts a string as an argument and returns a struct of 16 numbers unique to that string
  ## Examples
      iex> Identicon.main("email")
      %Identicon.Image{
        hex: [12, 131, 245, 124, 120, 106, 11, 74, 57, 239, 171, 35, 115, 28, 126,
        188]
      }
  """
  def main(input) do
    input
    |> hash_input
    |> set_rgb_colors
    |> build_grid
    |> filter_odd_numbers
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end
  @doc """ 
    when an image binary is passed, saves it to disk with the png file extension
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """ 
    when an image struct is passed, generates an image
  """
  def draw_image(%Identicon.Image{color: [r,g,b], pixel_map: pixel_map}) do 
    image = :egd.create(250, 250)
    fill = :egd.color({r,g,b})

    Enum.each pixel_map, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill)
    end
    :egd.render(image)
  end

  @doc """ 
    when an image struct is passed, builds a map of pixel distances that need to be drawn in
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image_struct) do
    pixel_map = Enum.map grid, fn({_hex, index}) -> 
      horizontal_distance = rem(index, 5) * 50
      vertical_distance = div(index, 5) * 50
      
      top_left = {horizontal_distance, vertical_distance}
      bottom_right = {horizontal_distance + 50, vertical_distance + 50}

      {top_left, bottom_right}
    end
    %Identicon.Image{image_struct | pixel_map: pixel_map}
  end

  @doc """ 
    when an image struct is passed, filters out the odd numbers from the grid
  """
  def filter_odd_numbers(%Identicon.Image{grid: grid} = image_struct) do
    even_numbers = Enum.filter grid, fn({hex, _index}) -> 
      rem(hex, 2) == 0
    end
    %Identicon.Image{ image_struct |grid: even_numbers}
  end

  @doc """ 
    when a list of numbers are passed,  an array of arrays (mirrored list of numbers) is returned 
  """
  def build_grid(%Identicon.Image{hex: list} = image_struct) do 
    grid = list
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row_of_numbers/1)
    |> List.flatten
    |> Enum.with_index
  
    %Identicon.Image{image_struct | grid: grid} 
  end

  @doc """
    when a list of three numbers are passed, the first two elements are mirrored onto the end of the list
  ## Examples
      iex> Identicon.mirror_row_of_numbers([1,2,3])
      [1, 2, 3, 2, 1]
  """
  def mirror_row_of_numbers( [first, second, _third] = row) do
    row ++ [second, first]
  end

  @doc """
  when an image struct is passed the color property is set to a list of 3 rgb values
  """
  def set_rgb_colors( %Identicon.Image{hex: [r, g, b | _the_rest]} = image_struct) do
    %Identicon.Image{image_struct | color: [r, g, b]}
  end

  @doc """
  accepts a string as an argument and returns a struct of 16 numbers unique to that string
  ## Examples
      iex> Identicon.hash_input("email")
      %Identicon.Image{
        hex: [12, 131, 245, 124, 120, 106, 11, 74, 57, 239, 171, 35, 115, 28, 126,
        188]
      }
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list
    %Image{hex: hex}
  end
end
