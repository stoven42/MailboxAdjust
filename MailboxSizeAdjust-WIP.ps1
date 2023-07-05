#
# SCRIPT TO AUTOMATE EXCHANGE MAILBOX SIZE ADJUSTMENTS
# Last Edit : 7/5/23
#
# Test Edit

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned

# Check system to ensure Exchange Online Module is installed
if(-not (Get-Module ExchangeOnlineManagement -ListAvailable)){
    Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force
}

# Provide Admin credentials to log into Exchange Online
$AdminEmail = Read-Host -Prompt 'Input your admin email address'
Write-Host "`n"

# Connects to Exchange Online with Admin credentials, Sets Execution Policy
Connect-ExchangeOnline -UserPrincipalName $User


# Prompt to store username in varaible, display current size details
$User = Read-Host -Prompt 'Input the first.last of user'
Write-Host "`n"
Get-Mailbox $User | fl DisplayName,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,UseDatabaseQuotaDefaults

# Pulls current mailbox size data for provided user
$MailboxSize = Get-Mailbox $User | fl DisplayName,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,UseDatabaseQuotaDefaults 

# Prompt to confirm size adjustment
Write-Host "`n"
$Prompt = Read-Host -Prompt 'Would you like to adjust the mailbox size? (yes/no)'
Write-Host "`n"

# Loop to change mailbox size if above prompt is 'yes', otherwise will cancel process and stop script
if ($Prompt -eq "yes") {
    $Adjust = Read-Host -Prompt "Input the total mailbox size in GB"
    $AdjustedValue = Set-Mailbox $User -ProhibitSendQuota $Adjust'GB' -ProhibitSendReceiveQuota $Adjust'GB' -IssueWarningQuota $Adjust'GB'
    $MailboxSize = $AdjustedValue
    Start-Sleep 5
    Write-Host "The mailbox size has been updated"
} else {
    Write-Host "Process has been cancelled"
}

# Display new/current value
Write-Host "`n"
Write-Host "New/Current Value:"
Get-Mailbox $User | fl DisplayName,IssueWarningQuota,ProhibitSendQuota,ProhibitSendReceiveQuota,UseDatabaseQuotaDefaults
Start-Sleep 5

# User confirms exit
Write-Host "`n"
Read-Host -Prompt "Press Enter to exit"



