defmodule Day02 do
  @moduledoc """
  Documentation for Day02.
  """

  def process(program, ip) do
    op = Enum.at(program, index)

    case compute(op, ip, program) do

    end


  end

  def compute(1, ip, program) do

    List.replace_at(program, program[ip+], value)

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
