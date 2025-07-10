
function Connect-vSphere {
    $cred = Get-Credential
    $serv = "vmware.jysk.com"
    connect-viserver -server $serv -credential $cred
}
function Select-Vms {
    $RemoveTag = Read-Host -Prompt "Enter the Tag to be removed"
    $vms = Get-VM -Tag $RemoveTag
    $vms | Format-Table -AutoSize
    $Confirmation = Read-Host "Do you want to remove $RemoveTag from this list of VMs? [y/n]"
    while ($Confirmation -ne "y") {
        $Filter = Read-Host -Prompt "Please enter a string that matches the vm or vms you want to select (Case Insensitive)"
        $vms = $vms | Where-Object { $_.Name -Match ".*$Filter.*"}
        $vms | Format-Table -AutoSize
        $Confirmation = Read-Host "Do you want to remove $RemoveTag from this list of VMs? [y/n]"
    }
    $AddTag = Read-Host -Prompt "Enter the Tag to be applied"
    return $vms, $RemoveTag, $AddTag
}

<#
function Update-Tag {
    param (
    )
    try {
        #Remove old tag and add the new one
        $OldTag = Get-Tag -Name $Rem
        $NewTag = Get-Tag -Name $Add
        $vms | Remove-TagAssignment -Tag $OldTag
        $vms | New-TagAssignment -Tag $NewTag
    } Catch {
        Write-Output "An error occurred: $($_.Exception.Message)"
    }
}
#>  

Connect-vSphere
Select-Vms
#Update-Tag -Rem $RemoveTag -Add $AddTag -Confirm

#dev notes:
#need to limit scope of changes further, by tag and other grouping