# UserExplorer_powerShell
A routine task in a System Admin's day is to check user accounts to troubleshoot various access issues. While such information can be pulled from Active Directrory Users and Computers, Exchange Control/Admin Panel, Azure Admin Panel, O365 Admin Panel in Active Directory, Exchange, O365 and Skype For Business..

I came up with a unified platform to pull such information by a PowerShell script, where I keep adding functions to achive the different task as I need them. The script uses queries using various get commands. Please feel free to use it. I am not 

What you need:
-------------
1. To run the script on could use the normal PowerShell windoW or PowerShell ISE with execution-policy adjusted to run a script. https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6
2. AD_RSAT (e.g., https://www.microsoft.com/en-ca/download/details.aspx?id=45520)
3. Azure AD modules (Install-Module -Name AzureAD : https://docs.microsoft.com/en-us/office365/enterprise/powershell/connect-to-office-365-powershell) 
4. MSOL- Install-Module -Name MSOnline: https://www.powershellgallery.com/packages/MSOnline/1.1.183.17 
5. Skype For Business Online Module : https://www.microsoft.com/en-us/download/details.aspx?id=39366 
 
Structure:
----------

1. Get Static Data
2. Utility functions- Csometics, create output data folder abd Check user ID strings to extract username.
3. On Prem Connectors
4. Azure / O365 connectors
