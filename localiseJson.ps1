#iterate through all elements in the json file at path: public/webviewer/lib/ui/i18n/translation-en.json and add the word 'test' to the end of each value and convert back to json file names test.json

$code = "he"
function TranslateText($message) {
    #$code = "da"
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("Ocp-Apim-Subscription-Key", "replace")
    $headers.Add("Ocp-Apim-Subscription-Region", "northeurope")
    $headers.Add("Content-Type", "application/json")
    
    $body = "[`n    {`"Text`":`"$($message)`"}`n]"
    
    $response = Invoke-RestMethod "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=$($code)" -Method 'POST' -Headers $headers -Body $body
    return  $response.translations[0].text
    }

function Get-JsonFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    $json = Get-Content -Path $Path | ConvertFrom-Json -Depth 10 -AsHashtable
    
    $newjson = @{}
    foreach($firstlevel in $json.GetEnumerator()) {
        
        $newjson[$firstlevel.Name] = @{}
        
        foreach($secondlevel in $firstlevel.Value.GetEnumerator()) {
            if($secondlevel.Value.GetType().Name -eq "String") {
                $newjson[$firstlevel.Name][$secondlevel.Name] = TranslateText -message $secondlevel.Value
            }
            elseif($secondlevel.Value.GetType().Name -eq "OrderedHashtable") {
                $newjson[$firstlevel.Name][$secondlevel.Name] = @{}
                foreach($thirdlevel in $secondlevel.Value.GetEnumerator()) {
                    if($thirdlevel.Value.GetType().Name -eq "String") {
                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name] = TranslateText -message $thirdlevel.Value
                    }
                    elseif( $thirdlevel.Value.GetType().Name -eq "OrderedHashtable") {
                        
                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name] = @{}
                        foreach($fourthlevel in $thirdlevel.Value.GetEnumerator()) {
                            
                            if($fourthlevel.Value.GetType().Name -eq "String") {
                                
                                $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name] = TranslateText -message $fourthlevel.Value
                            
                            }
                            elseif($fourthlevel.Value.GetType().Name -eq "OrderedHashtable") {
                                $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name] = @{} 
                                foreach($fifthlevel in $fourthlevel.Value.GetEnumerator()) {
                                    if($fifthlevel.Value.GetType().Name -eq "String") {
                                        
                                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name] = TranslateText -message $fifthlevel.Value
                                        
                                    }
                                    elseif($fifthlevel.Value.GetType().Name -eq "OrderedHashtable") {
                                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name] = @{}
                                        foreach($sixthlevel in $fifthlevel.Value.GetEnumerator()) {
                                            if($sixthlevel.Value.GetType().Name -eq "String") {
                                               
                                                $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name][$sixthlevel.Name] = TranslateText -message $sixthlevel.Value
                                            }
                                            elseif($sixthlevel.Value.GetType().Name -eq "OrderedHashtable") {
                                               
                                                $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name][$sixthlevel.Name] = @{}
                                                foreach($seventhlevel in $sixthlevel.Value.GetEnumerator()) {
                                                    if($seventhlevel.Value.GetType().Name -eq "String") {
                                                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name][$sixthlevel.Name][$seventhlevel.Name] = $seventhlevel.Value + "test"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name] = @()
                                        foreach($sixthlevel in $fifthlevel.Value) {
                                            $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name][$fifthlevel.Name] += TranslateText -message $sixthlevel.Value
                                        }
                                    }
                                }
                              
                            }
                        }
                    }
                    else {
                        $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name] = @()
                        foreach($fourthlevel in $thirdlevel.Value.GetEnumerator()) {
                            if($fourthlevel.Value.GetType().Name -eq "String") {
                                $newjson[$firstlevel.Name][$secondlevel.Name][$thirdlevel.Name][$fourthlevel.Name] = TranslateText -message $fourthlevel.Value
                            }
                        }
                    }
                }
            }
            else {
                $newjson[$firstlevel.Name][$secondlevel.Name] = @()
               
                foreach($thirdlevel in $secondlevel.Value) {
                        $newjson[$firstlevel.Name][$secondlevel.Name] += TranslateText -message $thirdlevel.Value
                    
                }
            }
        
         
            
        }
    
        $newjson | ConvertTo-Json | Out-File "translation-${code}.json"

        


    }
}


Get-JsonFile -Path "public/webviewer/lib/ui/i18n/translation-en.json"