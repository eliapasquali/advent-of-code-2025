defmodule Day01 do
  def parse(input) do
    input |> String.split("\n", trim: true)
  end

  def part1(input) do
    banks = input |> parse()
    # Generate list [ { list of [idx_digits] , bank_number} ]
    idx_banks =
      banks
      |> Enum.map(fn bank ->
        # Single bank from input
        bank
        # split string in its digits
        |> String.graphemes()
        # get the int value
        |> Enum.map(&String.to_integer/1)
        # create tuples {val, idx}
        |> Enum.with_index()
      end)
      # Index list over banks
      |> Enum.with_index()

    # Generate list [ { list of [all_pairs] , bank_number }]
    valid_pairs_per_bank =
      idx_banks
      # For each indexed bank { [], bank_number}
      |> Enum.map(fn {idx_digits, _idx} ->
        # [ list of {val, idx} ]
        idx_digits
        |> Enum.map(fn {val1, idx1} ->
          # for each digit in the bank
          # filter all the previous digits (invalid)
          idx_digits
          |> Enum.filter(fn {_val2, idx2} -> idx2 > idx1 end)
          # from filtered (=substring) return valid pairs
          |> Enum.map(fn {val2, _idx2} -> {val1, val2} end)
        end)
        # Here we have list of lists, reduce it to single one
        |> List.flatten()

        # So now it is just a list of all valid pairs for the bank
        # the bank index (idx) is the index of the list of pairs in the list
      end)

    # From all valid pairs, compare values and take max
    max_per_bank =
      valid_pairs_per_bank
      |> Enum.map(fn bank_pairs ->
        # for each bank list, create list of numbers
        bank_pairs
        # evaluate each pair
        |> Enum.map(fn {tens, unit} -> tens * 10 + unit end)
        # get max
        |> Enum.max()
      end)

    total = max_per_bank |> Enum.sum()
    IO.puts("The sum of all max pairs is #{total}")
  end

  def part2(input) do
    banks = input |> parse()

    # Thanks to a visualization on reddit

    joultages_per_bank =
      banks
      |> Enum.map(fn bank ->
        bank
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)
      end)

    # All have the same length
    high_batteries_joultages =
      joultages_per_bank
      |> Enum.map(fn bank ->
        # Sliding windows
        # From the left => choose max from len-(12-selected)
        # map_reduce(iteration, initial accumulator, function, )
        Enum.map_reduce(1..12, bank, fn missing_digits, bank_rest ->
          window_len = length(bank_rest) - (12 - missing_digits)
          window = Enum.take(bank_rest, window_len)
          window_max = Enum.max(window)

          # split_while => { pre_max, [max (included) :: end]}
          {_before, after_included} =
            Enum.split_while(bank_rest, fn x ->
              x != window_max
            end)

          remaining_bank = Enum.drop(after_included, 1)

          # return digit picked and rest of bank as a tuple
          {window_max, remaining_bank}
        end)
      end)
      |> Enum.map(fn {high, _rem} -> high end)

    # list of list of digits
    total_joultage =
      high_batteries_joultages
      # list of string with the joultage value
      |> Enum.map(&Enum.join/1)
      # list of joultages
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    IO.puts("The total joultage by using 12 batteries per bank is #{total_joultage}")
  end
end

input_file = File.read!("input.txt")
# p1_example = File.read!("example_p1.txt")
# p2_example = File.read!("example_p2.txt")

# Day01.part1(p1_example)
Day01.part1(input_file)
# Day01.part2(p2_example)
Day01.part2(input_file)
