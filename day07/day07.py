with open("input.txt", "r") as file:
  lines = file.read().splitlines()
  manifold = [list(line) for line in lines]

# Part 1
# modify manifold with beams

rows = len(manifold)
cols = len(manifold[0])
start = manifold[0].index("S")
# store all beams (column index) at each iteration
beams = [start]
splits = 0 # number of beam split

for row in range(1, rows):
  # for each row, starting from the second one
  # insert the beam if in the pre_row there is a beam on the same column

  # store next_beams to save new split
  this_row_beams = []

  for beam in beams:
    this_row = manifold[row]
    # for each beam, add or split it in this_row
    if this_row[beam] == ".":
      this_row[beam] = "|"
      this_row_beams.append(beam) # update beams in this row

    elif this_row[beam] == "|":
      # add nothing, just update beams in this row
      this_row_beams.append(beam) # if duplicate we correct them later

    else: # we have to split (char == "^")
      right_beam = beam - 1
      left_beam = beam + 1

      if left_beam >= 0: # inside left edge
        this_row[right_beam] = "|"
        this_row_beams.append(right_beam)

      if right_beam < cols: # inside right edge
        this_row[left_beam] = "|"
        this_row_beams.append(left_beam)

      splits += 1 # count the split
  
  # update new beams
  beams = list(set(this_row_beams)) # set to remove duplicate

#print("\n".join(["".join(row) for row in manifold]))
print(f"The total number of splits is {splits}")


# Part 2
# now modify manifold with timelines number instead of beams

# starting from the manifold with the beams, "count" the timelines
# and create a new grid with the numbers

timelines_grid = []
# in first row, original timeline from start
timelines_grid.append([0] * cols)
timelines_grid[0][start] = 1

for row in range(1, rows):
  # for each row, starting from the second one
  # create a default line with zeroes
  timeline_row = [0] * cols
  # if there is beam, count how many timelines converge on it

  this_manifold_row = manifold[row]
  prev_manifold_row = manifold[row-1]
  prev_timelines_row = timelines_grid[row-1]

  # cycle on columns
  for col in range(0, cols):
    if this_manifold_row[col] != ".":
      # we are on a beam
      # converging timelines => 
      #   up 
      # + up_left, if timeline coming from a right split in upper line
      # + up_right, if timeline coming from a left split in upper line

      converging_timelines = 0

      if prev_manifold_row[col] != "^":
        converging_timelines += prev_timelines_row[col]

      # check if something coming from a splitter and we are inside the grid
      up_left = col - 1
      if up_left >= 0 and prev_manifold_row[up_left] == "^" :
        converging_timelines += prev_timelines_row[up_left]

      up_right = col + 1
      if up_right < cols and prev_manifold_row[up_right] == "^":
        converging_timelines += prev_timelines_row[up_right]
      
      timeline_row[col] = converging_timelines
  # add the updated timelines row in the grid
  timelines_grid.append(timeline_row)

timelines = sum(timelines_grid[rows-1])
#print("\n".join([" ".join([str(item) for item in row]) for row in timelines_grid]))
print(f"The total number of timelines is {timelines}")