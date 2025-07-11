
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
    $Script:vms = $vms
    $Script:RemoveTag = $RemoveTag
    $Script:AddTag = $AddTag
}

function Update-Tag {
    try {
        $vms | Get-TagAssignment -Tag $RemoveTag | Remove-TagAssignment -Confirm
        $vms | New-TagAssignment -Tag $AddTag -Confirm
    } Catch {
        Write-Output "An error occurred: $($_.Exception.Message)"
    }
}

Connect-vSphere
Select-Vms
Update-Tag
Disconnect-VIServer

