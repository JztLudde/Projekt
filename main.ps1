Import-Module ".\SystemCheck.psm1"

try {
    $usage = Get-SystemUsage
    $disk = Get-DiskSpace

    Write-Log -Message "CPU Usage: $($usage.CPUUsage)% - Free Memory: $($usage.FreeMemoryGB)GB" -Path $logPath
    Write-Log -Message "Disk Space: $($disk.FreeSpaceGB)GB" -Path $logPath

      if ($usage.CPUUsage -gt $thresholdCPU) {
        Write-Warning "CPU-användningen är hög: $($usage.CPUUsage)%"
    }

      if ($usage.FreeMemoryGB -lt $thresholdMemory) {
        Write-Warning "Lite minne kvar: $($usage.FreeMemoryGB)GB"
    }

    if ($disk.FreeSpaceGB -lt $thresholdDiskSpace) {
        Write-Warning "Lite utrymme kvar på disk: $($disk.FreeSpaceGB)GB"
    }
}
catch {
    Write-Error "Ett fel inträffade: $_"
}