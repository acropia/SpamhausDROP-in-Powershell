$droplistUri = "http://www.spamhaus.org/drop/drop.lasso";
$response = Invoke-WebRequest -Uri $droplistUri;
$droplist = $response.Content;
$droplistCount = 0;

Foreach ($line in $droplist.Split("`n")) {
    If ($line.StartsWith(";")) {
        Continue;
    }
    $parts = $line.Split(";");
    $ip = $parts[0];
    $ip = $ip.Trim();

    $id = $parts[1];
    $id = $id.Trim();

    Write-Output $ip;

    $displayName = "Spamhaus DROP item " + $id;

    New-NetFirewallRule -DisplayName $displayName -RemoteAddress $ip -Direction Inbound -Group "Spamhaus DROP" -Action Block;

    $droplistCount++;
}
