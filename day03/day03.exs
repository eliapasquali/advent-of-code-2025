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

#    IO.inspect(idx_banks, label: "Indexed banks with bank index")

    # Generate list [ { list of [all_pairs] , bank_number }]
    valid_pairs_per_bank =
      idx_banks
        # For each indexed bank { [], bank_number}
        |> Enum.map(fn {idx_digits, _idx} ->
          idx_digits # [ list of {val, idx} ]
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

#    IO.inspect(valid_pairs_per_bank, label: "List of lists of valid pairs (one list per bank)")


    # From all valid pairs, compare values and take max
    max_per_bank =
      valid_pairs_per_bank
      |> Enum.map(fn bank_pairs ->
        # for each bank list, create list of numbers
        bank_pairs
        # evaluate each pair
        |> Enum.map(fn {tens, unit} -> tens*10 + unit end)
        # get max
        |> Enum.max()
      end)

#    IO.inspect(max_per_bank, label: "List of max per bank", charlists: false)

    total = max_per_bank |> Enum.sum()
    IO.puts("The sum of all max pairs is #{total}")
  end

  #def part2(input) do
  #end
end

input_file = File.read!("input.txt")
#p1_example = File.read!("example_p1.txt")
# p2_example = File.read!("example_p2.txt")

#Day01.part1(p1_example)
Day01.part1(input_file)
# Day01.part2(p2_example)
# Day01.part2(input_file)
