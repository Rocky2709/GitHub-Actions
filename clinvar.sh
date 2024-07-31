#!/bin/bash

# URL of the file to download
FILE_URL1="https://ftp.ncbi.nlm.nih.gov/pub/clinvar/xml/weekly_release/ClinVarVCVRelease_00-latest_weekly.xml.gz"
FILE_URL2="https://ftp.ncbi.nlm.nih.gov/pub/clinvar/xml/weekly_release/ClinVarVCVRelease_00-latest_weekly.xml.gz.md5"

# Filename to save the downloaded file
now=$(date +"%Y-%m-%d")
FILE_NAME1="ClinVarVCVRelease_$now-latest_weekly.xml.gz"
FILE_NAME2="ClinVarVCVRelease_$now-latest_weekly.xml.gz.md5"

# Download the file using curl
echo "Downloading files..."
wget -o "$FILE_NAME1" "$FILE_URL1"
wget -o "$FILE_NAME2" "$FILE_URL2"

# Check if download was successful
if [ ! -f "$FILE_NAME1" ] || [ ! -f "$FILE_NAME2" ]; then
echo "File download failed!"
exit 1
else
echo "Downloads completed successfully."
fi

# Install AzCopy
echo "Installing AzCopy..."
wget -O azcopy_v10.tar.gz https://aka.ms/downloadazcopy-v10-linux
tar -xf azcopy_v10.tar.gz --strip-components=1
sudo cp ./azcopy /usr/local/bin/
chmod -R 777 /usr/local/bin/



#check if AzCopy is installed
if ! command -v azcopy &> /dev/null
then
echo "AzCopy could not be installed."
exit
else
echo "AzCopy installed successfully."
fi

# Azure Storage Account details
STORAGE_ACCOUNT_URL="https://sjcitest01.blob.core.windows.net/clinvar"
SAS_TOKEN="sp=racwdl&st=2024-07-30T23:43:49Z&se=2024-07-31T07:43:49Z&spr=https&sv=2022-11-02&sr=c&sig=bFuz9PITF8V6Ql7RwNLnA36PPw0UJR%2F6qPbf2jKK3lU%3D"

# Upload the file using AzCopy
echo "Uploading file to Azure Storage..."
azcopy copy "$FILE_NAME1" "$STORAGE_ACCOUNT_URL?$SAS_TOKEN"
azcopy copy "$FILE_NAME2" "$STORAGE_ACCOUNT_URL?$SAS_TOKEN"

echo "File upload completed."
