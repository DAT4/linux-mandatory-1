gitinstall()
{
    git -C /usr/local/src  clone $1
    cd /usr/local/src/$(basename $1)
    ./configure
    make 
    sudo make install
}
