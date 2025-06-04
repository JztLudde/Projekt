Import-Module ".\SystemCheck.psm1" -Force # Laddar in modulen för systemkontroll

$logPath = ".\system_log.txt" # Sökväg till en txt loggfil
$thresholdCPU = 85 # CPU-varningströskel (%)
$thresholdMemory = 1 # RAM-varningströskel (GB) 
$thresholdDiskSpacePercent = 10 # % - Varnar för hårddiskutrymme (% ledigt)

try {
    $usage = Get-SystemUsage # Hämtar aktuell CPU- och minnesanvändning
    $disks = Get-DiskSpace # Hämtar diskutrymme för alla enheter

    # Logga CPU och minne
    Write-Log -Message "CPU Usage: $($usage.CPUUsage)% | Free Memory: $($usage.FreeMemoryGB) GB" -Path $logPath

    # Loggar och kontrollerar varje disk i en Loop
    foreach ($disk in $disks) {
        Write-Log -Message "Disk $($disk.DeviceID): $($disk.FreeSpaceGB) GB free ($($disk.PercentFree)%)" -Path $logPath

        if ($disk.PercentFree -lt $thresholdDiskSpacePercent) {
            Write-Warning "Disk $($disk.DeviceID) har lågt diskutrymme: $($disk.PercentFree)% ledigt."
        }
    }

    # Varningar för CPU och minne
    if ($usage.CPUUsage -gt $thresholdCPU) {
        Write-Warning "CPU-användningen är kritiskt hög: $($usage.CPUUsage)%."
    }

    # Varnar för hög RAM-anvädning
    if ($usage.FreeMemoryGB -lt $thresholdMemory) {
        Write-Warning "Minnet är lågt: Endast $($usage.FreeMemoryGB) GB kvar."
    }
}
catch {
    Write-Error "Ett oväntat fel inträffade: $_" # Fångar och loggar fel som uppstår
}