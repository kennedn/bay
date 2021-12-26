# bay
A bare bones CLI frontend for finding magnet links in the command line using apibay.org, thepiratebay's internal JSON api.


### Prerequisites
- [jq](https://stedolan.github.io/jq/) installed and on system path
- A recent version of BASH
  
To install jq on debian based systems, run the following:
```bash
sudo apt update
sudo apt install jq
```

You can then run the script by doing the following:
```bash
chmod 744 bay.sh
./bay.sh
```

## Usage
```bash
usage: bay.sh [-t|-m|-c|-l|-h] [TERM]...
Query apibay for magnet links
Example: bay.sh the sopranos

Options:
  -t,--tv
        print top 100 tv shows
  -m,--movie
        print top 100 movies
  -c,--custom
        Display custom top 100 catagory
  -l,--list
        List top 100 keys, for use with -c
  -h,--help
        print this message
```
