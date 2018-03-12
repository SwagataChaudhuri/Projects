#############################################################################################################################
#                                                                                                                           #
# Script Name           :      O365 SharePoint Online Single File Download Script                                           #
#                                                                                                                           #
# Script Author         :      Swagata Chaudhuri                                                                            #
#                                                                                                                           #
# Script Description    :      O365 SharePoint Online Script to Download a Single File from provided URL                    #
#                                                                                                                           #
#############################################################################################################################

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")

$proxyCredentials = [System.Net.CredentialCache]::DefaultCredentials
[System.Net.WebRequest]::DefaultWebProxy.Credentials = $proxyCredentials

Clear-Host
Write-Host `n"Enter SharePoint Online User Account : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.String]$siteUserAccount = Read-Host
Write-Host `n"Enter SharePoint Online User Password : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.Security.SecureString]$siteUserPassword = Read-Host -AsSecureString
Write-Host `n"Enter SharePoint Online File URL : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.String]$fileURL = Read-Host
Write-Host `n"Enter SharePoint Online File Save Path : " -NoNewline -ForegroundColor Green -BackgroundColor Black
[System.String]$fileSavePath = Read-Host

try {
    Clear-Host
    Write-Host "O365 SharePoint Online PowerShell Script Execution Initiated..."`n -ForegroundColor Green -BackgroundColor Black    
    $fileName = [System.IO.Path]::GetFileName($fileURL)
    $downloadFilePath = [System.IO.Path]::Combine($fileSavePath, $fileName)
    $client = New-Object System.Net.WebClient 
    $client.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($siteUserAccount, $siteUserPassword)
    $client.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
    $client.DownloadFile($fileURL, $downloadFilePath)
    $client.Dispose();
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