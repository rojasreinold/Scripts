<html>
<head>
<meta http-equiv="refresh" content="60">
</head>
<title> license checker - v1 </title>
<body bgcolor="#FFFFFF">
<!--<img src="logo.JPG"><img src="clarisse.gif"><img src="logo.JPG">--!>
<h2>clarisse license checker</h2>
<?php
system('/bin/date')
?>
<?php
echo '<pre>';
// php to in a very ugly way show us how many nuke users there are and who they are 
// to rat out the multiple license nuke users.. 

$number = popen("./licinfo serverName:0001 list", 'r');
if ($number) {
	if ($number) {
	while (!feof($number)) {
		$line = fgets($number, 4096);
		echo $line;	
	}
	fclose($number);
}
    ksort($output_array);
foreach ($output_array as $oa) {
    print $oa;
}
}
echo "<b>Running Clients</b><br>";
$openClientsExists = exec("./licinfo serverName:0001 list_clients | grep host | awk '{print $1}' | sort | uniq | cut -d@ -f2 | grep [0-9] " );
echo $openClientsExists;
if ($openClientsExists != '') {
    //set up getting data from dyassets
    $username="username";
    $password="password";
    $database="database";

    mysql_connect("localhost",$username,$password);
    @mysql_select_db($database) or die( "unable to select database / error:".mysql_error());
    $command ="./licinfo serverName:0001 list_clients | grep host | awk '{print $1}' | sort | uniq | cut -d@ -f2 | grep [0-9] 2> /dev/null" ;
    $aVar = exec($command,$ipAddresses , $someVar);


    
    foreach ($ipAddresses as $systemipAddress) {
        //get Hostname:
	$command = "host ".$systemipAddress." | cut-d' ' -f5 | cut -d'.' -f1";
        $systemHostname=exec("host ".$systemipAddress." | cut -d' ' -f5 | cut -d'.' -f1");
        //get username
        $dataquery="select last_user from asset where hostname=" . $systemHostname;
        $systemUser=mysql_query($dataquery);

        //Tie it all together
        $systemInfo="username: " . $systemUser . " hostname: " . $systemHostname . " ip Address: " . $systemipAddress . "\n";
        echo $systemInfo;
     }
    

}
?>
