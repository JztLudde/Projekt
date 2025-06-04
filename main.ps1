Import-Module ".\SystemCheck.psm1"

try {
    $usage = Get-SystemUsage
    $disk = Get-DiskSpace

    Write-Log -Message "CPU Usage: $($usage.CPUUsage)% - Free Memory: $($usage.FreeMemoryGB)GB" -Path $logPath
    Write-Log -Message "Disk Space: $($disk.FreeSpaceGB)GB" -Path $logPath

      if ($usage.CPUUsage -gt $thresholdCPU) {
        Write-Warning "CPU-användningen är hög: $($usage.CPUUsage)%"
    }