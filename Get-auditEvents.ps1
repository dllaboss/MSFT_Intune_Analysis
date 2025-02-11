<#
.SYNOPSIS
    Use Microsoft Graph API to pull Microsoft Intune Audit kogs

.DESCRIPTION
    Script to collect Microsoft Intune Aduit logs

.PARAMETER option
    Specify what information from the Audit log is desired

.EXAMPLE
    Connect-MgGraph -Scopes "DeviceManagementApps.Read.All" | Out-Null
    .\Get-auditEvents.ps1 -option AllEvents
    .\Get-auditEvents.ps1 -option DeviceConfigurationEvents-ToJson
        
.TODO
	Add additional capabilites

.OTHER
    Author: Dennis Labossiere (@dlabos)
    Version: 0.1
    Date Created: 2024-03-04
    Date Modified: 
#>
#
#------------------------------------------------------------------------------------------
# Version change history
#------------------------------------------------------------------------------------------
#
# Version 0.1 - Initial build
#
#------------------------------------------------------------------------------------------
# Set script parameters
#------------------------------------------------------------------------------------------
#
Param (
    [Parameter(Position=0)]
    [String[]]
    [ValidateSet('AllEvents', 'AllEvents-ToJson', 'DeviceConfigurationEvents', 'DeviceConfigurationEvents-ToJson')]
    $option = 'AllEvents'
)
#
#------------------------------------------------------------------------------------------
# Set script variables
#------------------------------------------------------------------------------------------
#
# Format date/time to ISO8601 format
$FormattedDate = (Get-Date).ToString("yyyy-MM-dd")
$ScriptDir = Get-Location
$OutDir = New-Item -ItemType Directory -Force -Path $ScriptDir\$FormattedDate-Intune_auditLog 
#$ErrorActionPreference = 'silentlycontinue'
#Import necessary Graph API module
Import-Module Microsoft.Graph.DeviceManagement.Administration
#
#------------------------------------------------------------------------------------------
# Set Graph API connection
#------------------------------------------------------------------------------------------
#
# Reference: https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.authentication/connect-mggraph?view=graph-powershell-1.0
# Connect to Microsoft Graph CLI and add necessary permissions
#Connect-MgGraph -Scopes "DeviceManagementApps.Read.All" | Out-Null
#
#------------------------------------------------------------------------------------------
# Set script functions
#------------------------------------------------------------------------------------------
#
#
function Get-AllEvents {
    Get-MgDeviceManagementAuditEvent
}
#
function Get-AllEvents-toJson {
    #Get-MgDeviceManagementAuditEvent | ConvertTo-Json
    Get-MgDeviceManagementAuditEvent | ConvertTo-Json | Out-File -FilePath $OutDir\all_auditLogs.json
}
#
function Get-DeviceConfigurationEvents {
    Get-MgDeviceManagementAuditEvent -Filter "category eq 'DeviceConfiguration'"
}
#
function Get-DeviceConfigurationEvents-toJson {
    #Get-MgDeviceManagementAuditEvent -Filter "category eq 'DeviceConfiguration'" | ConvertTo-Json
    Get-MgDeviceManagementAuditEvent -Filter "category eq 'DeviceConfiguration'" | ConvertTo-Json | Out-File -FilePath $OutDir\all_DeviceConfigurationEvents.json
}
#
#------------------------------------------------------------------------------------------
# Script main function
#------------------------------------------------------------------------------------------
#
function Get-Events {
    if ($option -match 'AllEvents'){
        Get-AllEvents
    }

    if ($option -match 'AllEvents-ToJson'){
        Get-AllEvents-toJson
    }

    if ($option -match 'DeviceConfigurationEvents'){
        Get-DeviceConfigurationEvents
    }

    if ($option -match 'DeviceConfigurationEvents-ToJson'){
        Get-DeviceConfigurationEvents-toJson
    }
}
#
Get-Events