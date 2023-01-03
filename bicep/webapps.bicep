param nameseed string
param location string = resourceGroup().location
param uniqueSuffix string 

@description('A unique name will be generated that includes the nameseed, but if you will be using the primary hostname then you may wish to override.')
param webAppName string = 'web-${nameseed}${empty(uniqueSuffix) ? '' : '-${uniqueSuffix}'}'

resource webApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/appServicePlan': 'Resource'
    'created-with': 'bicep'
    'created-by': 'gordon'
  }
  properties: {
    siteConfig: {
      appSettings: [
        // {
        //   name: 'SCM_REPOSITORY_PATH' //used when app code is in a repo subdirectory
        //   value: 'web'
        // }
      ]
      healthCheckPath: '/'
    }
    serverFarmId: appServicePlan.id
  }
}
output webApplicationHostName string = webApplication.properties.defaultHostName

param repo string = 'https://github.com/Gordonby/AzureAnimated.git'
param repoBranch string = 'master'
resource WebCodeDeploy 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent: webApplication
  name: 'web'
  properties: {
    repoUrl: repo
    branch: repoBranch
    isManualIntegration: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-${nameseed}'
  location: location
  tags: {
    'created-with': 'bicep'
    'created-by': 'gordon'
  }
  sku: {
    name: 'F1'
    capacity: 1
  }
}
