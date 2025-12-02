defmodule Day01 do
  def parse(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      String.split(range, "-",trim: true)
    end)
  end

  def part1(input) do
    ranges = parse(input)

    full_ranges= Enum.map(ranges, fn range ->
      lb = String.to_integer(Enum.at(range, 0))
      ub = String.to_integer(Enum.at(range, 1))
      ids = Enum.to_list(lb .. ub)
      ids
    end)

    invalid = Enum.map(full_ranges, fn range ->
      Enum.map(range, fn val ->
        val_str = Integer.to_string(val)
        len = String.length(val_str)
        split = String.split_at(val_str, div(len, 2))
        bad = if (elem(split, 0) == elem(split, 1)) do
          val else 0 end
        bad
      end)
    end)

    total = invalid |> List.flatten() |> Enum.sum()
    IO.puts("The sum of all invalid IDs is: #{total}")
    total
  end

  def part2(input) do
    ranges = parse(input)

    full_ranges= Enum.map(ranges, fn range ->
      lb = String.to_integer(Enum.at(range, 0))
      ub = String.to_integer(Enum.at(range, 1))
      ids = Enum.to_list(lb .. ub)
      ids
    end)

    invalid = Enum.map(full_ranges, fn range ->
      Enum.filter(range, fn val ->
        val_str = Integer.to_string(val)
        Regex.run(~r"\b(\d+)\1+\b", val_str)
      end)
    end)

    total = invalid |> List.flatten() |> Enum.sum()
    IO.puts("The sum of all (old+new) invalid IDs is: #{total}")
    total
  end
end

input_file = File.read!("input.txt")
#p1_example = File.read!("example_p1.txt")
#p2_example = File.read!("example_p2.txt")

#Day01.part1(p1_example)
Day01.part1(input_file)
#Day01.part2(p2_example)
Day01.part2(input_file)
