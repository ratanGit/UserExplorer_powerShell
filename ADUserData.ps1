#AD and Azure modules: March 20 2018
try{ Import-Module ac* }
    catch{Write-Warning "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"}
try{ Import-Module MSOnline }
    catch{Write-Warning "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"}
try{ Import-Module SkypeOnlineConnector }
    catch{Write-Warning "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"}

#Global variables for the select filters

    $global:userAttribs = @('Name','Enabled','AccountExpirationDate','LastLogonDate','LockedOut', 'City', 'Title','extensionAttribute10',`
            'extensionAttribute9','Manager', 'Description','Department','SamAccountName', 'Created','msExchWhenMailboxCreated',`
            'msExchHomeServerName','PasswordLastSet','LastBadPasswordAttempt','AccountLockoutTime', `
            'LineURI','msRTCSIP-Line','msRTCSIP-UserEnabled','UserPrincipalName', 'DistinguishedName')
    $global:groupAttribs = @("Name", "GroupCategory", "DistinguishedName")

function findUser{
    <#
    .SYNOPSIS
        Finds a user account in Active Directory and fetches predefined attributes.
    .DESCRIPTION
        Uses get-aduser and get-adprincipalgroupmembership with a set of select filters.
    .PARAMETER User
        SamAccountName, Email or Name (full/partial) - e.g., ratan | ratan@mydomain.edu | Ratan Mohapatra. When uing Name -SearchType parameter is required.
    .PARAMETER SearchType
        Gives the options: 
            ByName when it uses -filter{name -like '*Name*'}
            ByID when it uses the SaMAccountName or Email to fetch user data    
    .EXAMPLE
        findUser -User ratan (ratan is my samAccountName)
    .EXAMPLE
        findUser -User 'ratan mohapatra' -SearchType ByName
    .NOTES
        Author: Ratan Mohapatra
        Last Update: March 10, 2019 
    #>

    [CmdletBinding()]
    param(
        [string]$User,
        [ValidateSet('ByName','ByID')][string]$SearchType,
        [string]$ulMark ='~',
        [string]$upn="",
        $usrSearch=""
        )
    Begin{
        $dt = get-date -format hh:mm:ss
        }
    Process{
        try{
            if(Get-ADDomain){
                   #Filter Search
                if($SearchType -eq 'ByName'){
                    $usrstring = '*' + $user + '*'
                    try{ $usrSearch = get-aduser -filter { name -like $User } -properties Name, SamAccountName, City, Department }
                    catch{Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
                            return "$($_.InvocationInfo.ScriptLineNumber) : User $User was not found!"
                         }
                    $res = $usrSrch.count
                    if($res -gt 1){
                        coolwrite -color cyan -Message "The search has returned $res users: `n"
                        $usrSrch | ft -AutoSize
                        $user2Find = [string](Read-Host 'Please provide the SamAccountName from above')}
                    else{
                        $user2Find = [string]($usrSrch.SamAccountName)
                        }
                    }
                else{ $user2Find = $User }
                $UserIDArray  = getUserAccountID -UserIDString $user2Find
                [string]$UserID = $UserIDArray[0]
                if($UserIDArray[1] -ne 0){ [string]$UserDomain = $UserIDArray[1] }

                $UserAcc = get-aduser -filter {SamAccountName -eq $UserID} -properties * | select $userAttribs   
                if(!($UserAcc)){throw "The user was not found!"}
                else{
                    $upn = $UserAcc.UserPrincipalName
                    $strCaptionUserAccount = "User Account Details of $upn"                    
                    #$ulAcc = $ulMark*$strCaptionUserAccount.Length
                    $UserAccData  = $UserAcc | out-string                    
                    $usrGroupData = get-ADPrincipalGroupMembership $UserAcc.SamAccountName | select $groupAttribs | ft -AutoSize | Out-String
                    $strCaptionGroup = "Group Membership of $upn"
                    #$ulGroup =$ulMark*$strCaptionGroup.Length
                    Write-host $dt
                    coolwrite -color Yellow -Message "`r`n$strCaptionUserAccount :"
                        write-host $UserAccData
                    coolwrite -color Yellow -Message "`r`n$strCaptionGroup :"
                        write-host $usrGroupData
                    #[System.Windows.Forms.Clipboard]::GetText()                    
                    }
                }
            else{
                throw 'The Script cannot find an Active Directory Domain!'
                }
            $usr  = $null
            }
        catch{
            Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
            }
        finally{ $user2Find = $null }
        }
    }
