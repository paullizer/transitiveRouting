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
    Prerequisite    :   PowerShell V5
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


<#***************************************************
                       Functions
-----------------------------------------------------
***************************************************#>


<#***************************************************
                       Execution
-----------------------------------------------------
***************************************************#>