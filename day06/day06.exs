defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)

    #    |> Enum.map(fn row -> String.split(row, " ", trim: true) end)
  end

  def part1(input) do
    splitted_elements =
      input
      |> parse()
      |> Enum.map(fn row -> String.split(row, " ", trim: true) end)

    transposed_matrix =
      splitted_elements
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    calculations =
      transposed_matrix
      |> Enum.map(fn row ->
        # split last from list 
        {operator, operands_str} = List.pop_at(row, -1)

        # string operands to intgers
        operands_int = Enum.map(operands_str, &String.to_integer/1)

        case operator do
          # didn't read which operators are in the input, only +, *
          "+" ->
            operands_int |> Enum.reduce(&Kernel.+/2)

          "*" ->
            operands_int |> Enum.reduce(&Kernel.*/2)
        end
      end)

    grand_total = Enum.sum(calculations)

    #    IO.inspect(splitted_elements, charlists: false, label: "Split")
    #    IO.inspect(transposed_matrix, charlists: false, label: "Transpose")
    #    IO.inspect(calculations, charlists: false, label: "Calculations")

    IO.puts("The grand total is #{grand_total}")
  end

  def part2(input) do
    splitted_elements =
      input
      |> parse()
      |> Enum.map(&String.graphemes/1)

    cephalopod_math_order =
      splitted_elements
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.reverse()

    split_columns =
      cephalopod_math_order
      # |> Enum.map(&List.to_string/1)
      |> Enum.chunk_by(fn row -> Enum.all?(row, fn x -> x == " " end) end)
      # now list of [ [valid lists], [empty], [valid] ... ]
      |> Enum.reject(fn chunk -> length(chunk) == 1 end)
      |> Enum.split_while(fn list ->
        List.last(list) in ["+", "*", " "]
      end)
      # discard first tuple from split_while
      |> elem(1)

    # now list of lists
    # [ [ digits where last list have as last element the operator] ]

    operations =
      split_columns
      |> Enum.map(fn row ->
        row
        |> Enum.map(fn list ->
          # split operator (or space) from digits
          {op, digits} = List.pop_at(list, -1)
          num_str = List.to_string(digits)
          [op] ++ [num_str]
        end)
        # [ {space and operator} , { numbers }
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        # just a way to fix the data
        |> List.to_tuple()
      end)
      |> Enum.map(fn {op_list, num_list} ->
        op =
          op_list
          |> List.to_string()
          |> String.trim()

        nums =
          num_list
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.to_integer/1)

        {op, nums}
      end)

    calculations =
      operations
      |> Enum.map(fn {operator, numbers} ->
        case operator do
          "+" -> numbers |> Enum.reduce(&Kernel.+/2)
          "*" -> numbers |> Enum.reduce(&Kernel.*/2)
        end
      end)

    grand_total = Enum.sum(calculations)

    IO.puts("The grand total following cephalopod math order is #{grand_total}")
  end
end

input_file = File.read!("input.txt")
example = File.read!("example.txt")

Day01.part1(example)
Day01.part1(input_file)
Day01.part2(example)
Day01.part2(input_file)
