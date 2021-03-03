gitinstall()
{
   # sudo apt-get install g++
   # sudo apt-get install make
   # git clone $1
    git -C /usr/local/src  clone $1
    cd /usr/local/src/$(basename $1)
   # cd $(basename $1)
    ./configure
    make 
    sudo make install
   # cd ..
   # rm -rf $(basename $1)
   # ls
   # pwd
}
