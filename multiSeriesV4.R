# The following function access the BLS API and retreives the data for a list of series names.
# If a series does not exists, a message is printed to the screen
# If a series exists the data is being appended to a DataFrame and a message is being printed to the screen

multiSeriesV4 = function(varList,myKey){ 
    
    # Input: varList = a list of strings containing the series names
    # Input: myKey =  a string containing your BLS API key
    # Output: new_df = a data frame containing the data collected
    
    base_url = 'https://api.bls.gov/publicAPI/v2/timeseries/data/'  #this will not change
    headers = c('Content-type' = 'application/json')  #This will not change !

    parameters = list(
        "seriesid" = varList,
        "startyear" = "2017", 
        "endyear" = "2022",
        "catalog" = TRUE, 
        "calculations" = FALSE, 
        "annualaverage" = FALSE,
        "aspects" = FALSE,
        "registrationkey" = myKey
    )
    
    data = toJSON(parameters, pretty=TRUE, auto_unbox = TRUE) #this converts the R list into a JSON format
    
    p = POST(url = base_url, 
         body = data, 
         add_headers(headers))
    
    json_data = fromJSON(rawToChar(p$content), simplifyDataFrame = FALSE)
    
    n = length(varList) #number of series requested
    
    new_df = data.frame('year'=numeric(),'period'=character())
    for(i in 1:n){
        l = length(json_data$Results$series[[i]]$data) #length of the list 
        if(l == 0){
            print(paste0('Series ',varList[i],' does not exist'))
        } else{
            print(paste0('Series ',varList[i],' exists with ', l , ' observations'))
            d = json_data$Results$series[[i]]$data
            current_df = fromJSON(toJSON(d))
            current_df = current_df[c("year","period","value")]
            current_df$value <- as.numeric(current_df$value)  #convert strings to numbers
            current_df$period <- as.character(current_df$period)
            current_df$year <- as.numeric(current_df$year)
            names(current_df)[names(current_df)=='value'] <- varList[i]
            new_df = merge(new_df, current_df, by = c('year','period'), all = TRUE)
        }
    }       
    return(new_df)
}
