set -e 

fu()
{
    eval $FU
}

a()
{
    echo "echo $1 | sudo -S ls"
}

FU=$(a "newpdk1234")

fu $FU
