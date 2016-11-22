#!/bin/bash
# Author seaphy

# *************** readme ***************
# 1.mv the file into the root of $PROJECTNAME

# 2.1 chmod +x AutoBuildSFBestIphoneIpa.sh   and   ./AutoBuildSFBestIphoneIpa.sh
# 2.2 sh AutoBuildSFBestIphoneIpa.sh

PROJECTNAME=SFBestIphone
SCHEMENAME=SFBestIphone
APPNAME=shunfengyouxuan
BRANCHNAME=Release

DATE=`date +%Y%m%d_%H%M`
SOURCEPATH=$( cd "$(dirname $0 )" && pwd )
IPAPATH=$SOURCEPATH/ipas/$BRANCHNAME/$DATE
IPANAME=${APPNAME}_$DATE.ipa

# delete trash files
if [ -e $IPAPATH/* ]; then
  mv $IPAPATH/* ./ipas/trash/
  if [ $? -ne 0 ]; then
    echo "error: Delete trash files failed!!"
    exit 1
  fi
fi

# build SFBestIphone
xcodebuild \
  -project $SOURCEPATH/$PROJECTNAME.xcodeproj \
  -scheme $SCHEMENAME \
  -configuration $BRANCHNAME \
  clean \
  build \
  -derivedDataPath $IPAPATH

if [ -e $IPAPATH ]; then
  echo "xcodebuild Successful"
else
  echo "error:Build failed!!"
  exit 1
fi

# xcrun .ipa
xcrun -sdk iphoneos PackageApplication \
      -v $IPAPATH/Build/Products/$BRANCHNAME-iphoneos/$APPNAME.app \
      -o $IPAPATH/$IPANAME

if [ -e $IPAPATH/$IPANAME ]; then
  echo -e $IPAPATH/$IPANAME
  echo -e "\n-------------------------\n\n\n"
  echo -e "Configurations! Build Successful!"
  echo -e "\n\n\n-------------------------\n\n"
  open $IPAPATH
else
  echo -e "\n-------------------------------------------------------------------\n"
  echo -e "error:Create IPA failed!!"
  echo -e "\nPlease check the cause of failure and contact developers,thanks!"
  echo -e "\n-------------------------------------------------------------------\n"
fi

if [ -e $IPAPATH/$IPANAME ]; then
  # fir.im(need to install fir-cli)
  # sudo gem install fir-cli
  echo -e "\n-------------------------\n\n\n"
  echo -e "\nbegin login..."
  fir login -T e438b7f83c03c7953dbf668133a9223b
  echo -e "\nbegin upload..."
  fir publish $IPAPATH/$IPANAME
  echo -e "\nupload success."
fi

