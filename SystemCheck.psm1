function Get-SystemUsage {
    try {
        $cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
        $memory = Get-CimInstance Win32_OperatingSystem | 
            Select-Object @{Name="FreeMemoryGB"; Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}}
        
        return [PSCustomObject]@{
            CPUUsage = $cpu
            FreeMemoryGB = $memory.FreeMemoryGB
    }
}
catch {
    Write-Error "Fel inträffade: $_"
}
}