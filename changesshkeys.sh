#!/bin/bash

type=$1
# personal_alias="alias ssh-personal='bash ~/bin/bash/changesshkeys.sh personal'"
# office_alias="alias ssh-personal='bash ~/bin/bash/changesshkeys.sh office'"

bin_path=/usr/local/bin/changesshkeys.sh
aliasbashfile=~/.bash_aliases
personal_alias="alias ssh-personal='bash $bin_path personal'"
office_alias="alias ssh-office='bash $bin_path office'"




has_alias(){
    has_personal_alias_text=$(find $aliasbashfile -type f -exec grep -Hn "$personal_alias" {} \; 2>/dev/null | wc -l)
    has_office_alias_text=$(find $aliasbashfile -type f -exec grep -Hn "$office_alias" {} \; 2>/dev/null | wc -l)

    if [[ $has_personal_alias_text -gt 0 && $has_office_alias_text -gt 0 ]];
    then
        return
    elif [[ $has_personal_alias_text -gt 0 ]];
    then
        echo "Found personal alias, adding office alias..."
        echo $office_alias >> $aliasbashfile 
    elif [[ $has_office_alias_text -gt 0 ]];
    then
        echo "Found office alias, adding personal alias..."
        echo $personal_alias >> $aliasbashfile 
    else
        echo $personal_alias >> $aliasbashfile 
        echo $office_alias >> $aliasbashfile
        echo "Found nothing, creating file and alias"
    fi
}



if [[ $type == "personal" ]]; 
then
    has_alias
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/personal_github
    echo "🧍 Personal key added"
    bash -i

elif [[ $type == "office" ]]; 
then
    has_alias
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/ezops-key
    echo "💼  Office key added"
    bash -i
else 
    echo "⚙️  You have to set a type of ssh key to configure:"
    echo "- personal"
    echo "- office"
fi

