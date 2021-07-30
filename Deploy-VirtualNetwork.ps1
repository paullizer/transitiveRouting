<#  
.SYNOPSIS  
    Deploy hub and spoke architecture with transitive routing.
.DESCRIPTION  
    Deploy hub and spoke architecture with transitive routing using a JSON template to define the hub and spoke configurations.
    
    This means Virtual Network Gateways are deployed (which have a cost), VNET peering is performed between hub and spoke(s), VNET to VNET connection is performed between hubs,
    and route tables are deployed to facility transitive routing.

        v1.0 - Update
.NOTES  
    File Name       :   Deploy-VirtualNetwork.ps1  
    Author          :   Paul Lizer, paullizer@microsoft.com
    Prerequisite    :   PowerShell V5, Azure PowerShell 5.6.0 or greater
    Version         :   1.0 (2021 07 15)     
.LINK  
    https://github.com/paullizer/transitiveRouting
.EXAMPLE  
    If no parameter is defined then JSON template (https://github.com/paullizer/transitiveRouting/blob/main/multiHub/template-multiHub-SingleSub-nameSchema.json) will be used

        Deploy-VirtualNetwork.ps1

.EXAMPLE  
    You can use your own configured JSON template. UNC and HTTP/HTTPS paths can be used. You should really not be using HTTP at this point, please do better.

        Deploy-VirtualNetwork.ps1 -template "path:\to\tempalte.json"

.EXAMPLE  
    You can use your own configured JSON template. UNC and HTTP/HTTPS paths can be used. You should really not be using HTTP at this point, please do better.

        Deploy-VirtualNetwork.ps1 -template "https://github.com/paullizer/transitiveRouting/blob/main/multiHub/template-multiHub-SingleSub-nameExplicit.json"
#>

<#***************************************************
                       Process
-----------------------------------------------------
    
https://github.com/paullizer/transitiveRouting#multi-hub-architecture

***************************************************#>
    

<#***************************************************
                       Terminology
-----------------------------------------------------
N\A
***************************************************#>


<#***************************************************
                       Variables
-----------------------------------------------------
***************************************************#>

$powerShellAzureVersion = "5.6.0"

<#***************************************************
                       Functions
-----------------------------------------------------
***************************************************#>

function Install-AzurePowerShell {
    <#----------------------
        Determine if a Azure PowerShell is installed. If not, attempt to install.
    -----------------------#>

    param (
        [Parameter(Mandatory=$false)]
        $attemptCount
    )

    if(!$attemptCount){
        $attemptCount = 5
        Write-Host "`nValidating Azure PowerShell is installed.`n"
    }

    if ($attemptCount -gt 0){
        try{
            $azureModuleObjects =  Get-InstalledModule -Name "Az"
        }
        catch {
            Write-Warning "`tUnable to determine if Azure PowerShell is installed."
            
        }

        if (!$azureModuleObjects){
            Write-Warning "Azure PowerShell is not installed."
            Write-Host "Checking for elevated permissions..."

            if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                [Security.Principal.WindowsBuiltInRole] "Administrator")) {
                Write-Warning "Insufficient permissions to install Azure PowerShell Module. Open the PowerShell console as an administrator and run this script again."
                Break
            }
            else {
                try {
                    Write-Host "`t`tCode is running as administrator" -ForegroundColor Green
                    Write-Host "`tAttempting to install Azure PowerShell. Remaining attempts " + $attemptCount + "."
                    Install-Module -Name Az -AllowClobber -Scope AllUsers
                    Write-Host "`t`tAzure PowerShell Installed." -ForegroundColor Green
                }
                catch {
                    $attemptCount--
                }         
            }
        }
        else {

            Write-Warning "Azure PowerShell is installed."
            Write-Host "Checking for elevated permissions..."

            if ($azureModuleObjects.Version -gt $powerShellAzureVersion){

            }
            else {
                Write-Warning "Azure PowerShell is installed."
                Write-Host "Checking for elevated permissions..."

                if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
                    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
                    Write-Warning "Insufficient permissions to install Azure PowerShell Module. Open the PowerShell console as an administrator and run this script again."
                    Break
                }
                else {
                    Write-Host "`t`tCode is running as administrator" -ForegroundColor Green
                    Write-Host "`tAttempting to install Azure PowerShell. Remaining attempts " + $attemptCount + "."
                    Install-Module -Name Az -AllowClobber -Scope AllUsers
                    Write-Host "`t`tAzure PowerShell Installed." -ForegroundColor Green
                                        
                }
            }
        }

        Install-PowerShell $attemptCount
    }
}

function Connect-AzureEnvironment {
    <#----------------------
        Determine if a Azure PowerShell is installed. If not, attempt to install.
    -----------------------#>
    
    $boolTryAgain = $false
    $boolAccountFound = $false
    $boolTenantFound = $false
    
    try {
        $azContext = Get-AzContext -ListAvailable
    }
    catch {
        Write-Warning "Not connected to Azure Account. Attempting connection, please following Browser Prompts."
    }

    if (!$azContext){
        try {
            Connect-AzAccount -ErrorAction Stop
        }
        catch {
            Write-Warning "Failed to connect to Azure. Please verify access to internet or permissions to Azure. Existing process."
            Break Script
        }
    }
    else {
        while (!$boolAccountFound) {
            Write-Host ("Connected to Accounts: `n") -ForegroundColor Gray

            foreach ($az in $azContext){
                Write-Host ("`t`t" + $az.name.split("(")[0] + ", " + $az.Account.Id)
            }

            $userInputTryAgain = Read-Host ("`n`tDo you want to connect to any additional accounts? [Y or Yes, N or No]")

            switch ($userInputTryAgain.ToLower()) {
                "n" {
                    $boolAccountFound = $true
                }
                "no" { 
                    $boolAccountFound = $true
                }
                "y" { $boolTryAgain = $true }
                "yes" { $boolTryAgain = $true }
                Default { 
                    Write-Warning "Incorrect value. Please enter [Y or Yes, N or No]" 
                    $boolTryAgain = $false
                }
            }

            if ($boolTryAgain){
                Connect-AzAccount
                $azContext = Get-AzContext -ListAvailable
            }  
        }
    }


    $boolTryAgain = $true
    

    while (!$boolTenantFound) {
        if ($boolTryAgain){
            $userInputTenantId = Read-Host "`nPlease enter Tenant Id"
        }

        $tenant = Get-AzTenant $userInputTenantId
        
        if ($tenant){
            $boolTenantFound = $true
        } else {
            Write-Warning "Unable to find Tenant, please enter valid name or confirm your access to resource."
        
            $userInputTryAgain = Read-Host "Do you want to try again? [Y or Yes, N or No]"

            switch ($userInputTryAgain.ToLower()) {
                "n" {
                    Break Script
                }
                "no" { 
                    Break Script
                }
                "y" { $boolTryAgain = $true }
                "yes" { $boolTryAgain = $true }
                Default { 
                    Write-Warning "Incorrect value. Please enter [Y or Yes, N or No]" 
                    $boolTryAgain = $false
                }
            }
        }
    }

    if ($azContext.Tenant.Id -ne $tenant.Id){
        try {
            Set-AzContext -TenantId $tenant.Id -ErrorAction Stop | Out-Null
        }
        catch {
            Write-Warning "Unable to set Azure Context. Please verify access to context. Existing process."
            Break Script
        }
    }

    Write-Host ("`tConnected to " + $tenant.name + " with Tenant ID " + $tenant.Id) -ForegroundColor Green

}

<#***************************************************
                       Execution
-----------------------------------------------------
***************************************************#>

Clear-Host

Write-Host "`nThis process will deploy a fully connected and routable hub(s) and spoke(s) network.`n" -ForegroundColor Cyan

Install-AzurePowerShell

Connect-AzureEnvironment
