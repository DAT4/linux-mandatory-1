gitinstall()
{
    git clone $1
    cd $(basename $1)
    ./configure
    make
    sudo make install
    cd ..
    rm -rf $(basename $1)
    ls
    pwd
}
