# While learning HASH and Regex I jotetd down ideas and notes to the following 2 functions. The two functions shoudl be run 
#from the same lcoation (file).


function chkHash{
    <#
    .SYNOPSIS
        Hash is Case Sensitive
    .Notes
        https://www.regular-expressions.info/dotnet.html
    #>
    param(
        [Parameter(Mandatory=$true)][string]$string2HASH
        )    
    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $utf8 = new-object -TypeName System.Text.UTF8Encoding
    $HASHValue = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($string2HASH)))
    return [string]($HASHValue)
    }

function doCompare{
    <#
    .SYNOPSIS
        ref: https://www.regular-expressions.info/unicode.html#prop
        Compares files, strings
    .Notes
      \p{L} matches a single code point in the category "letter".
      \p{Nd} or \p{Decimal_Digit_Number}: a digit zero through nine in any script except ideographic scripts. 
    #>
    param(
    [Parameter(Mandatory=$true)][string]$String2Compare,
    [Parameter(Mandatory=$true)][string]$String2CompareWith,
    [Parameter()][String]$CaseSensitive = 0
    )
    #need to revisit to clean up
    $NewString = (($String2Compare -replace '[^\p{L}\p{Nd}/(/}/_]', '').Replace(' ' , "")).trim()
    $OriginalString = (($String2CompareWith -replace '[^\p{L}\p{Nd}/(/}/_]', '').Replace(' ' , "")).trim()
    
    if($CaseSensitive -eq 'Yes'){
        $NewString = $NewString.ToUpper()
        $OriginalString = $OriginalString.ToUpper()        
        }

    $hashNewString = chkHash $NewString
    $hashOriginalString = chkHash $OriginalString

    echo "new: $hashNewString"
    echo "old: $hashOriginalString"
    if($hashNewString -eq $hashOriginalString){echo "cool"; return $true}
    else{return $false}
    #if($newString -match $originalString){return $true}
    }
    
    USAGE:
    ------
    
C:\Users\ratan\desktop> 

doCompare -String2Compare 'Ratan Kumar Mohapatra' -String2CompareWith 'Ratan Kumar Mohapatra' -CaseSensitive 1
new: 77-05-62-05-5A-D7-96-01-EB-AD-38-20-6A-7B-94-E9
old: 77-05-62-05-5A-D7-96-01-EB-AD-38-20-6A-7B-94-E9
cool
True

doCompare -String2Compare 'Ratan Kumar Mohapatra' -String2CompareWith 'RaTan Kumar Mohapatra' -CaseSensitive 1
new: 77-05-62-05-5A-D7-96-01-EB-AD-38-20-6A-7B-94-E9
old: 35-47-46-5D-2C-94-86-12-37-DD-02-08-C0-E4-8D-11
False
  
    
