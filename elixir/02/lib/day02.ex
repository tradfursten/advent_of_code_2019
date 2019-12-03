defmodule Day02 do
  @moduledoc """
  Documentation for Day02.
  """

  def run() do

  end

  def part1(filename) do
    {:ok, body } = File.read(filename)
    registers = body
    |> String.split(",", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.unzip
    |> elem(0)
  end
end
