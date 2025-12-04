# change language because I want to use a simple 2D-array
import copy

with open("input.txt", "r") as file:
  locations = file.read().splitlines()

#print(locations)

store_matrix = []
for line in locations:
  store_matrix.append(list(line))

#print(store_matrix)

accessible_rolls_matrix = copy.deepcopy(store_matrix)

rows = len(store_matrix)
cols = len(store_matrix[0])

fix = (1, 0) # {prev_iteration, this_iteration }

while fix[0] != fix[1]:

  # if not stable => we have picked something in the last iter
  # now check new rolls from updated matrix
  store_matrix = accessible_rolls_matrix

  for row in range(rows):
    for col in range(cols):
      if store_matrix[row][col] == "@":
        up_row =  row - 1 if row - 1 >= 0 else 0
        down_row = row + 1 if row + 1 < rows else rows-1
        left_col =  col - 1 if col - 1 >= 0 else 0 
        right_col =  col + 2 if col + 2 < cols else cols 

        # print(row)
        # print(col)
        # print(up_row)
        # print(down_row)
        # print(left_col)
        # print(right_col)
        if up_row != row :
          up_neighbours = store_matrix[up_row][left_col : right_col]
        else:
          up_neighbours = []
        if down_row != row:
          down_neighbours = store_matrix[down_row][left_col : right_col]
        else:
          down_neighbours = []
        near_neighbours = store_matrix[row][left_col : right_col]

        # print(up_neighbours)
        # print(near_neighbours)
        # print(down_neighbours)

        flat_neighbours = up_neighbours + down_neighbours + near_neighbours
        neighbour_rolls_total = flat_neighbours.count("@") - 1

        # print(neighbour_rolls_total)
        if neighbour_rolls_total < 4 :
          accessible_rolls_matrix[row][col] = "x"
        #print("\n \n")
  # After iteration count rolls and update fix
  total_accessible_rolls = [col for row in accessible_rolls_matrix for col in row].count("x")
  fix = (fix[1], total_accessible_rolls)
print("The total accessible rolls are ", total_accessible_rolls)