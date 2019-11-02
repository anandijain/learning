using HTTP, JSON, BenchmarkTools

function get_page()
    url = "https://api.matchbook.com/edge/rest/events"

    querystring = Dict("offset"=> "0", "per-page"=> "20", "sport-ids"=> "1,4", 
                "states"=> "open,suspended,closed,graded", 
                "exchange-type"=> "back-lay", "odds-type"=> "DECIMAL", 
                "include-prices"=> "true", "price-depth"=> "3", 
                "price-mode"=> "expanded", "include-event-participants"=>"false")

    headers = Dict("user-agent"=> "api-doc-test-client")
    response = HTTP.get(url, headers=headers, body=JSON.json(querystring))
end

function main()
    # @benchmark get_page()
    # @btime get_page()
    @time begin
        get_page()
    end
end

main()
