param nameseed string = 'azureanimated'
param location string = resourceGroup().location

var uniqueSuffix = uniqueString(resourceGroup().id, deployment().name)

module webApps 'webapps.bicep' = {
  name: '${deployment().name}-webapps'
  params: {
    nameseed: nameseed
    webAppName: 'animated'
    location: location
    uniqueSuffix: uniqueSuffix
  }
}
