function wanikani_reviews_fetch
    # cache results locally
    echo -n "Fetching new statistics..." 1>&2
    curl -s "https://api.wanikani.com/v2/summary" -H "Authorization: Bearer $wanikani_token" > /tmp/wk_stats.json
    echo -ne '\r                          \r' 1>&2
end

function wanikani_reviews_count
    if not set -q wanikani_token
        echo "誤り"
        return
    end
    
    # check if results are up to date
    if [ ! -f /tmp/wk_stats.json ]
        wanikani_reviews_fetch
    end

    set last_rev_time (jq '.data.reviews[0].available_at | sub(".[0-9]+Z$"; "Z") | fromdate' /tmp/wk_stats.json)
    if [ (math (date -u +%s) - $last_rev_time) -gt 3600 ]
        wanikani_reviews_fetch
    end

    # return relevant data
    jq ".data.reviews[0].subject_ids | length" /tmp/wk_stats.json
    jq ".data.lessons[0].subject_ids | length" /tmp/wk_stats.json
end

function fish_greeting
    echo "お帰り！今日は"(date +"%y年%m月%d日だ")
    set res (wanikani_reviews_count)
    echo "WK rev: $res[1] lessons: $res[2]"
end
