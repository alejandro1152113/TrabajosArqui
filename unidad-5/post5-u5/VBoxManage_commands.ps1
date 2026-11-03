param(
    [ValidateSet('create', 'fixed-disk', 'list', 'export', 'nat', 'host-only', 'bridged', 'snapshot-base', 'snapshot-tools', 'restore-base', 'resources')]
    [string]$Action = 'list',
    [string]$IsoPath,
    [string]$AdapterName,
    [string]$VBoxManagePath = (Join-Path $env:ProgramFiles 'Oracle\VirtualBox\VBoxManage.exe')
)

$ErrorActionPreference = 'Stop'
$vmName = 'Lab5-Alpine'
$root = $PSScriptRoot
$dynamicDisk = Join-Path $root 'Lab5-Alpine.vdi'
$fixedDisk = Join-Path $root 'Lab5-Alpine-fixed.vdi'
$exportFile = Join-Path $root 'Lab5-Alpine-export.ova'

if (-not (Test-Path -LiteralPath $VBoxManagePath -PathType Leaf)) {
    throw "VBoxManage.exe was not found at '$VBoxManagePath'. Set -VBoxManagePath to its actual location."
}

function Invoke-VBoxManage {
    param([Parameter(Mandatory = $true)][string[]]$Arguments)

    & $VBoxManagePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "VBoxManage failed with exit code $LASTEXITCODE."
    }
}

function Test-VMRegistered {
    $output = & $VBoxManagePath list vms
    if ($LASTEXITCODE -ne 0) {
        throw "VBoxManage list vms failed with exit code $LASTEXITCODE."
    }
    return ($output | Where-Object { $_ -match ('^"' + [regex]::Escape($vmName) + '"\s') }).Count -gt 0
}

function Get-VMState {
    $output = & $VBoxManagePath showvminfo $vmName --machinereadable
    if ($LASTEXITCODE -ne 0) {
        throw "VBoxManage showvminfo failed with exit code $LASTEXITCODE."
    }
    $line = $output | Where-Object { $_ -match '^VMState=' } | Select-Object -First 1
    if (-not $line) {
        throw "Could not determine the state of '$vmName'."
    }
    return ($line -replace '^VMState="?', '' -replace '"$', '')
}

function Assert-VMOff {
    if (-not (Test-VMRegistered)) {
        throw "The VM '$vmName' is not registered."
    }
    if ((Get-VMState) -ne 'poweroff') {
        throw "Shut down '$vmName' from inside Alpine before this operation."
    }
}

switch ($Action) {
    'create' {
        if ([string]::IsNullOrWhiteSpace($IsoPath) -or -not (Test-Path -LiteralPath $IsoPath -PathType Leaf)) {
            throw 'Pass -IsoPath with the full path to alpine-standard-3.19.0-x86_64.iso.'
        }
        if (Test-VMRegistered) {
            throw "A VM named '$vmName' is already registered; no changes were made."
        }

        Invoke-VBoxManage @('createvm', '--name', $vmName, '--ostype', 'Linux_64', '--register')
        Invoke-VBoxManage @('modifyvm', $vmName, '--memory', '1024', '--vram', '16', '--cpus', '1', '--nic1', 'nat')
        Invoke-VBoxManage @('createmedium', 'disk', '--filename', $dynamicDisk, '--size', '10240', '--format', 'VDI', '--variant', 'Standard')
        Invoke-VBoxManage @('storagectl', $vmName, '--name', 'SATA', '--add', 'sata')
        Invoke-VBoxManage @('storageattach', $vmName, '--storagectl', 'SATA', '--port', '0', '--device', '0', '--type', 'hdd', '--medium', $dynamicDisk)
        Invoke-VBoxManage @('storagectl', $vmName, '--name', 'IDE', '--add', 'ide')
        Invoke-VBoxManage @('storageattach', $vmName, '--storagectl', 'IDE', '--port', '0', '--device', '0', '--type', 'dvddrive', '--medium', $IsoPath)
    }
    'fixed-disk' {
        Assert-VMOff
        if (Test-Path -LiteralPath $fixedDisk) {
            throw "The fixed disk already exists at '$fixedDisk'; no changes were made."
        }

        Invoke-VBoxManage @('createmedium', 'disk', '--filename', $fixedDisk, '--size', '4096', '--format', 'VDI', '--variant', 'Fixed')
        Invoke-VBoxManage @('storageattach', $vmName, '--storagectl', 'SATA', '--port', '1', '--device', '0', '--type', 'hdd', '--medium', $fixedDisk)
    }
    'list' {
        Invoke-VBoxManage @('showvminfo', $vmName)
        Invoke-VBoxManage @('snapshot', $vmName, 'list')
    }
    'nat' {
        if (-not (Test-VMRegistered)) {
            throw "The VM '$vmName' is not registered."
        }
        Invoke-VBoxManage @('modifyvm', $vmName, '--nic1', 'nat')
    }
    'host-only' {
        if ([string]::IsNullOrWhiteSpace($AdapterName)) {
            throw 'Pass -AdapterName with the exact name from VBoxManage list hostonlyifs.'
        }
        if (-not (Test-VMRegistered)) {
            throw "The VM '$vmName' is not registered."
        }
        Invoke-VBoxManage @('modifyvm', $vmName, '--nic1', 'hostonly', '--hostonlyadapter1', $AdapterName)
    }
    'bridged' {
        if ([string]::IsNullOrWhiteSpace($AdapterName)) {
            throw 'Pass -AdapterName with the exact host network adapter name.'
        }
        if (-not (Test-VMRegistered)) {
            throw "The VM '$vmName' is not registered."
        }
        Invoke-VBoxManage @('modifyvm', $vmName, '--nic1', 'bridged', '--bridgeadapter1', $AdapterName)
    }
    'snapshot-base' {
        if (-not (Test-VMRegistered)) {
            throw "The VM '$vmName' is not registered."
        }
        Invoke-VBoxManage @('snapshot', $vmName, 'take', 'snap_base', '--description', 'Alpine Linux limpio despues de la instalacion', '--live')
    }
    'snapshot-tools' {
        if (-not (Test-VMRegistered)) {
            throw "The VM '$vmName' is not registered."
        }
        Invoke-VBoxManage @('snapshot', $vmName, 'take', 'snap_con_herramientas', '--description', 'Alpine con curl, wget, nano y htop', '--live')
    }
    'restore-base' {
        Assert-VMOff
        Invoke-VBoxManage @('snapshot', $vmName, 'restore', 'snap_base')
        Invoke-VBoxManage @('startvm', $vmName, '--type', 'gui')
    }
    'resources' {
        Assert-VMOff
        Invoke-VBoxManage @('modifyvm', $vmName, '--cpus', '2', '--memory', '2048')
    }
    'export' {
        Assert-VMOff
        Invoke-VBoxManage @('export', $vmName, '--output', $exportFile, '--manifest')
        Get-Item -LiteralPath $exportFile | Select-Object Name, Length, FullName
    }
}
