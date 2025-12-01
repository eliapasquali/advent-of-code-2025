defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
        # pattern match over type of move
        "L" <> clicks -> {:L, String.to_integer(clicks)}
        "R" <> clicks -> {:R, String.to_integer(clicks)}
    end)
  end

  def part1(input) do
    moves = parse(input)
    # Dial start at position 50, accumulate movement
    {_final_dial, total_zeroes} = Enum.reduce(
      moves, # elements to check
      {50, 0}, # {dial_position, number of exact zero}, accumulator starting value
      fn ({dir, val}, {dial, count}) -> # (iteration value, accumulator)

        new_dial = case dir do
          :L -> Integer.mod(dial - val, 100) # module to mimick dial movement
          :R -> Integer.mod(dial + val, 100)
        end

      new_count = if new_dial == 0 do count + 1 else count end

      {new_dial, new_count} #return accumulator
    end)

    IO.puts("Day 1 - Part 1")
    IO.puts("The dial reached zero #{total_zeroes} times")
  end

  def part2(input) do
    moves = parse(input)
    # Dial start at position 50, accumulate movement
    {_final_dial, total_exact, total_inter} = Enum.reduce(
      moves, # elements to check
      {50, 0, 0}, # {dial_position, exact_count, inter_count}, accumulator
      fn ({dir, val}, {dial, exact_count, inter_count}) -> # (iteration value, accumulator)

        new_dial = case dir do
          :L -> Integer.mod(dial - val, 100) # module to mimick dial movement
          :R -> Integer.mod(dial + val, 100)
        end

        new_exact = if new_dial == 0, do: exact_count + 1, else: exact_count

        round_inter = case dir do
         :L ->
            full_cycles = div(val, 100)
            missing_clicks = rem(val, 100)
          # Going left : if missing > dial => pass 0
          # !!! If starting from 0 do not add a visit to it
            last_rotation = if missing_clicks > dial and dial != 0 do
              full_cycles + 1 else full_cycles end
            last_rotation
        :R ->
          full_cycles = div(val, 100)
          missing_clicks = rem(val, 100)
          # Going right: if dial + missing > 100 => pass 0
          last_rotation = if dial + missing_clicks > 100 do
            full_cycles + 1 else full_cycles end
          last_rotation
        end

        new_inter = inter_count + round_inter

        {new_dial, new_exact, new_inter}
      end)

      IO.puts("Day 1 - Part 2")
      IO.puts("The dial was exactly on zero #{total_exact} times,")
      IO.puts("passed on it #{total_inter} times,")
      IO.puts("for a cumulative total #{total_exact+total_inter} number of times")
    end
  end


input_file = File.read!("input.txt")
#p2_example = File.read!("example_p2.txt")

Day01.part1(input_file)
#Day01.part2(p2_example)
Day01.part2(input_file)
