Write-Host "Installing Andreas Converter Function"
Write-Host "Version: 0.3"

Function do-debug
{
    Write-Host "Functions are running!"
}

# PowerShell function to convert files in different types.
# Author: Andreas Frick
Write-Host "Installing Convert-File"
Function Convert-File {
    [cmdletbinding()]
    Param (
        [string] $sourceFile,
        [string] $convertTo
    )
    Process {

        [array] $allowedTypes = "xml", "json", "csv"

        [array]  $sourceFileType = $sourceFile.split(".")
        [string] $resultFile     = $sourceFileType[1]
        [string] $sourceFileType = $sourceFileType[2]
        [string] $resultFile     = "./" + $resultFile.trim("\", "/") + "." + $convertTo

        if(!$allowedTypes.Contains($sourceFileType)) {
            Write-Host "SourceFileType $sourceFileType not supported."
            return
        }

        if(!$allowedTypes.Contains($convertTo)) {
            Write-Host "ConvertType $convertTo not supported."
            return
        }

        # Write-Host "SourceFile:     $sourceFile"
        # Write-Host "ConvertTo:      $convertTo"
        # Write-Host "SourceFileType: $sourceFileType"
        # Write-Host "ResultFile:     $resultFile"
        # Write-Host "--------------------------------------"

        switch($sourceFileType) {
            "json" {
                switch($convertTo) {
                    "csv" {
                        Write-Host "json to csv"
                        $results = Get-Content -Path $sourceFile  | ConvertFrom-Json
                        $results | ConvertTo-Csv -NoTypeInformation | Set-Content $resultFile
                    }

                    "xml" {
                        Write-Host "json to xml"
                        [xml] $xmlDoc = New-Object System.Xml.XmlDocument
                        $xmlDeclaration = $xmlDoc.appendChild($xmlDoc.CreateXmlDeclaration("1.0","UTF-8",$null))
                        $xmlRows = $xmlDoc.appendChild($xmlDoc.CreateElement("rows"))

                        $results =  Get-Content -Path $sourceFile | ConvertFrom-Json
                        foreach ($row in $results) {
                            $xmlRow = $xmlRows.appendChild($xmlDoc.CreateElement("row"))
                            $props=Get-Member -InputObject $row -MemberType NoteProperty
                            foreach($prop in $props) {
                                $propValue = $row | Select-Object -ExpandProperty $prop.Name
                                $propName  = $prop.Name.ToLower()

                                $xmlValue = $xmlRow.appendChild($xmlDoc.CreateElement("$propName"))
                                $xmlValue.InnerText = $propValue
                            }
                        }

                        $xmlDoc.save($resultFile);
                    }
                }
            }

            "csv" {
                switch($convertTo) {
                    "json" {
                        Write-Host "csv to json"
                        import-csv $sourceFile | ConvertTo-Json | Add-Content -Path $resultFile
                    }

                    "xml" {
                        Write-Host "csv to xml"
                        [xml] $xmlDoc = New-Object System.Xml.XmlDocument
                        $xmlDeclaration = $xmlDoc.appendChild($xmlDoc.CreateXmlDeclaration("1.0","UTF-8",$null))
                        $xmlRows = $xmlDoc.appendChild($xmlDoc.CreateElement("rows"))

                        foreach ($row in import-csv $sourceFile) {
                            $xmlRow = $xmlRows.appendChild($xmlDoc.CreateElement("row"))
                            $props=Get-Member -InputObject $row -MemberType NoteProperty
                            foreach($prop in $props) {
                                $propValue = $row | Select-Object -ExpandProperty $prop.Name
                                $propName  = $prop.Name.ToLower()

                                $xmlValue = $xmlRow.appendChild($xmlDoc.CreateElement("$propName"))
                                $xmlValue.InnerText = $propValue
                            }
                        }

                        $xmlDoc.save($resultFile);
                    }
                }
            }

            "xml" {
                [xml] $xmlDoc = Get-Content -Path $sourceFile
                $xmlRows = $xmlDoc.getElementsByTagName("rows")

                $results = @()
                foreach ($xmlRow in $xmlRows.childNodes) {
                    $myObject = [PSCustomObject]@{}
                    foreach($xmlValue in $xmlRow.childNodes) {
                        $myObject | Add-Member -MemberType NoteProperty –Name $xmlValue.name –Value $xmlValue.innerText
                    }
                    $results += $myObject
                }

                switch($convertTo) {
                    "json" {
                        Write-Host "xml to json"
                        $results | ConvertTo-Json | Set-Content -Path "$resultFile" -Encoding UTF8
                    }

                    "csv" {
                        Write-Host "xml to csv"
                        $results | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | Set-Content -Path "$resultFile" -Encoding UTF8
                    }
                }
            }
        }
    }
}
Write-Host "Done"