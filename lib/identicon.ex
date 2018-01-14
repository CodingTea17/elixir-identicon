defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  def build_pixel_map(%Identicon.Image{ grid: grid } = image) do
    Enum.map grid, fn({ _code, index }) ->
      horizon = rem(index, 5) * 50
      vert = div(index, 5) * 50

      top_left = { horizon, vert }
      bottom_right = { horizon + 50, vert + 50 }
      { top_left, bottom_right }
    end
  end
  
  def filter_odd_squares(%Identicon.Image{ grid: grid} = image) do
    Enum.filter grid, fn({ code, _index }) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{ image | grid: grid }
  end

  # Pattern match r, g, b from image as it is recieved as input to the method. Weird. 
  def pick_color(%Identicon.Image{ hex:  [r, g, b | _tail ] } = image) do
    # REBUILD THE STRUCT AND ADD A TUPLE OF COLORS (R, G, B)
    %Identicon.Image{ image | colors: { r, g, b } }
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end 
  
  def build_grid(%Identicon.Image{ hex: hex } = image) do
    grid = 
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{ image | grid: grid }
  end

  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end
  
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello
      :world

  """
  def hello do
    :world
  end
end
