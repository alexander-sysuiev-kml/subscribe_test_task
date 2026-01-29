## Balance calculation

### Assumptions
- No parsing logic is required to identify the entity type (food, perfume, medical) or whether it is imported. If pattern matching is required, it could be added to InputService.
- I did not understand how 35.55 appeared in the 3rd example. According to the description, the tax amount should be rounded to 0.05. 11.25 * 0.05 = 0.5625 -> 0.55, 33.75 * 0.05 = 1.6875 -> 1.7, 33.75 * 1.05 = 35.43 -> 35.45. The only way I see it could appear is if 11.25 * 0.05 = 0.5625 -> 0.6, 0.6 * 3 = 1.8, 1.8 + 33.75 = 35.55. But rounding 0.5625 to 0.6 is against the requirement.
- I considered avoiding a decorator for LineItem, but it could lead to internal recursion in tax calculation. So placing the DAO with the decorator seems like the canonical approach in this case.

### Requirements
- Ruby 3.x (or any Ruby version that can run `rspec`)
- `rspec` gem installed

Install `rspec` if needed:

```
gem install rspec
```

### Run the script
The script reads a CSV file and prints the calculated totals to stdout.

```
ruby runner.rb resources/input_example1.csv
```

Or use the shell wrapper:

```
./runner.sh resources/input_example1.csv
```

If no file path is provided, it defaults to `input.csv` in the project root.

### CSV format
The input file must include a header row with these columns:

```
name,quantity,price,type,imported
```

Example row:

```
chocolate bar,1,0.85,food,false
```

### Run tests
From the project root:

```
rspec
```
