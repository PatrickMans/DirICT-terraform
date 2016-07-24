<powershell>
Set-ExecutionPolicy RemoteSigned -Force

$env:FACTER_monitor_address = "${monitor_address}"

icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/relybv/dirict-profile_base/master/files/bootme.ps1')) -ArgumentList ("profile_base")
</powershell>
