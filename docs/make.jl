using Documenter
using YahooFinance

makedocs(modules = [YahooFinance],
        format = Documenter.HTML(assets = ["assets/style.css"], prettyurls = true),
        doctest = true,
        clean = false, # ?
        sitename = "YahooFinance.jl",
        authors = "Markus Hauschel",
        pages = [
            "Home" => "index.md",
        ])

deploydocs(repo = "https://github.com/markushhh/YahooFinance.jl/",
                julia = "1.2.0", osname = "windows")
