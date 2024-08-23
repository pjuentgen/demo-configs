function check_json(tag, timestamp, record)
    if type(record) == "table" then
        return 1, timestamp, record
    else
        local new_record = {}
        new_record["msg"] = record
        return 1, timestamp, new_record
    end
end