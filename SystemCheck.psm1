# Funktion för att hämta CPU och Minne
function Get-SystemUsage {
    try {
        # Hämtar information om CPU och minnes information via WMI 
        $cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
        $memory = Get-CimInstance Win32_OperatingSystem | 
                  Select-Object @{Name="FreeMemoryGB"; Expression={[math]::Round($_.FreePhysicalMemory / 1MB,2)}}

        # Returnerar värde typen PSCustomObject med CPU användning och minnes användning
        return [PSCustomObject]@{
            CPUUsage = $cpu
            FreeMemoryGB = $memory.FreeMemoryGB
        }
    }
    catch {
        # Skrivre ut fel utifall i catchen fel uppstår vid hämtning av systemanvändning
        Write-Error "Fel vid hämtning av systemanvändning: $_"
    }
}

# Funktion för att hämta disk utrymmet
function Get-DiskSpace {
    try {
        # Hämtar disk information via WMI och enbart från fasta diskar, alltså HDD och SSD
        $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
            Select-Object DeviceID, 
                @{Name="FreeSpaceGB"; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}},
                @{Name="SizeGB"; Expression={[math]::Round($_.Size / 1GB, 2)}},
                @{Name="UsedSpaceGB"; Expression={[math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)}},
                @{Name="PercentFree"; Expression={[math]::Round($_.FreeSpace / $_.Size * 100, 2)}}

        return $disks
    }
    catch {
        # Skriver ut fel i catchen utifall fel sker vid hämtningen av diskutrymme
        Write-Error "Fel vid hämtning av diskutrymme: $_"
    }
}

# funktion till att logga i loggfilen 
function Write-Log {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$true)][string]$Path
    )
    try {
        # Hämtar datum från år till sekund för att stämpla in i logg filen
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "$timestamp - $Message" | Out-File -FilePath $Path -Append
    }
    catch {
        # Skriver ut fel i catchen utifall fel uppstår vid loggning
        Write-Error "Kunde inte skriva till loggfil: $_"
    }
}

# exporterar modul funktionerna så att de kan köras i main.ps1
Export-ModuleMember -Function Get-SystemUsage, Get-DiskSpace, Write-Log
