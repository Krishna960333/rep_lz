cd .\Enterprise-Scale\docs\reference\contoso\armTemplates

Disconnect-AzAccount
Connect-AzAccount

$user = Get-AzADUser -UserPrincipalName (Get-AzContext).Account

New-AzRoleAssignment -Scope '/Tenant Root Group/TAF-FMO' -RoleDefinitionName 'Owner' -ObjectId $user.Id
remove-azroleassignment -scope /Tenant Root Group/TAF-FMO -objectId a658f601-cfd4-4e7e-84f0-1ecf1a850dde -roledefinitionname Owner

new-azroleassignment -scope /Tenant Root Group/TAF-FMO -objectId a658f601-cfd4-4e7e-84f0-1ecf1a850dde -roledefinitionname Owner


New-AzManagementGroupDeployment `
  -Name TAF-FMO-Deployment `
  -Location "West Europe" `
  -ManagementGroupId "TAF-FMO" `
  -TemplateUri "https://github.com/sanjaykrsinghgit/rep_lz/blob/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-parameters.json" `
  -TemplateParameterUri "https://github.com/sanjaykrsinghgit/rep_lz/blob/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-portal-parameters.json" `
  -WhatIf

New-AzManagementGroupDeployment `
  -Name TAF-FMO-Deploy `
  -Location "West Europe" `
  -ManagementGroupId "TAF-FMO" `
  -TemplateUri "https://github.com/sanjaykrsinghgit/rep_lz/blob/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-parameters.json" `
  -TemplateParameterUri "https://github.com/sanjaykrsinghgit/rep_lz/blob/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-portal-parameters.json" `



  New-AzManagementGroupSubscription -GroupName 'Enterprise-Scale' -SubscriptionId 'b4fdb68b-dfb2-4a38-bb44-8c47839f6ab7'

  New-AzManagementGroupSubscription -GroupName 'Enterprise-Scale' -SubscriptionId '1abcdfd7-3630-4c35-a81c-e6bae3e241fa'
  
  $toplevelgroup = Get-AzManagementGroup -GroupName 'TAF-FMO' -Expand -Recurse
  $children = $toplevelgroup.Children
  $grandchildren = $toplevelgroup.Children.Children
  foreach ($grandchild in $grandchildren) {
    Remove-AzManagementGroup -GroupName $grandchild.Name
  }
  foreach ($child in $children) {
    Remove-AzManagementGroup -GroupName $child.Name
  }
  
