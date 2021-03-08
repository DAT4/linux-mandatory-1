RANDOM=$$
R=$(($RANDOM%10))
if [ $R -lt 5 ]
then
    echo ok
else
    echo doomed
fi

