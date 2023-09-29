$COM = [System.IO.Ports.SerialPort]::getportnames()

    $port= new-Object System.IO.Ports.SerialPort COM13,230400,None,8,one
    $port.DtrEnable = $true
    $port.Open()
    & 'D:\Archive\PC\Project\Arduino\SystemVolume.exe'
    $port.WriteLine("Current Vol")
    Start-Sleep -s 1
    $X = Get-Clipboard
    $port.WriteLine($X)
    do {
        $line = $port.ReadLine()
        Write-Host $line # Do stuff here
            if ( $line -match 'Audio Routed to Speaker' ) 
            {
            & 'D:\Archive\PC\Project\Arduino\Speaker Icon.ahk'

            }elseif ( $line -match 'Audio Routed to Headphone' ) 
            {
            & 'D:\Archive\PC\Project\Arduino\Headphone Icon.ahk'
            }elseif ( $line -match 'Done' ) 
            {
            & 'D:\Archive\PC\Project\Arduino\SystemVolume.exe'
            Start-Sleep -s 1
            $X = Get-Clipboard
            $port.WriteLine($X)
            }      
    }
    while ($port.IsOpen)
