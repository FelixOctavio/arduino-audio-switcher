$COM = [System.IO.Ports.SerialPort]::getportnames()

    $port= new-Object System.IO.Ports.SerialPort $COM,9600,None,8,one
    $Port.Open()        
    $port.WriteLine("Headphone")
    $port.Close()