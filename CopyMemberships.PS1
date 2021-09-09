<#
Add members of one user to anoter
#>

#User to copy from
$copy = Read-host "Enter username to copy from: "

#User to copy to
$paste  = Read-host "Enter username to copy to: "


Get-ADuser -identity $copy -properties memberof | select-object memberof -expandproperty memberof | Add-AdGroupMember -Members $paste
