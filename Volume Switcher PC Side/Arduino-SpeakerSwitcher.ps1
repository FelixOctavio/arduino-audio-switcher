$COM = [System.IO.Ports.SerialPort]::getportnames()

    $port= new-Object System.IO.Ports.SerialPort $COM,9600,None,8,one
    $port.Open()
    $port.WriteLine("Speaker")
    $port.Close()