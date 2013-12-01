Simple Trading Engine
---------------------

This is a simple toy trading engine. Orders stream in on STDIN and fulfilled trades
stream out on STDOUT. The engine supports arbitrary commodities.

Note: Times are always in ISO-8601 UTC (eg "2013-12-01T03:15:13Z")

## Order Format

Orders are tab-delimted lines consisting of the following fields:

1. Order time.
2. Order Type. Currently supported orders are BUY and SELL
3. Symbol. A string consisting of any characters except newline and tab.
4. Price. A string matching the following regex: `\d+\.\d+`

## Result Format

Results are tab-delimited lines consisting of the following fields:

1. Result time.
2. Commodity
3. Price
4. Buy order time
5. Sell order time

## Data Structure

Hash table of lists. Key is a "match key" explained below. Value is a list of timestamps.

## Algorithm

1. Parse order
2. Generate a corresponding "match key"
  a. inverse of order type. For "BUY" this is "SELL" and vise versa.
  b. commodity
  c. price
3. Look in hash table for match key.
  a. If list not empty, pop the first timestamp in the list and output a result.
  b. Else, push the timestamp onto the list
