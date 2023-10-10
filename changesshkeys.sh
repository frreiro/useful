#!/bin/bash

type=$1
# personal_alias="alias ssh-personal='bash ~/bin/bash/changesshkeys.sh personal'"
# office_alias="alias ssh-personal='bash ~/bin/bash/changesshkeys.sh office'"

aliasbashfile=./examplefile.txt
personal_alias="alias ssh-personal='bash changesshkeys.sh personal'"
office_alias="alias ssh-office='bash changesshkeys.sh office'"


if [ $(find $aliasbashfile -type f -exec grep -Hn "$personal_alias" {} \; | wc -l) -gt 0 ];
then
   echo "Found personal alias, adding office alias..."
   echo $office_alias >> $aliasbashfile 
elif [ $(find $aliasbashfile -type f -exec grep -Hn "$office_alias" {} \; | wc -l) -gt 0 ];
then
   echo "Found office alias, adding personal alias..."
   echo $personal_alias >> $aliasbashfile 
else
   echo $personal_alias >> $aliasbashfile 
   echo $office_alias >> $aliasbashfile 
   echo "Found nothing"
fi



if [[ $type == "personal" ]]; 
then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/personal_github
    echo "Personal key added"
    bash -i

elif [[ $type == "office" ]]; 
then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/ezops-key
    echo "Office key added"
    bash -i
else 
    echo "⚙️  You have to set a type of ssh key to configure:"
    echo "- personal"
    echo "- office"
fi

