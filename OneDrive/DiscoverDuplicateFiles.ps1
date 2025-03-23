# Define the path to your OneDrive folder
$OneDrivePath = "$env:USERPROFILE\OneDrive"

# Get all files in the OneDrive folder and its subfolders
$files = Get-ChildItem -Path $OneDrivePath -Recurse -File

# Group files by their names and sizes
$groupedFiles = $files | Group-Object Name, Length

# Filter groups that have more than one file (potential duplicates)
$duplicateGroups = $groupedFiles | Where-Object { $_.Count -gt 1 }

# Create a custom object to store duplicate file information
$duplicateFiles = foreach ($group in $duplicateGroups) {
    foreach ($file in $group.Group) {
        [PSCustomObject]@{
            FileName = $file.Name
            FilePath = $file.FullName
            FileSize = $file.Length
        }
    }
}

# Define the path to the CSV file
$csvPath = "$OneDrivePath\DuplicateFiles.csv"

# Export the duplicate file information to CSV
$duplicateFiles | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Duplicate file information has been exported to $csvPath"
