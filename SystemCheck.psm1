function Get-SystemUsage {
    try {
        $cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
        $memory = Get-CimInstance Win32_OperatingSystem | 
                  Select-Object @{Name="FreeMemoryGB"; Expression={[math]::Round($_.FreePhysicalMemory / 1MB,2)}}

        return [PSCustomObject]@{
            CPUUsage = $cpu
            FreeMemoryGB = $memory.FreeMemoryGB
        }
    }
    catch {
        Write-Error "Fel vid hämtning av systemanvändning: $_"
    }
}

function Get-DiskSpace {
    try {
        $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
            Select-Object DeviceID, 
                @{Name="FreeSpaceGB"; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}},
                @{Name="SizeGB"; Expression={[math]::Round($_.Size / 1GB, 2)}},
                @{Name="UsedSpaceGB"; Expression={[math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)}},
                @{Name="PercentFree"; Expression={[math]::Round($_.FreeSpace / $_.Size * 100, 2)}}

        return $disks
    }
    catch {
        Write-Error "Fel vid hämtning av diskutrymme: $_"
    }
}

function Write-Log {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$true)][string]$Path
    )
    try {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - $Message" | Out-File -FilePath $Path -Append
    }
    catch {
        Write-Error "Kunde inte skriva till loggfil: $_"
    }
}

Export-ModuleMember -Function Get-SystemUsage, Get-DiskSpace, Write-Log
