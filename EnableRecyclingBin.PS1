<#
Enables the built-in Recycling bin
#>


Import-module ActiveDirectory


$DomainLevel = Get-ADDomain |  Select -ExpandProperty DomainMode


if($DomainLevel -notlike "*2003*" -and $DomainLevel -notlike "*2000*") {

    $ADRecycleBin = $true

    $Domain = Get-ADDomain | Select -ExpandProperty Forest




    $enabledScopes = (Get-ADOptionalFeature -Filter 'name -like "Recycle Bin Feature"').EnabledScopes
 
    if ($enabledScopes)
    {
        Write-Output 'Enabled'

    }
    else
    {
        Write-Output 'Disabled, attempting to enable'
        Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $Domain -Confirm:$false
    }

    }Else{

        Write-Output "Domain does not support AD Recycling Bin"

    }
