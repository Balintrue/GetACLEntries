<#
.Synopsis
    Outputs ACL information to a text file
.DESCRIPTION
    This script allows the user to enter a path and the number of subfolders to traverse. The information is formatted for readability and includes the path and time run in the header. The data is arranged by lowest depth, then alphabetically.
.EXAMPLE
    PS C:\PowerShell> .\GetACLEntries.ps1
    Enter the path you wish to check: C:\
    Enter Output File Name: security.txt
    Enter number of subfolders to traverse: 2
.OUTPUTS
   Outputs the file name specified to the root of the C folder by default
#>

#Set variables
$path = Read-Host "Enter the path you wish to check"
$date = Get-Date
$filename = Read-Host "Enter Output File Name"
$depth = Read-Host "Enter number of subfolders to traverse"
$recurse = @()

#Place Headers on output file
$list = "Permissions for directories in: $Path"
$datelist = "Report Run Time: $date"
$depthlist = "Depth traversed: $depth"
$list | format-table | Out-File "C:\$filename"
$datelist | format-table | Out-File -append "C:\$filename"
$depthlist | format-table | Out-File -append "C:\$filename"
$spacelist = " "
$spacelist | format-table | Out-File -append "C:\$filename"

#Create argument for traversing with specified depth
For ($i=1; $i -le [int] $depth; $i++) {
	$recurse += $path + ("\*" * $i)
}

#Fill folders array
[Array] $folders = Get-ChildItem -path $recurse -force  | Where {$_.PSIsContainer}

#Process data in array
ForEach ($folder in [Array] $folders) {
	#Convert Powershell Provider Folder Path to standard folder path
	$PSPath = (Convert-Path $folder.pspath)
	$list = ("Path: $PSPath")
	$list | format-table | Out-File -append "C:\$filename"

	Get-Acl -path $PSPath | Format-List -property AccessToString | Out-File -append "C:\$filename"
}