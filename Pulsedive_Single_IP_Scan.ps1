#Get API key and IP address from user
$apiKey = "[PULSEDIVE API KEY]"
$ip = Read-Host -Prompt "Enter the IP address you want to query"

#Make GET request to Pulsedive API using the explorer endpoint with the IP address as the query
$response = Invoke-WebRequest -Uri "https://pulsedive.com/api/explore.php?q=ioc=$ip&limit=10&pretty=1&key=$apiKey" -ErrorAction Stop

#Check if the response is a valid json
Write-Output $response.content

if($response.StatusCode -eq 200){
    # parse the JSON response
    $json = ConvertFrom-Json $response.Content
    # Extract additional information from the JSON response
    $results = $json.results
    if ($results) {
      $json = ConvertFrom-Json $response.Content
		$results = $json.results
		foreach ($result in $results)
            $indicator = $result.indicator
            $risk = $result.risk
            $type = $result.type
            $stamp_added = $result.stamp_added
            $stamp_updated = $result.stamp_updated
            $stamp_seen = $result.stamp_seen
            $geo = $result.summary.properties.geo
            $city = $geo.city
            $region = $geo.region
            $country = $geo.country
            $org = $geo.org
            #Print the extracted information to the console
            Write-Output "Indicator: $indicator"
            Write-Output "Risk level: $risk"
            Write-Output "Type of Indicator: $type"
            Write-Output "Stamp added: $stamp_added"
            Write-Output "Stamp updated: $stamp_updated"
            Write-Output "Stamp seen: $stamp_seen"
            Write-Output "City: $city"
            Write-Output "Region: $region"
            Write-Output "Country: $country"
            Write-Output "Organization: $org"
        }
    } else {
        Write-Output "No results found for the provided IP address"
    }
}else{
    Write-Output "Could not get the information of $ip from the API. Response Code: $($response.StatusCode) Reason: $($response.StatusDescription)"
}
