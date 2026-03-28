@description('Azure region for all resources.')
param location string

@description('Name of the Automation Account to create.')
param automationAccountName string

resource automationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
    publicNetworkAccess: true
  }
}

output automationAccountResourceId string = automationAccount.id
output automationAccountName string = automationAccount.name
