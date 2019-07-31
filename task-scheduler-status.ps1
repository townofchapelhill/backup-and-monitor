# Run PowerShell with administrator permissions.
If(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
{ 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}
Else
{
    $taskPath = "\OpenData\"
    $outCsv = "//CHFS/Shared Documents/OpenData/Task Scheduler Backup/script_status.csv"

    Get-ScheduledTask |
        ForEach-Object { [pscustomobject]@{
            Name = $_.TaskName
            Path = $_.TaskPath
            LastResult = $(($_| Get-ScheduledTaskInfo).LastTaskResult)
            NextRun = $(($_| Get-ScheduledTaskInfo).NextRunTime)
            Status = $_.State
            Command = $_.Actions.execute
            Arguments = $_.Actions.Arguments
        }
    } |
    Export-Csv -Path $outCsv -NoTypeInformation
}
