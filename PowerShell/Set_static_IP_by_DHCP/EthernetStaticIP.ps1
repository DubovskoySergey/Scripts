#--- Set the static IP address issued by DHCP ---#

# This script sets a static ip address received via DHCP.
# Set the value of the $dns variable to the ip address of your dns server.
# To run, run the 'run_static_ip' shortcut, it already has a flag set for running as an administrator.
# 

# Get name of the interface
$index = Get-NetIPConfiguration | ForEach-Object IPv4DefaultGateway
$index = $index.ifIndex
$name_Int = Get-NetIPConfiguration -InterfaceIndex $index | ForEach-Object InterfaceAlias
# Get ip address of the gateway
$gw = Get-NetIPConfiguration | Select-Object -ExpandProperty IPv4DefaultGateway | Select-Object -ExpandProperty NextHop
# Save ip address issued to us via dhcp
$ipV4 = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $name_Int
$ip = $ipV4.IPAddress
# Save dns address
$dns = ""

# Print information on the screen
Write-Output "Your IP Addres: $ip"
Write-Output "Your gateway:   $gw"
Write-Output "Your name interface: $name_Int"
# Deleting the ip address on the interface
Get-NetIPAddress -InterfaceAlias $name_Int | Remove-NetIPAddress -Confirm:$false
# Set static ip, mask, gateway
New-NetIPAddress -InterfaceAlias $name_Int -IPAddress $ip -PrefixLength 24 -DefaultGateway $gw -Confirm:$false
# Set static dns
Set-DnsClientServerAddress -InterfaceAlias $name_Int -ServerAddresses ($dns) -Confirm:$false

