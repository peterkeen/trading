Trading Engine Model
--------------------

This is a simple toy trading engine. Orders stream in on STDIN and fulfilled trades
stream out on STDOUT. The engine supports arbitrary commodities.

Note: Times are always in ISO-8601 UTC (eg "2013-12-01T03:15:13Z")

## Order Format

Orders are tab-delimted lines consisting of the following fields:

1. Order time.
2. Order Type. Currently supported orders are BUY and SELL
3. Symbol. A string consisting of any characters except newline and tab.
4. Price. A string matching the following regex: `\d+\.\d+`
5. Quantity. A string matching the regex `\d+`

## Result Format

Results are tab-delimited lines consisting of the following fields:

1. Commodity
2. Price
3. Buy order time
4. Sell order time

## Data Structure

* hash of order books, one per commodity
* order book is a pair of rb tree maps, one for buy and one for sell

## Algorithm

1. Parse order
2. Insert order into appropriate order book
3. Check order book for a match at the top
4. If there is a match, remove top orders from both buy and sell and print trade
