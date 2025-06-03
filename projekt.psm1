Import-Module ".\SystemCheck.psm1"

$logPath = ".\system_log.txt"
$thresholdCPU = 85
$thresholdMemory = 1 # GB
$thresholdDiskSpace = 5 # GB