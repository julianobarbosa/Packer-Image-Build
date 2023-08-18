$rgName = "$Env:ARM_RESOURCE_GROUP"
$location = "$Env:LOCATION"

New-AzResourceGroup -Name $rgName -Location $location

$sp = New-AzADServicePrincipal -DisplayName "packer-principal-sp" -role Contributor -scope /subscriptions/51f4e493-4815-4858-8bbb-f263e7fb63d6
$plainPassword = (New-AzADSpCredential -ObjectId $sp.Id).SecretText

$subName = "Microsoft Azure Enterprise"
$sub = Get-AzSubscription -SubscriptionName $subName
