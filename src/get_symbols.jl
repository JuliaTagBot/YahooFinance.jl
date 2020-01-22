"""

# Download stock market data from Yahoo Finance

    get_symbols(symbol, from, to)

## Arguments

    - `symbol`: Market symbol, e.g. "AAPL" or "GOOG"
    - `from` : Date character, e.g. "2018-12-13" in the form of "YYYY-MM-DD"
    - `to` : Date character, e.g. "2019-12-13" in the form of "YYYY-MM-DD"

## Examples

```jldoctest
julia> get_symbols("GOOG", "2018-12-26", "2019-12-20")
julia> get_symbols("^GDAXI", "2018-12-26", "2019-12-20")
julia> get_symbols("EURUSD=X", "2018-12-26", "2019-12-20")
julia> get_symbols("BTC-USD", "2018-12-26", "2019-02-20")
```
"""
function get_symbols(symbol::String, from::String, to::String)

    from = string(Integer(datetime2unix(DateTime(from * "T12:00:00"))))
    to = string(Integer(datetime2unix(DateTime(to * "T12:00:00"))))
    parse(Int, from) > parse(Int, to) ? error("in get_symbols: to must be older than from") : nothing

    url = "https://query1.finance.yahoo.com/v7/finance/chart/$symbol?&interval=1d&period1=$from&period2=$to"

    response = HTTP.get(url, cookies = true)
    body = JSON.parse(String(response.body))["chart"]["result"][1]
    values = body["indicators"]["quote"][1]

    x = DataFrame(
        Open = values["open"],
        High =  values["high"],
        Low = values["low"],
        Close = values["close"],
        Volume = values["volume"],
        Adjusted = body["indicators"]["adjclose"][1]["adjclose"],
        Time = Dates.Date.(unix2datetime.(body["timestamp"]))
    )

    deleterows!(x, isnothing.(x).Close)
    x = TimeArray(x, timestamp = :Time)

    return(x)
end
