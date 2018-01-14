defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
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
    hex
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
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
