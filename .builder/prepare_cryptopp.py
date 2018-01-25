import os
import zipfile
import urllib

def change_runtime_library(folder, filename):
    with open(folder + os.sep + filename) as f:
        data = f.readlines()

    for i in range(len(data)):
        if '<RuntimeLibrary>MultiThreaded</RuntimeLibrary>' in data[i]:
            data[i] = data[i].replace('MultiThreaded', 'MultiThreadedDLL')
            print 'Changed', filename, 'library to MultiThreadedDLL'

    with open(folder + os.sep + filename, 'w') as f:
        f.writelines(data)

def unzip(filename, destination):
    with zipfile.ZipFile(filename) as zf:
        zf.extractall(destination)

print 'Downloading CryptoPP.'
# Please update this URL after new Crypto++ release.
urllib.urlretrieve ("https://github.com/weidai11/cryptopp/archive/CRYPTOPP_6_0_0.zip", "Crypto.zip")

print 'Unziping.'
unzip('Crypto.zip', '.')
folder = [i for i in os.listdir('.') if '.' not in i and 'crypto' in i][0]
unzip(folder + os.sep + 'vs2005.zip', folder +  os.sep + 'vs2005')

print 'Changing build configuration.'

files = ['cryptlib.vcxproj', 'cryptest.vcxproj']

for filename in files:
    change_runtime_library(folder, filename)
