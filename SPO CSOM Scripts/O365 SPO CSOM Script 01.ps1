#############################################################################################################################
#                                                                                                                           #
# Script Name           :      O365 SharePoint Online Basic Connection Script                                               #
#                                                                                                                           #
# Script Author         :      Swagata Chaudhuri                                                                            #
#                                                                                                                           #
# Script Description    :      O365 SharePoint Online Script to establish connection to a SPO Site Collection               #
#                                                                                                                           #
#############################################################################################################################

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null

$proxyCredentials = [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebRequest]::DefaultWebProxy.Credentials = $proxyCredentials

Clear-Host
Write-Host `n"Enter SharePoint Online Site Collection URL : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.String] $siteCollectionURL = Read-Host
Write-Host `n"Enter SharePoint Online User Account : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.String]$siteUserAccount = Read-Host
Write-Host `n"Enter SharePoint Online User Password : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.Security.SecureString]$siteUserPassword = Read-Host -AsSecureString
try {
    Clear-Host
    Write-Host "O365 SharePoint Online PowerShell Script Execution Initiated..."`n -ForegroundColor Green -BackgroundColor Black    
    [Microsoft.SharePoint.Client.ClientContext]$clientContext = [Microsoft.SharePoint.Client.ClientContext]::new($siteCollectionURL)
    $clientContext.Credentials = [Microsoft.SharePoint.Client.SharePointOnlineCredentials]::new($siteUserAccount, $siteUserPassword)
    [Microsoft.SharePoint.Client.Web] $web = $clientContext.Web
    $clientContext.Load($web)
    $clientContext.ExecuteQuery()
    Write-Host "Connected to site with title of $($web.Title)"`n -ForegroundColor Green -BackgroundColor Black
}
catch [System.Exception] {     
    Write-Host "Exception Message ==> $($_.Exception.Message)" -ForegroundColor Red -BackgroundColor Black 
}
finally {
    Get-Variable -exclude Runspace |
        Where-Object {
        $_.Value -is [System.IDisposable]
    } |
        Foreach-Object {
        $_.Value.Dispose()
        Remove-Variable $_.Name
    }   
    Write-Host "O365 SharePoint Online PowerShell Script Execution Completed..."`n -ForegroundColor Green -BackgroundColor Black
}