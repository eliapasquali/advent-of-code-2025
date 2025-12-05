defmodule Day01 do
  def parse(input) do
    {ranges, ids} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split_while(fn x -> String.contains?(x, "-") end)

    {ranges, Enum.map(ids, &String.to_integer/1)}
  end

  def part1(input) do
    {ranges_str, ids} = input |> parse()

    # Did with lists... my ram was not enough... :(

    ranges =
      Enum.map(ranges_str, fn range ->
        [lb, ub] = String.split(range, "-", trim: true)
        String.to_integer(lb)..String.to_integer(ub)
      end)

    valid_ids =
      ids
      |> Enum.filter(fn id ->
        Enum.any?(ranges, fn range -> id in range end)
      end)

    fresh_element = length(valid_ids)

    IO.puts("The number fresh ingredients IDs available is #{fresh_element}")
  end

  def part2(input) do
    {ranges_str, _ids} = input |> parse()

    ranges_int =
      ranges_str
      |> Enum.map(fn range -> String.split(range, "-", trim: true) end)
      |> Enum.map(fn [lb, ub] ->
        {String.to_integer(lb), String.to_integer(ub)}
      end)

    merged_ranges =
      ranges_int
      |> Enum.sort_by(fn {lb, _ub} -> lb end)
      # Merge overlapping ranges and create a list of them
      # first arg starting accumulator
      |> Enum.reduce([], fn {lb, ub}, acc ->
        case acc do
          # add the first range
          [] ->
            [{lb, ub}]

          [{prev_lb, prev_ub} | xs] ->
            if lb <= prev_ub do
              # overlapping
              # because they are sorted no problem with the ub
              # if no overlapping with immediately previous then 
              # no also for all the previous
              # "add" the two ranges so that overlap is inside
              # xs is the rest of the list without the previous range
              # !!! THANKS REDDIT FOR THE EXTRA EXAMPLE CASE !!!
              [{prev_lb, max(ub, prev_ub)} | xs]
            else
              # no overlap
              # there is a space between previous range and current one
              # just add it to the list that reduce is accumulating
              [{lb, ub} | acc]
            end
        end

        # the list of ranges is then reverse, but not a problem for the goal
      end)

    total_fresh_ids =
      merged_ranges
      |> Enum.map(fn {lb, ub} -> lb..ub end)
      |> Enum.map(&Range.size/1)
      |> Enum.sum()

    IO.puts("The number of IDs considered fresh is #{total_fresh_ids}")
  end
end

input_file = File.read!("input.txt")
example = File.read!("example.txt")

Day01.part1(example)
Day01.part1(input_file)
Day01.part2(example)
Day01.part2(input_file)
