defmodule Day01 do
  @moduledoc """
  Documentation for Day01.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day01.hello()
      :world

  """
  defp readFile(fileName) do
    {:ok, file} = File.read(fileName)
    file |> String.split("\n", trim: true)
    |> Enum.map(&Integer.parse/1)
  end

  def calculateFuel(0, result) do
    result
  end

  def calculateFuel(weight, result) do
    fuelConsumption = max(Float.floor(weight / 3) - 2, 0)
    IO.puts "#{fuelConsumption} #{weight}"
    calculateFuel(fuelConsumption, result + fuelConsumption)
  end

  def calculateFuelPart1({weight, _}) do
    Float.floor(weight / 3) - 2
  end

  def calculateFuelPart2({weight, _}) do
    calculateFuel(weight, 0)
  end

  def part1(fileName) do
    readFile(fileName)
    |> Enum.map(&Day01.calculateFuelPart1/1)
    |> Enum.sum
  end

  def part2(fileName) do
    readFile(fileName)
    |> Enum.map(&Day01.calculateFuelPart2/1)
    |> Enum.sum
  end
end
