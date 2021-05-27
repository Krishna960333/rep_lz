cd .\Enterprise-Scale\docs\reference\contoso\armTemplates

Disconnect-AzAccount
Connect-AzAccount

$user = Get-AzADUser -UserPrincipalName (Get-AzContext).Account

New-AzRoleAssignment -Scope '/' -RoleDefinitionName 'Owner' -ObjectId $user.Id
remove-azroleassignment -scope / -objectId 39a368c8-d73a-4c59-9ff7-97ac13e8150a -roledefinitionname Owner

new-azroleassignment -scope / -objectId 39a368c8-d73a-4c59-9ff7-97ac13e8150a -roledefinitionname Owner


New-AzManagementGroupDeployment `
  -Name old-2-mg `
  -Location "uksouth" `
  -ManagementGroupId "old-3-mg" `
  -TemplateUri "https://github.com/sanjaykrsinghgit/rep_lz/blob/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-parameters.json" `
  -TemplateParameterUri "https://raw.githubusercontent.com/Mahesh-MSFT/Enterprise-Scale/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-portal-parameters.json" `
  -WhatIf

  New-AzManagementGroupDeployment `
  -Name old-3-mg-deployment `
  -Location "uksouth" `
  -ManagementGroupId "old-3-mg" `
  -TemplateUri "https://raw.githubusercontent.com/Mahesh-MSFT/Enterprise-Scale/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg.json" `
  -TemplateParameterUri "https://raw.githubusercontent.com/Mahesh-MSFT/Enterprise-Scale/deploy-at-mg/docs/reference/contoso/armTemplates/es-vwan-mg-portal-parameters.json"



  New-AzManagementGroupSubscription -GroupName 'Enterprise-Scale' -SubscriptionId '035f3891-2d42-41cc-8e7d-71ec904d4980'
  Remove-AzManagementGroupSubscription -GroupName 'old-3-mg-management' -SubscriptionId '035f3891-2d42-41cc-8e7d-71ec904d4980'

  New-AzManagementGroupSubscription -GroupName 'Enterprise-Scale' -SubscriptionId '1b67375a-eee0-4a74-89aa-9e8d04483fbb'
  Remove-AzManagementGroupSubscription -GroupName 'old-3-mg-corp' -SubscriptionId '1b67375a-eee0-4a74-89aa-9e8d04483fbb'
  
  $toplevelgroup = Get-AzManagementGroup -GroupName 'old-3-mg' -Expand -Recurse
  $children = $toplevelgroup.Children
  $grandchildren = $toplevelgroup.Children.Children
  foreach ($grandchild in $grandchildren) {
    Remove-AzManagementGroup -GroupName $grandchild.Name
  }
  foreach ($child in $children) {
    Remove-AzManagementGroup -GroupName $child.Name
  }
  
